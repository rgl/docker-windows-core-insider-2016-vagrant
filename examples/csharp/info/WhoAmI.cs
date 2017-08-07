using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;

namespace Info
{
    public class WhoAmI
    {
        public class Account
        {
            public string Sid { get; set; }
            public string Domain { get; set; }
            public string Name { get; set; }
            public string Type { get; set; }
            public override string ToString()
            {
                return string.Format(
                    string.IsNullOrEmpty(Domain)
                        ? @"{1} ({2}; {3})"
                        : @"{0}\{1} ({2}; {3})",
                    Domain,
                    Name,
                    Sid,
                    Type);
            }
        }

        public class Whoami
        {
            public AccountAndAttributes User { get; internal set; }
            public AccountAndAttributes[] Groups { get; internal set; }
            public PrivilegeAndAttributes[] Privileges { get; internal set; }
        }

        public class AccountAndAttributes
        {
            public Account Account { get; set; }
            public string[] Attributes { get; set; }
            public override string ToString()
            {
                return string.Format("{0} {1}", Account.ToString(), string.Join("|", Attributes));
            }
        }

        public class PrivilegeAndAttributes
        {
            public string Privilege { get; set; }
            public string[] Attributes { get; set; }
            public override string ToString()
            {
                return string.Format("{0} {1}", Privilege, string.Join("|", Attributes));
            }
        }

        public static Whoami GetWhoami()
        {
            var processHandle = Process.GetCurrentProcess().SafeHandle.DangerousGetHandle();
            var processToken = IntPtr.Zero;
            if (!OpenProcessToken(processHandle, TOKEN_QUERY, ref processToken))
            {
                throw new Win32Exception();
            }
            try
            {
                return new Whoami
                {
                    User = GetTokenUser(processToken),
                    Groups = GetTokenGroups(processToken),
                    Privileges = GetTokenPrivileges(processToken),
                };
            }
            finally
            {
                if (!CloseHandle(processToken))
                {
                    throw new Win32Exception();
                }
            }
        }

        private const int TOKEN_QUERY = 0x00000008;

        [DllImport("advapi32", ExactSpelling = true, SetLastError = true)]
        private static extern IntPtr GetCurrentProcessToken();

        [DllImport("advapi32", ExactSpelling = true, SetLastError = true)]
        public static extern bool OpenProcessToken(IntPtr processHandle, int desiredAccess, ref IntPtr processToken);

        [DllImport("advapi32")]
        private static extern bool ConvertSidToStringSid(IntPtr pSID, ref string pStringSid);

        [DllImport("advapi32")]
        private static extern bool ConvertStringSidToSid(string pStringSid, ref IntPtr pSID);

        [DllImport("kernel32", SetLastError = true)]
        private static extern bool CloseHandle(IntPtr handle);

        private enum SID_NAME_USE
        {
            User = 1,
            Group,
            Domain,
            Alias,
            WellKnownGroup,
            DeletedAccount,
            Invalid,
            Unknown,
            Computer,
            Label
        }

