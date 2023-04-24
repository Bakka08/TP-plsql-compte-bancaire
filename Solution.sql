CREATE OR REPLACE TYPE Compte AS OBJECT (
  RIB VARCHAR2(50),
  type_compte VARCHAR2(50),
  CIN VARCHAR2(20),
  nom VARCHAR2(50),
  solde NUMBER,

  CONSTRUCTOR FUNCTION Compte(p_RIB VARCHAR2, p_type_compte VARCHAR2, p_CIN VARCHAR2, p_nom VARCHAR2, p_solde NUMBER) RETURN SELF AS RESULT,

  MEMBER PROCEDURE versement (montant NUMBER),
  MEMBER FUNCTION compare (c2 IN Compte) RETURN NUMBER,
  MEMBER FUNCTION afficher RETURN VARCHAR2,
  MEMBER PROCEDURE retrait (montant NUMBER)
);

CREATE OR REPLACE TYPE BODY Compte AS
  CONSTRUCTOR FUNCTION Compte(p_RIB VARCHAR2, p_type_compte VARCHAR2, p_CIN VARCHAR2, p_nom VARCHAR2, p_solde NUMBER) RETURN SELF AS RESULT IS
  BEGIN
    self.RIB := p_RIB;
    self.type_compte := p_type_compte;
    self.CIN := p_CIN;
    self.nom := p_nom;
    self.solde := p_solde;
    RETURN;
  END;

  MEMBER PROCEDURE versement (montant NUMBER) IS
  BEGIN
    IF montant > 0 THEN
      self.solde := self.solde + montant;
      DBMS_OUTPUT.PUT_LINE('Versement de ' || montant || ' DH effectué avec succès!');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Le montant doit être positif!');
    END IF;
  END;

  MEMBER FUNCTION compare (c2 IN Compte) RETURN NUMBER IS
  BEGIN
    IF self.solde > c2.solde THEN
      DBMS_OUTPUT.PUT_LINE('Le solde du compte ' || self.RIB || ' est supérieur au solde du compte ' || c2.RIB);
      RETURN 1;
    ELSIF self.solde = c2.solde THEN
      DBMS_OUTPUT.PUT_LINE('Le solde du compte ' || self.RIB || ' est égal au solde du compte ' || c2.RIB);
      RETURN 0;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Le solde du compte ' || self.RIB || ' est inférieur au solde du compte ' || c2.RIB);
      RETURN -1;
    END IF;
  END;

  MEMBER FUNCTION afficher RETURN VARCHAR2 IS
  BEGIN
    RETURN 'RIB: ' || self.RIB || ', Type de compte: ' || self.type_compte || ', CIN: ' || self.CIN || ', Nom: ' || self.nom || ', Solde: ' || self.solde;
  END;
  MEMBER PROCEDURE retrait (montant NUMBER) IS
  BEGIN
    IF self.solde >= montant THEN
      IF (self.type_compte = 'compte_étudiant' AND montant <= 1000) OR 
         (self.type_compte = 'compte_courant' AND montant <= 5000) OR 
         (self.type_compte = 'compte_commerçant' AND montant <= 10000) OR 
         (self.type_compte = 'compte_vip') THEN
        self.solde := self.solde - montant;
        DBMS_OUTPUT.PUT_LINE('Retrait de ' || montant || ' DH effectué avec succès!');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Limite de retrait dépassée pour ce type de compte!');
      END IF;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Solde insuffisant!');
    END IF;
  END;
END;





DECLARE
  c1 Compte;
  c2 Compte;
  c3 Compte;
  max_etudiant Compte;
BEGIN
  c1 := new Compte(p_RIB => '1245887', p_type_compte => 'compte_étudiant', p_CIN => 'AA12580', p_nom => 'Ali', p_solde => 2580.14);
  c2 := new Compte(p_RIB => '7894561', p_type_compte => 'compte_étudiant', p_CIN => 'BB24681', p_nom => 'mariam', p_solde => 3000.00);
  c3 := new Compte(p_RIB => '1597532', p_type_compte => 'compte_étudiant', p_CIN => 'CC36912', p_nom => 'imane', p_solde => 4500.00);

 DBMS_OUTPUT.PUT_LINE(c1.afficher());  
 DBMS_OUTPUT.PUT_LINE(c2.afficher());  
 DBMS_OUTPUT.PUT_LINE(c3.afficher());  

  max_etudiant := c1;

  IF c2.compare(max_etudiant) = 1 THEN
    max_etudiant := c2;
  END IF;
  
  IF c3.compare(max_etudiant) = 1 THEN
    max_etudiant := c3;
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Le compte étudiant avec le solde le plus élevé est:');
 DBMS_OUTPUT.PUT_LINE(max_etudiant.afficher());  
END;