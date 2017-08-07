using System;
using System.Collections;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace Info
{
    class Program
    {
        static void Main(string[] args)
        {
            DumpProgramCommandLine();
            DumpProgramArguments(args);
            DumpEnvironment();
            DumpLoadedAssemblies();
            DumpFiles();
            DumpWhoAmI();
        }

        private static void DumpProgramCommandLine()
        {
            WriteTitle("Program Command Line");
            Console.WriteLine(Environment.CommandLine);
        }

        private static void DumpProgramArguments(string[] args)
        {
            if (args == null || args.Length == 0)
            {
                return;
            }

            WriteTitle("Program Arguments");
            foreach (var arg in args)
            {
                Console.WriteLine(arg);
            }
        }

        private static void DumpEnvironment()
        {
            WriteTitle("Environment Variables");
            foreach (var de in Environment.GetEnvironmentVariables().Cast<DictionaryEntry>().OrderBy(de => de.Key))
            {
                Console.WriteLine($"{de.Key}={de.Value}");
            }
        }

        private static void DumpLoadedAssemblies()
        {
            WriteTitle("Loaded Assemblies");
            foreach (var a in AppDomain.CurrentDomain.GetAssemblies().OrderBy(a => a.Location))
            {
                var match = Regex.Match(a.FullName, ".+ Version=(.+), Culture=.+");
                if (!match.Success)
                {
                    continue;
                }
                Console.WriteLine($"{a.Location} {match.Groups[1]}");
            }
        }

        private static void DumpFiles()
        {
            WriteTitle("Files");
            foreach (var f in Directory.EnumerateFiles(Directory.GetCurrentDirectory()).OrderBy(f => f))
            {
                Console.WriteLine(f);
            }
        }

        private static void DumpWhoAmI()
        {
            var i = WhoAmI.GetWhoami();

            WriteTitle("Who Am I: User");
            Console.WriteLine(i.User);

            WriteTitle("Who Am I: Groups");
            foreach (var g in i.Groups.OrderBy(g => g.Account.ToString()))
            {
                Console.WriteLine($"{g.Account} {string.Join(",", g.Attributes)}");
            }

            WriteTitle("Who Am I: Privileges");
            foreach (var p in i.Privileges.OrderBy(g => g.Privilege))
            {
                Console.WriteLine($"{p.Privilege} {string.Join(",", p.Attributes)}");
            }
        }

        private static void WriteTitle(string title)
        {
            Console.WriteLine("#");
            Console.WriteLine($"# {title}");
            Console.WriteLine("#");
        }
    }
}