        private enum TOKEN_INFORMATION_CLASS
        {
            TokenUser = 1,
            TokenGroups,
            TokenPrivileges,
            TokenOwner,
            TokenPrimaryGroup,
            TokenDefaultDacl,
            TokenSource,
            TokenType,
            TokenImpersonationLevel,
            TokenStatistics,
            TokenRestrictedSids,
            TokenSessionId
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct TOKEN_USER
        {
            public SID_AND_ATTRIBUTES User;
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct TOKEN_GROUPS
        {
            public uint GroupCount;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
            public SID_AND_ATTRIBUTES[] Groups;
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct SID_AND_ATTRIBUTES
        {
            public IntPtr Sid;
            public uint Attributes;
        }

        [DllImport("advapi32", SetLastError = true)]
        private static extern bool GetTokenInformation(
            IntPtr hToken,
            TOKEN_INFORMATION_CLASS tokenInfoClass,
            IntPtr tokenInformation,
            int tokenInformationLength,
            ref int requiredLength);

        [DllImport("advapi32", SetLastError = true)]
        private static extern bool LookupAccountSid(
            string systemName,
            IntPtr sid,
            StringBuilder name,
            ref int cbName,
            StringBuilder domainName,
            ref int cbDomainName,
            out SID_NAME_USE use);

        [DllImport("advapi32", SetLastError = true)]
        protected static extern bool LookupPrivilegeName(string lpSystemName, ref LUID lpLuid, StringBuilder lpName, ref int cchName);

        private static Account GetAccount(IntPtr sid)
        {
            var nameStringBuilder = new StringBuilder(255);
            var nameStringBuilderCapacity = nameStringBuilder.Capacity;
            var domainStringBuilder = new StringBuilder(255);
            var domainStringBuilderCapacity = domainStringBuilder.Capacity;
            SID_NAME_USE nameUse;
            if (!LookupAccountSid(
                null,
                sid,
                nameStringBuilder,
                ref nameStringBuilderCapacity,
                domainStringBuilder,
                ref domainStringBuilderCapacity,
                out nameUse))
            {
                //throw new Win32Exception();
                // NB in nano server the SID S-1-5-93-0 fails to be found for some reason... so we do not throw an exception on error.
                return new Account
                {
                    Sid = SidToString(sid),
                    Domain = "",
                    Name = "!!NOT-FOUND!!",
                    Type = "Unknown",
                };
            }
            return new Account
            {
                Sid = SidToString(sid),
                Domain = domainStringBuilder.ToString(),
                Name = nameStringBuilder.ToString(),
                Type = nameUse.ToString(),
            };
        }

        private static string SidToString(IntPtr sid)
        {
            string s = "";
            ConvertSidToStringSid(sid, ref s);
            return s;
        }

        private static AccountAndAttributes GetTokenUser(IntPtr token)
        {
            const int bufferSize = 256;
            var buffer = Marshal.AllocHGlobal(bufferSize);
            try
            {
                int requiredSize = bufferSize;
                if (!GetTokenInformation(token, TOKEN_INFORMATION_CLASS.TokenUser, buffer, bufferSize, ref requiredSize))
                {
                    throw new Win32Exception();
                }
                var tokenUser = (TOKEN_USER)Marshal.PtrToStructure(buffer, typeof(TOKEN_USER));
                return new AccountAndAttributes
                {
                    Account = GetAccount(tokenUser.User.Sid),
                    Attributes = new string[0],
                };
            }
            finally
            {
                Marshal.FreeHGlobal(buffer);
            }
        }

        private static AccountAndAttributes[] GetTokenGroups(IntPtr token)
        {
            const int bufferSize = 10 * 1024;
            var buffer = Marshal.AllocHGlobal(bufferSize);
            try
            {
                int requiredSize = bufferSize;
                if (!GetTokenInformation(token, TOKEN_INFORMATION_CLASS.TokenGroups, buffer, bufferSize, ref requiredSize))
                {
                    throw new Win32Exception();
                }
                var tokenGroups = (TOKEN_GROUPS)Marshal.PtrToStructure(buffer, typeof(TOKEN_GROUPS));
                var groups = new SID_AND_ATTRIBUTES[tokenGroups.GroupCount];
                PtrToStructureArray(groups, new IntPtr(buffer.ToInt64() + Marshal.OffsetOf(typeof(TOKEN_GROUPS), "Groups").ToInt64()));
                return groups.Select(
                        g => new AccountAndAttributes
                        {
                            Account = GetAccount(g.Sid),
                            Attributes = GetGroupAttributes(g.Attributes),
                        }
                    ).ToArray();
            }
            finally
            {
                Marshal.FreeHGlobal(buffer);
            }
        }

        [Flags]
        private enum GroupAttribute : uint
        {
            Enabled = 0x00000004,
            EnabledByDefault = 0x00000002,
            Integrity = 0x00000020,
            IntegrityEnabled = 0x00000040,
            LogonId = 0xc0000000,
            Mandatory = 0x00000001,
            Owner = 0x00000008,
            Resource = 0x20000000,
            UseForDenyOnly = 0x00000010,
        }

        [Flags]
        private enum PrivilegeAttribute : uint
        {
            EnabledByDefault = 0x00000001,
            Enabled = 0x00000002,
            Removed = 0X00000004,
            UsedForAccess = 0x80000000,
        }

        private static string[] GetGroupAttributes(uint attributes)
        {
            // TODO list unknown bits.
            return GetFlags((GroupAttribute)attributes).ToArray();
        }

        private static IEnumerable<string> GetFlags(Enum input)
        {
            foreach (Enum value in Enum.GetValues(input.GetType()))
            {
                if (input.HasFlag(value))
                {
                    yield return value.ToString();
                }
            }
        }

        static void PtrToStructureArray<T>(T[] arr, IntPtr start)
        {
            var stride = Marshal.SizeOf<T>();
            var ptr = start.ToInt64();
            for (int i = 0; i < arr.Length; i++, ptr += stride)
            {
                arr[i] = (T)Marshal.PtrToStructure(new IntPtr(ptr), typeof(T));
            }
        }

        protected struct TOKEN_PRIVILEGES
        {
            public UInt32 PrivilegeCount;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
            public LUID_AND_ATTRIBUTES[] Privileges;
        }

        [StructLayout(LayoutKind.Sequential)]
        protected struct LUID_AND_ATTRIBUTES
        {
            public LUID Luid;
            public uint Attributes;
        }

        [StructLayout(LayoutKind.Sequential)]
        protected struct LUID
        {
            public uint LowPart;
            public int HighPart;
        }

        private static PrivilegeAndAttributes[] GetTokenPrivileges(IntPtr token)
        {
            const int bufferSize = 10 * 1024;
            var buffer = Marshal.AllocHGlobal(bufferSize);
            try
            {
                int requiredSize = bufferSize;
                if (!GetTokenInformation(token, TOKEN_INFORMATION_CLASS.TokenPrivileges, buffer, bufferSize, ref requiredSize))
                {
                    throw new Win32Exception();
                }
                var tokenGroups = (TOKEN_PRIVILEGES)Marshal.PtrToStructure(buffer, typeof(TOKEN_PRIVILEGES));
                var privileges = new LUID_AND_ATTRIBUTES[tokenGroups.PrivilegeCount];
                PtrToStructureArray(privileges, new IntPtr(buffer.ToInt64() + Marshal.OffsetOf(typeof(TOKEN_PRIVILEGES), "Privileges").ToInt64()));
                return privileges.Select(
                        p => new PrivilegeAndAttributes
                        {
                            Privilege = GetPrivilegeName(p.Luid),
                            Attributes = GetPrivilegeAttributes(p.Attributes),
                        }
                    ).ToArray();
            }
            finally
            {
                Marshal.FreeHGlobal(buffer);
            }
        }

        private static string GetPrivilegeName(LUID luid)
        {
            var nameStringBuilder = new StringBuilder(255);
            var nameStringBuilderCapacity = nameStringBuilder.Capacity;
            if (!LookupPrivilegeName(null, ref luid, nameStringBuilder, ref nameStringBuilderCapacity))
            {
                throw new Win32Exception();
            }
            return nameStringBuilder.ToString();
        }

        private static string[] GetPrivilegeAttributes(uint attributes)
        {
            // TODO list unknown bits.
            return GetFlags((PrivilegeAttribute)attributes).ToArray();
        }
    }
}
