using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Novacode;
using System.IO;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using Image = Novacode.Image;
using MySql.Data.MySqlClient;
//using System.Windows.Documents;
//using System.Object;
//using System.MarshalByRefObject;
//using System.IO.FileSystemInfo;
//using System.IO.FileInfo;



namespace RallyeLecture
{
    class ExempleDocX
    {

        #region ExtractionQuizz
        public static void ExtractionQuizz(string fiche)
        {
            Console.WriteLine("document {0}", fiche);
            int index = 1;
            // ouvre un document word.
            using (DocX document = DocX.Load(fiche))
            {
                //Parcours de tous les paragraphes du document et affichage sur la console
                foreach (Novacode.Paragraph p in document.Paragraphs)
                {
                    Console.WriteLine("paragraphe {0} : {1}", index, p.Text);
                    index++;
                }

            } // le document word est fermé.
        }
        #endregion
        #region getIdFiche
        private static int getIdFiche(string nomfiche)
        {
            string[] IdFichier = nomfiche.Split(' ');
            int idFiche = Convert.ToInt32(IdFichier[1]);

            return idFiche;
        }
        #endregion
        #region ExtractionPhoto
        public static void ExtractionPhoto(string fiche)
        {
            string sCnx = "server=laudanum;uid=barth;database=rallye;pwd=siojjr";
            MySqlConnection Cnx = new MySqlConnection(sCnx);
           try 
	       {	        
		        Cnx.Open();
                Console.WriteLine("Connexion réussie");
	       }
	       catch (Exception e)
	       {
		
		   Console.WriteLine("Erreur connexion" +e.Message.ToString());
	       }
            DirectoryInfo repertoire = new DirectoryInfo("G:/PPE/02 alimentation Base De données/ressources/documentsWord");
            // ouvre un document word.
            using (DocX document = DocX.Load(fiche))
            {
                string auteur = "";
                string editeur = "";
                string titre = "";
                
                int index = 0;
                String[] vraiediteur;
                String[] vraiauteur;
                // On parcourt les lignes du document
                    foreach (Novacode.Paragraph item in document.Paragraphs)
                    {
                        bool ok = false;
                        index = index + 1;
                        // Si la ligne équvaut à 6 on affiche le titre
                        if (index == 6)
                        {
                            titre = item.Text;
                            titre = titre.Trim();
                            Console.WriteLine(titre);
                        }
                        // Si la ligne équivaut à 9 on affiche l'éditeur et l'auteur
                        if (index == 9)
                        {
                            auteur = item.Text;
                            editeur = item.Text;
                            auteur=auteur.Trim();
                            editeur = editeur.Trim();
                            auteur = auteur.Remove(0, 3);
                            Console.WriteLine(auteur);
                            vraiauteur = auteur.Split('–');
                            vraiediteur = editeur.Split('–');
                            vraiauteur[0] = vraiauteur[0].Trim();
                            vraiediteur[1] = vraiediteur[1].Trim();
                            Console.WriteLine(vraiauteur[0]);
                            Console.WriteLine(vraiediteur[1]);
                            string requeteInsert = @"insert into auteur(nom) values('" + vraiauteur[0] + "');insert into editeur(nom) values('" + vraiediteur[1] + "');insert into livre(titre, IdAuteur,idEditeur,couverture) values('" + titre + "',(Select id from auteur where '" + vraiauteur[0] + "' = nom),(Select id from editeur where '" + vraiediteur[1] + "' = nom), 'livre''" + getIdFiche(fiche) + "''.jpeg');";
                            MySqlCommand insertAuteur = new MySqlCommand(); // nouvelle commande
                            insertAuteur.Connection = Cnx; // connexion
                            insertAuteur.CommandType = CommandType.Text;
                            insertAuteur.CommandText = requeteInsert; // nom de la commande;
                            insertAuteur.Prepare();
                            try
                            {
                                insertAuteur.ExecuteNonQuery();
                            }
                            catch (Exception e)
                            {
                                Console.WriteLine(e.Message);
                            }
                        } 
                   }
                // On parcourt toutes les images du document word
                foreach (Novacode.Image image in document.Images)
                {
                    try
                    {
                        // récupération du flux image
                        Stream s = image.GetStream(FileMode.Open, FileAccess.Read);
                        // instanciation d'un objet de type image
                        Bitmap b = new Bitmap(s);
                        //Sauvegarde de l'image au format jpeg
                        string titreDocument = Path.GetFileNameWithoutExtension(fiche).Remove(0, 10);
                        
                        b.Save(@"G:\PPE\" +titreDocument+ ".Jpeg", ImageFormat.Jpeg);
                    }
                    catch
                    {
                        //la conversion est impossible ce n'est pas une image. rien n'est fait
                    }
                }
                
            } 

        }
        #endregion

    }
}
