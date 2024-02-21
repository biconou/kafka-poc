DROP TABLE "commande-aggregate";

CREATE TABLE "commande-aggregate"
(
   societe_facturation   TEXT,
   societe_livraison     TEXT,
   code_avancement       TEXT,
   numero_commande       TEXT,
   numero_version        TEXT,
   date_accordee_client  TEXT,
   PRIMARY KEY (societe_livraison, numero_commande)
);

CREATE TABLE "commande-op-join"
(
   societe_facturation   TEXT,
   societe_livraison     TEXT,
   code_avancement       TEXT,
   numero_commande       TEXT,
   numero_version        TEXT,
   date_accordee_client  TEXT,
   date_creation_oms     TEXT,
   statut                TEXT,
   PRIMARY KEY (societe_livraison, numero_commande)
);

