/*drop existing tables*/
DROP TABLE "LOCALITIES";
DROP TABLE "COUNTIES";
DROP TABLE "COUNTRIES";

CREATE TABLE "COUNTRIES" (
    "COUNTRY_ID"    NUMBER(10, 0) NOT NULL,
    "COUNTRY_CODE"  VARCHAR2(15) NOT NULL,
    "COUNTRY_NAME"  VARCHAR2(60),
    "UPDATE_DATE"   DATE NOT NULL,
    CONSTRAINT "PK_COUNTRIES" PRIMARY KEY ( "COUNTRY_ID" ),
    CONSTRAINT "UK_COUNTRIES" UNIQUE ( "COUNTRY_CODE" )
);   

CREATE TABLE "COUNTIES" (
    "COUNTRY_ID"   NUMBER(10, 0) NOT NULL,
    "COUNTY_ID"    NUMBER(10, 0) NOT NULL,
    "COUNTY_CODE"  VARCHAR2(15) NOT NULL,
    "COUNTY_NAME"  VARCHAR2(50),
    "UPDATE_DATE"  DATE NOT NULL,
    CONSTRAINT "PK_COUNTIES" PRIMARY KEY ( "COUNTY_ID" ),
    CONSTRAINT "UK_COUNTIES" UNIQUE ( "COUNTRY_ID",
                                      "COUNTY_CODE" ),
    CONSTRAINT "FK_COUNTIES_COUNTRIES" FOREIGN KEY ( "COUNTRY_ID" )
        REFERENCES "COUNTRIES" ( "COUNTRY_ID" )
);

  
CREATE TABLE "LOCALITIES" (
    "COUNTRY_ID"         NUMBER(10, 0) NOT NULL,
    "COUNTY_ID"        NUMBER(10, 0) NOT NULL,
    "LOCALITY_ID"   NUMBER(10, 0) NOT NULL,
    "LOCALITY_CODE"  VARCHAR2(15) NOT NULL,
    "LOCALITY_NAME"  VARCHAR2(60),
    "POSTAL_CODE"      VARCHAR2(10),
    "UPDATE_DATE"        DATE NOT NULL,
    CONSTRAINT "PK_LOCALITIES" PRIMARY KEY ( "LOCALITY_ID" ),
    CONSTRAINT "UK_LOCALITIES" UNIQUE ( "COUNTY_ID",
                                        "LOCALITY_CODE" ),
    CONSTRAINT "FK_LOCALITIES_COUNTIES" FOREIGN KEY ( "COUNTY_ID" )
        REFERENCES "COUNTIES" ( "COUNTY_ID" ),
    CONSTRAINT "FK_LOCALITIES_COUNTRIES" FOREIGN KEY ( "COUNTRY_ID" )
        REFERENCES "COUNTRIES" ( "COUNTRY_ID" )
);
