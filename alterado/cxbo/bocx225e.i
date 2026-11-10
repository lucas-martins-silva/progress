DEFINE TEMP-TABLE {1} NO-UNDO LIKE ordens-embarque
    FIELD c-it-codigo           LIKE item.it-codigo
    FIELD c-desc-item           AS CHAR FORMAT "x(60)"
    FIELD c-un                  like item.un
    FIELD c-un-item             LIKE item.un
    FIELD c-un-fornec           LIKE item.un
    FIELD de-quantidade         LIKE ordens-embarque.quantidade
    FIELD de-peso-bruto         AS DECIMAL FORMAT '>>>>>>,>>9.9999999999' /*like item.peso-bruto  */
    FIELD de-peso-bruto-unit    AS DECIMAL FORMAT '>>>>>>,>>9.9999999999' /*like item.peso-bruto*/
    FIELD de-peso-liquido       AS DECIMAL FORMAT '>>>>>>,>>9.9999999999' /*like item.peso-liquido*/
    FIELD de-peso-liquido-unit  AS DECIMAL FORMAT '>>>>>>,>>9.9999999999' /*like item.peso-liquido*/
    FIELD i-trib-ii             AS INTEGER
    FIELD c-trib-ii             AS CHAR FORMAT "!"                      LABEL "Tributa‡Æo II" 
    FIELD c-desc-ii             AS CHAR FORMAT "x(10)"                  LABEL "Tributa‡Æo II"
    FIELD i-trib-ipi            AS INTEGER
    FIELD c-trib-ipi            AS CHAR FORMAT "!"                      LABEL "Tributa‡Æo IPI" 
    FIELD c-desc-ipi            AS CHAR FORMAT "x(10)"                  LABEL "Tributa‡Æo IPI"
    FIELD i-trib-icms           AS INTEGER
    FIELD c-trib-icms           AS CHAR FORMAT "!"                      LABEL "Tributa‡Æo ICMS"
    FIELD c-desc-icms           AS CHAR FORMAT "x(10)"                  LABEL "Tributa‡Æo ICMS"
    FIELD i-trib-pis            AS INTEGER
    FIELD c-trib-pis            AS CHAR FORMAT "!"                      LABEL "Tributa‡Æo PIS"
    FIELD c-desc-pis            AS CHAR FORMAT "x(10)"                  LABEL "Tributa‡Æo PIS"
    FIELD i-trib-cofins         AS INTEGER
    FIELD c-trib-cofins         AS CHAR FORMAT "!"                      LABEL "Tributa‡Æo COFINS"
    FIELD c-desc-cofins         AS CHAR FORMAT "x(10)"                  LABEL "Tributa‡Æo COFINS"
    FIELD de-aliq-ii            AS DECIMAL FORMAT ">>>9.9999"           LABEL "% II"
    FIELD de-aliq-ipi           AS DECIMAL FORMAT ">>>9.99"             LABEL "% IPI"
    FIELD de-aliq-icms          AS DECIMAL FORMAT ">>>9.99"             LABEL "% ICMS"
    FIELD de-aliq-pis           AS DECIMAL FORMAT ">>9.9999"            LABEL "% EXTERNO PIS"
    FIELD de-aliq-cofins        AS DECIMAL FORMAT ">>9.9999"            LABEL "% EXTERNO COFINS"
    FIELD c-class-fiscal        AS CHAR FORMAT "9999.99.99"             LABEL "Class Fisc"
    FIELD c-nat-fiscal          AS CHAR FORMAT "9999.99.99"             LABEL "Natureza Fiscal"
    FIELD l-suspensao-II        AS LOGICAL FORMAT "Sim/NÆo"             LABEL "Susp II"
    FIELD l-suspensao-IPI       AS LOGICAL FORMAT "Sim/NÆo"             LABEL "Susp IPI"
    FIELD de-cubagem            LIKE ordens-embarque.val-cub-unit
    FIELD de-peso-embal         AS DECIMAL FORMAT "->>>,>>9.99999" 
    FIELD cdn-adicao            AS INTEGER FORMAT ">>>9"                LABEL "Nr.Adi‡Æo"
    FIELD de-taxa-siscomex      AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" LABEL "Taxa Siscomex"
    FIELD seq-item              AS INT FORMAT ">>>9"                    LABEL "Seq. Item Adi‡Æo"
    FIELD l-aplica-desc-ICMS    AS LOGICAL FORMAT "Sim/NÆo"             LABEL "Aplic Desc ICMS"
    FIELD cClassTrib-IBSUF      LIKE relac-class-trib.cod-cclass-trib   COLUMN-LABEL "Class Trib IBS UF"
    FIELD cCST-IBSUF            LIKE relac-class-trib.cod-cst           COLUMN-LABEL "CST IBS UF"
    FIELD c-trib-IBSUF          AS CHARACTER FORMAT "9":U INITIAL "1"   LABEL "Tributa‡Æo IBS UF"
    FIELD de-aliq-IBSUF         AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% IBS UF"
    FIELD perc-red-gov-ibsuf    AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% Red Gov IBS UF"
    FIELD de-aliq-red-IBSUF     AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% Red IBS UF"
    FIELD cClassTrib-IBSMun     LIKE relac-class-trib.cod-cclass-trib   COLUMN-LABEL "Class Trib IBS Mun"
    FIELD cCST-IBSMun           LIKE relac-class-trib.cod-cst           COLUMN-LABEL "CST IBS Mun"
    FIELD c-trib-IBSMun         AS CHARACTER FORMAT "9":U INITIAL "1"   LABEL "Tributa‡Æo IBS Mun"
    FIELD de-aliq-IBSMun        AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% IBS Mun"
    FIELD perc-red-gov-ibsmun   AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% Red Gov IBS Mun"
    FIELD de-aliq-red-IBSMun    AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% Red IBS Mun"
    FIELD cClassTrib-CBS        LIKE relac-class-trib.cod-cclass-trib   COLUMN-LABEL "Class Trib CBS"
    FIELD cCST-CBS              LIKE relac-class-trib.cod-cst           COLUMN-LABEL "CST CBS"
    FIELD c-trib-CBS            AS CHARACTER FORMAT "9":U INITIAL "1"   LABEL "Tributa‡Æo CBS"
    FIELD de-aliq-CBS           AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% CBS"
    FIELD perc-red-gov-cbs      AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% Red Gov CBS"
    FIELD de-aliq-red-CBS       AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% Red CBS"
    FIELD cClassTribReg-IBSUF   LIKE relac-class-trib.cod-cclass-trib   COLUMN-LABEL "ClassTrib Reg IBS UF"
    FIELD cCSTReg-IBSUF         LIKE relac-class-trib.cod-cst           COLUMN-LABEL "CST Reg IBS UF"
    FIELD de-aliq-Reg-IBSUF     AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% Reg IBS UF"
    FIELD cClassTribReg-IBSMun  LIKE relac-class-trib.cod-cclass-trib   COLUMN-LABEL "ClassTrib Reg IBS Mun"
    FIELD cCSTReg-IBSMun        LIKE relac-class-trib.cod-cst           COLUMN-LABEL "CST Reg IBS Mun"
    FIELD de-aliq-Reg-IBSMun    AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% Reg IBS Mun"
    FIELD cClassTribReg-CBS     LIKE relac-class-trib.cod-cclass-trib   COLUMN-LABEL "ClassTrib Reg CBS"
    FIELD cCSTReg-CBS           LIKE relac-class-trib.cod-cst           COLUMN-LABEL "CST Reg CBS"
    FIELD de-aliq-Reg-CBS       AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% Reg CBS"
    FIELD cod-nbs               LIKE cad-nbs.cod-nbs                    COLUMN-LABEL "NBS"
    FIELD cClassTrib-IS         LIKE relac-class-trib.cod-cclass-trib   COLUMN-LABEL "Class Trib IS"
    FIELD cCST-IS               LIKE relac-class-trib.cod-cst           COLUMN-LABEL "CST IS"
    FIELD c-trib-IS             AS CHARACTER FORMAT "9":U INITIAL "1"   LABEL "Tributa‡Æo IS"
    FIELD de-aliq-IS            AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "% IS"
    FIELD de-aliq-espec-IS      AS DECIMAL   FORMAT ">>>9.9999":U       LABEL "Aliq Espec UN IS"
    FIELD de-qtde-trib-IS       LIKE ordens-embarque.quantidade HELP "" COLUMN-LABEL "Qtde Tribut vel IS"
    FIELD c-un-trib-IS          LIKE item.un                    HELP "" COLUMN-LABEL "UN Tribut vel IS"
    FIELD r-rowid               AS ROWID.
