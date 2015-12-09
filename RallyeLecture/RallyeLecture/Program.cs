using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Novacode;
using System.IO;
using System.Data;
using MySql.Data.MySqlClient;

namespace RallyeLecture
{
    class Program
    {
        static void Main(string[] args)
        {
            
            string path = @"G:\PPE\02 alimentation Base De données\ressources\documentsWord";
            string file = path + @"\Fiche 035 JournalDunChatAssassin.docx";
           
            
            

            ExempleDocX.ExtractionQuizz(file);
            ExempleDocX.ExtractionPhoto(file);
           
            Console.ReadLine();

        }
    }
}
