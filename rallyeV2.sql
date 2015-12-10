
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';



CREATE SCHEMA IF NOT EXISTS `Rallye` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `Rallye` ;


CREATE TABLE IF NOT EXISTS `Rallye`.`Auteur` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Rallye`.`Editeur` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `Rallye`.`Quizz` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `idFiche` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idFiche_UNIQUE` (`idFiche` ASC))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Rallye`.`Livre` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `titre` VARCHAR(45) NOT NULL,
  `couverture` VARCHAR(45) NULL,
  `IdAuteur` INT NOT NULL,
  `idEditeur` INT NOT NULL,
  `idQuizz` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Livre_Auteur1_idx` (`IdAuteur` ASC),
  INDEX `fk_Livre_Editeur1_idx` (`idEditeur` ASC),
  INDEX `fk_Livre_Quizz1_idx` (`idQuizz` ASC),
  CONSTRAINT `fk_Livre_Auteur1`
    FOREIGN KEY (`IdAuteur`)
    REFERENCES `Rallye`.`Auteur` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Livre_Editeur1`
    FOREIGN KEY (`idEditeur`)
    REFERENCES `Rallye`.`Editeur` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Livre_Quizz1`
    FOREIGN KEY (`idQuizz`)
    REFERENCES `Rallye`.`Quizz` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Rallye`.`Question` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `question` VARCHAR(255) NOT NULL,
  `points` INT NOT NULL,
  `idQuizz` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Question_Quizz1_idx` (`idQuizz` ASC),
  CONSTRAINT `fk_Question_Quizz1`
    FOREIGN KEY (`idQuizz`)
    REFERENCES `Rallye`.`Quizz` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `Rallye`.`Proposition` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `proposition` VARCHAR(255) NOT NULL,
  `solution` INT NOT NULL,
  `idQuestion` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Proposition_Question_idx` (`idQuestion` ASC),
  CONSTRAINT `fk_Proposition_Question`
    FOREIGN KEY (`idQuestion`)
    REFERENCES `Rallye`.`Question` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Rallye`.`Rallye` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `dateDebut` DATE NULL,
  `duree` INT NOT NULL,
  `theme` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `Rallye`.`Comporter` (
  `idLivre` INT NOT NULL,
  `idRallye` INT NOT NULL,
  PRIMARY KEY (`idLivre`, `idRallye`),
  INDEX `fk_Comporter_Livre1_idx` (`idLivre` ASC),
  INDEX `fk_Comporter_Rallye1_idx` (`idRallye` ASC),
  CONSTRAINT `fk_Comporter_Livre1`
    FOREIGN KEY (`idLivre`)
    REFERENCES `Rallye`.`Livre` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comporter_Rallye1`
    FOREIGN KEY (`idRallye`)
    REFERENCES `Rallye`.`Rallye` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Rallye`.`Enseignant` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `prenom` VARCHAR(45) NOT NULL,
  `login` VARCHAR(45) NOT NULL,
  `password` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Rallye`.`Niveau` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `niveauscolaire` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Rallye`.`Classe` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `anneescolaire` VARCHAR(45) NOT NULL,
  `idEnseignant` INT NOT NULL,
  `idNiveau` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Classe_Enseignant1_idx` (`idEnseignant` ASC),
  INDEX `fk_Classe_Niveau1_idx` (`idNiveau` ASC),
  CONSTRAINT `fk_Classe_Enseignant1`
    FOREIGN KEY (`idEnseignant`)
    REFERENCES `Rallye`.`Enseignant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Classe_Niveau1`
    FOREIGN KEY (`idNiveau`)
    REFERENCES `Rallye`.`Niveau` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Rallye`.`Eleve` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `prenom` VARCHAR(45) NOT NULL,
  `login` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `idClasse` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Eleve_Classe1_idx` (`idClasse` ASC),
  CONSTRAINT `fk_Eleve_Classe1`
    FOREIGN KEY (`idClasse`)
    REFERENCES `Rallye`.`Classe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Rallye`.`Participer` (
  `idRallye` INT NOT NULL,
  `idEleve` INT NOT NULL,
  PRIMARY KEY (`idEleve`, `idRallye`),
  INDEX `fk_Participer_Eleve1_idx` (`idEleve` ASC),
  CONSTRAINT `fk_Participer_Rallye1`
    FOREIGN KEY (`idRallye`)
    REFERENCES `Rallye`.`Rallye` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Participer_Eleve1`
    FOREIGN KEY (`idEleve`)
    REFERENCES `Rallye`.`Eleve` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `Rallye`.`Reponse` (
  `idProposition` INT NOT NULL,
  `idQuestion` INT NOT NULL,
  `idParticiperRallye` INT NOT NULL,
  `idParticiperEleve` INT NOT NULL,
  PRIMARY KEY (`idProposition`, `idQuestion`, `idParticiperRallye`, `idParticiperEleve`),
  INDEX `fk_Reponse_Question1_idx` (`idQuestion` ASC),
  INDEX `fk_Reponse_Participer1_idx` (`idParticiperRallye` ASC, `idParticiperEleve` ASC),
  CONSTRAINT `fk_Reponse_Proposition1`
    FOREIGN KEY (`idProposition`)
    REFERENCES `Rallye`.`Proposition` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reponse_Question1`
    FOREIGN KEY (`idQuestion`)
    REFERENCES `Rallye`.`Question` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reponse_Participer1`
    FOREIGN KEY (`idParticiperRallye` , `idParticiperEleve`)
    REFERENCES `Rallye`.`Participer` (`idRallye` , `idEleve`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
