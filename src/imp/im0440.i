{cxbo/bocx383.i tt-decla-import}
{cxbo/bocx395.i tt-decla-imp-cotac-aux}
{cxbo/bocx384.i tt-histor-di}
{cxbo/bocx395.i tt-decla-imp-cotac}
{cxbo/bocx386.i tt-decla-imp-embal}
{cxbo/bocx095.i tt-desp-imp}
{include/tt-edit.i}
{include/pi-edit.i}

/*-------------------------- Cria‡Æo das vari veis e temp-tables -----------------------------------*/

DEFINE TEMP-TABLE tt-despes-decla-import NO-UNDO LIKE despes-decla-import
    FIELD i-tipo  AS INTEGER FORMAT ">9" /*1 - Despesas DI / 2- Despesas Embarque*/
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-decla-import-proc NO-UNDO LIKE decla-import-proc
    FIELD desc-tipo AS CHAR FORMAT "X(25)"
    FIELD r-Rowid   AS ROWID.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD c-diems-ini         LIKE decla-import.num-di-ems
    FIELD c-diems-fim         LIKE decla-import.num-di-ems
    FIELD c-siscomex-ini      LIKE decla-import.cod-di-siscomex
    FIELD c-siscomex-fim      LIKE decla-import.cod-di-siscomex
    FIELD d-datadi-ini        LIKE decla-import.dat-di
    FIELD d-datadi-fim        LIKE decla-import.dat-di
    FIELD c-estab-ini         LIKE decla-import.cod-estab
    FIELD c-estab-fim         LIKE decla-import.cod-estab
    FIELD c-via-transp-ini    AS CHARACTER FORMAT "x(16)":U
    FIELD c-via-transp-fim    AS CHARACTER FORMAT "x(16)":U
    FIELD l-Obervacoes        AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD l-transporte        AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD l-Itinerario        AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD l-Despesas          AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD l-cus-nacio         AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD l-listaradicoes     AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD l-despesas-adicoes  AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD l-LItens            AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD l-cambio            AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD rsDestiny           AS INTEGER   
    FIELD rsExecution         AS LOGICAL   FORMAT "Sim/NÆo"
    FIELD destino             AS INTEGER
    FIELD arquivo             AS CHARACTER FORMAT "x(35)":U
    FIELD usuario             AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec           AS DATE      FORMAT "99/99/9999"
    FIELD hora-exec           AS INTEGER
    FIELD classifica          AS INTEGER
    FIELD desc-classifica     AS CHARACTER FORMAT "x(40)":U
    FIELD modelo              AS CHARACTER FORMAT "x(35)":U
    FIELD l-habilitaRtf       as LOGICAL   FORMAT "Sim/NÆo".

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD num-di-ems        LIKE decla-import.num-di-ems
    FIELD cod-di-siscomex   LIKE decla-import.cod-di-siscomex
    FIELD data-di           LIKE decla-import.dat-di.

/*temp-table que armazena os valores da decla-import*/
DEFINE TEMP-TABLE tt-valores-decla-import NO-UNDO
    FIELD num-di-ems                 LIKE decla-import.num-di-ems
    FIELD cdd-siscomex-dts           LIKE decla-import.cdd-siscomex-dts
    FIELD frete-moeda                LIKE moeda.descricao
    FIELD frete-valor-me             LIKE decla-import.val-frete
    FIELD frete-valor-mn             LIKE decla-import.val-frete
    FIELD frete-perc-naci            AS   DECIMAL   FORMAT "zz9.99":U
    FIELD frete-perc-inte            AS   DECIMAL   FORMAT "zz9.99":U
    FIELD seguro-moeda               LIKE moeda.descricao
    FIELD seguro-valor-me            LIKE decla-import.val-seguro    
    FIELD seguro-valor-mn            LIKE decla-import.val-seguro
    FIELD seguro-perc-naci           AS   DECIMAL   FORMAT "zz9.99":U
    FIELD seguro-perc-inte           AS   DECIMAL   FORMAT "zz9.99":U
    FIELD vmle-moeda                 LIKE moeda.descricao
    FIELD vmle-valor-me              LIKE decla-import.val-vmle     
    FIELD vmle-valor-mn              LIKE decla-import.val-vmle
    FIELD vmld-moeda                 LIKE moeda.descricao
    FIELD vmld-valor-me              LIKE decla-import.val-vmld    
    FIELD vmld-valor-mn              LIKE decla-import.val-vmld
    FIELD vmld-perc-naci             AS   DECIMAL   FORMAT "zz9.99":U
    FIELD vmld-perc-inte             AS   DECIMAL   FORMAT "zz9.99":U
    FIELD vmcv-moeda                 LIKE moeda.descricao
    FIELD vmcv-valor-me              LIKE decla-import.val-vmcv    
    FIELD vmcv-valor-mn              LIKE decla-import.val-vmcv
    FIELD vmcv-perc-naci             AS   DECIMAL   FORMAT "zz9.99":U
    FIELD vmcv-perc-inte             AS   DECIMAL   FORMAT "zz9.99":U
    FIELD acresc-moeda               LIKE moeda.descricao
    FIELD acresc-valor-me            LIKE decla-import.val-acresc    
    FIELD acresc-valor-mn            LIKE decla-import.val-acresc
    FIELD acresc-perc-naci           AS   DECIMAL   FORMAT "zz9.99":U
    FIELD acresc-perc-inte           AS   DECIMAL   FORMAT "zz9.99":U
    FIELD val-base-ii                LIKE decla-import.val-base-ii
    FIELD val-ii-nao-tribut          LIKE decla-import.val-ii-nao-tribut
    FIELD val-ii-db-cr               LIKE decla-import.val-ii-db-cr         /*‚ tamb‚m o valor mn*/
    FIELD val-ii-outras              LIKE decla-import.val-ii-outras
    FIELD ii-moeda                   LIKE moeda.descricao
    FIELD ii-valor-me                LIKE decla-import.val-ii-db-cr
    FIELD ii-perc-naci               AS   DECIMAL   FORMAT "zz9.99":U
    FIELD ii-perc-inte               AS   DECIMAL   FORMAT "zz9.99":U
    FIELD val-base-ipi               LIKE decla-import.val-base-ipi       
    FIELD val-ipi-nao-tributad       LIKE decla-import.val-ipi-nao-tributad
    FIELD val-ipi-db-cr              LIKE decla-import.val-ipi-db-cr        /*‚ tamb‚m o valor mn*/
    FIELD val-ipi-outras             LIKE decla-import.val-ipi-outras    
    FIELD ipi-moeda                  LIKE moeda.descricao
    FIELD ipi-valor-me               LIKE decla-import.val-ipi-db-cr
    FIELD ipi-perc-naci              AS   DECIMAL   FORMAT "zz9.99":U  
    FIELD ipi-perc-inte              AS   DECIMAL   FORMAT "zz9.99":U
    field val-base-pis               LIKE decla-import.val-base-pis      
    field val-pis-nao-tributad       LIKE decla-import.val-pis-nao-tributad 
    field val-pis-db-cr              LIKE decla-import.val-pis-db-cr      /*‚ tamb‚m o valor mn*/
    field val-pis-outras             LIKE decla-import.val-pis-outras     
    FIELD pis-moeda                  LIKE moeda.descricao
    field pis-valor-me               LIKE decla-import.val-pis-db-cr
    FIELD pis-perc-naci              AS   DECIMAL   FORMAT "zz9.99":U  
    FIELD pis-perc-inte              AS   DECIMAL   FORMAT "zz9.99":U
    field val-base-cofins            LIKE decla-import.val-base-cofins       
    field val-cofins-nao-tributad    LIKE decla-import.val-cofins-nao-tribut  
    field val-cofins-db-cr           LIKE decla-import.val-cofins-db-cr       /*‚ tamb‚m o valor mn*/
    field val-cofins-outras          LIKE decla-import.val-cofins-outras      
    FIELD cofins-moeda               LIKE moeda.descricao
    field cofins-valor-me            LIKE decla-import.val-cofins-db-cr
    FIELD cofins-perc-naci           AS   DECIMAL   FORMAT "zz9.99":U  
    FIELD cofins-perc-inte           AS   DECIMAL   FORMAT "zz9.99":U
    field val-base-icms              LIKE decla-import.val-base-icms       
    field val-icms-nao-tributad      LIKE decla-import.val-icms-nao-tribut
    FIELD val-icms-db-cr             LIKE decla-import.val-icms-db-cr       /*‚ tamb‚m o valor mn*/
    FIELD val-icms-outras            LIKE decla-import.val-icms-outras    
    FIELD icms-moeda                 LIKE moeda.descricao
    FIELD icms-valor-me              LIKE decla-import.val-icms-db-cr
    FIELD icms-perc-naci             AS   DECIMAL   FORMAT "zz9.99":U  
    FIELD icms-perc-inte             AS   DECIMAL   FORMAT "zz9.99":U
    
    FIELD val-base-ibs-uf            LIKE decla-import.val-base-icms       
    FIELD val-ibs-uf-nao-tributad    LIKE decla-import.val-icms-nao-tribut
    FIELD val-ibs-uf-db-cr           LIKE decla-import.val-icms-db-cr       /*‚ tamb‚m o valor mn*/
    FIELD val-ibs-uf-outras          LIKE decla-import.val-icms-outras    
    FIELD ibs-uf-moeda               LIKE moeda.descricao
    FIELD ibs-uf-valor-me            LIKE decla-import.val-icms-db-cr
    FIELD ibs-uf-perc-naci           AS   DECIMAL   FORMAT "zz9.99":U  
    FIELD ibs-uf-perc-inte           AS   DECIMAL   FORMAT "zz9.99":U
    FIELD val-base-ibs-uf-reg        LIKE decla-import.val-base-icms       
    FIELD val-ibs-uf-outras-reg      LIKE decla-import.val-icms-outras    

    FIELD val-base-ibs-mun           LIKE decla-import.val-base-icms       
    FIELD val-ibs-mun-nao-tributad   LIKE decla-import.val-icms-nao-tribut
    FIELD val-ibs-mun-db-cr          LIKE decla-import.val-icms-db-cr       /*‚ tamb‚m o valor mn*/
    FIELD val-ibs-mun-outras         LIKE decla-import.val-icms-outras    
    FIELD ibs-mun-moeda              LIKE moeda.descricao
    FIELD ibs-mun-valor-me           LIKE decla-import.val-icms-db-cr
    FIELD ibs-mun-perc-naci          AS   DECIMAL   FORMAT "zz9.99":U  
    FIELD ibs-mun-perc-inte          AS   DECIMAL   FORMAT "zz9.99":U
    FIELD val-base-ibs-mun-reg       LIKE decla-import.val-base-icms       
    FIELD val-ibs-mun-outras-reg     LIKE decla-import.val-icms-outras    

    FIELD val-base-cbs               LIKE decla-import.val-base-icms       
    FIELD val-cbs-nao-tributad       LIKE decla-import.val-icms-nao-tribut
    FIELD val-cbs-db-cr              LIKE decla-import.val-icms-db-cr       /*‚ tamb‚m o valor mn*/
    FIELD val-cbs-outras             LIKE decla-import.val-icms-outras    
    FIELD cbs-moeda                  LIKE moeda.descricao
    FIELD cbs-valor-me               LIKE decla-import.val-icms-db-cr
    FIELD cbs-perc-naci              AS   DECIMAL   FORMAT "zz9.99":U  
    FIELD cbs-perc-inte              AS   DECIMAL   FORMAT "zz9.99":U
    FIELD val-base-cbs-reg           LIKE decla-import.val-base-icms       
    FIELD val-cbs-outras-reg         LIKE decla-import.val-icms-outras    

    FIELD val-tot-imp-me             LIKE decla-import.val-icms-db-cr
    FIELD val-tot-imp-mn             LIKE decla-import.val-icms-db-cr
    FIELD val-tot-imp-naci           AS   DECIMAL  FORMAT "zz9.99":U
    FIELD val-tot-imp-inte           AS   DECIMAL  FORMAT "zz9.99":U
    FIELD desp-n-incid-moeda         LIKE moeda.descricao                    
    FIELD desp-n-incid-valor-me      LIKE decla-import.val-frete
    FIELD desp-n-incid-valor-mn      LIKE decla-import.val-frete
    FIELD desp-n-incid-perc-naci     AS   DECIMAL   FORMAT "zz9.99":U         
    FIELD desp-n-incid-perc-inte     AS   DECIMAL   FORMAT "zz9.99":U
    FIELD val-nac-moeda              LIKE moeda.descricao                    
    FIELD val-nac-valor-me           LIKE decla-import.val-frete
    FIELD val-nac-valor-mn           LIKE decla-import.val-frete
    FIELD val-nac-perc-naci          AS   DECIMAL   FORMAT "zz9.99":U         
    FIELD val-nac-perc-inte          AS   DECIMAL   FORMAT "zz9.99":U 
    FIELD desp-comp-moeda            LIKE moeda.descricao                    
    FIELD desp-comp-valor-me         LIKE decla-import.val-frete
    FIELD desp-comp-valor-mn         LIKE decla-import.val-frete
    FIELD desp-comp-perc-inte        AS   DECIMAL   FORMAT "zz9.99":U
    FIELD val-int-moeda              LIKE moeda.descricao                    
    FIELD val-int-valor-me           LIKE decla-import.val-frete
    FIELD val-int-valor-mn           LIKE decla-import.val-frete
    FIELD val-int-perc-inte          AS   DECIMAL   FORMAT "zz9.99":U.

DEFINE BUFFER bf-historico-embarque FOR historico-embarque.

DEFINE VARIABLE c-tipo-decla             AS   CHARACTER FORMAT "X(80)":U                                                        NO-UNDO.
DEFINE VARIABLE c-carac-oper             AS   CHARACTER FORMAT "x(30)":U                                                        NO-UNDO.
DEFINE VARIABLE c-consig                 AS   CHARACTER FORMAT "X(60)":U                                                        NO-UNDO.
DEFINE VARIABLE c-desp                   AS   CHARACTER FORMAT "X(30)":U                                                        NO-UNDO.
DEFINE VARIABLE c-modal-despach          AS   CHARACTER FORMAT "X(50)":U                                                        NO-UNDO.
DEFINE VARIABLE c-natur-opera            AS   CHARACTER FORMAT "X(30)":U                                                        NO-UNDO.
DEFINE VARIABLE c-observacao             AS   CHARACTER FORMAT "X(5000)":U                                                      NO-UNDO.
DEFINE VARIABLE c-moeda                  AS   CHARACTER FORMAT "X(18)":U                                                        NO-UNDO.
DEFINE VARIABLE c-doc-cheg-carg          AS   CHARACTER                                                                         NO-UNDO.
DEFINE VARIABLE c-via-transp             AS   CHARACTER                                                                         NO-UNDO.
DEFINE VARIABLE c-tipo-conhe-transp      AS   CHARACTER                                                                         NO-UNDO.
DEFINE VARIABLE c-pais-proceden          AS   CHARACTER FORMAT "X(30)":U                                                        NO-UNDO.
DEFINE VARIABLE lb-moeda                 AS   CHARACTER                                                                         NO-UNDO.
DEFINE VARIABLE lb-cotacao               AS   CHARACTER                                                                         NO-UNDO.
DEFINE VARIABLE lb-separador             AS   CHARACTER                                                                         NO-UNDO.
DEFINE VARIABLE h-bocx395                AS   HANDLE                                                                            NO-UNDO.
DEFINE VARIABLE c-cgc                    LIKE estabelec.cgc                                                                     NO-UNDO.
DEFINE VARIABLE c-cgc-emit               LIKE emitente.cgc                                                                      NO-UNDO.
DEFINE VARIABLE c-pais-transp            LIKE pais.nome-pais                                                                    NO-UNDO.
DEFINE VARIABLE c-agent-transp           LIKE emitente.nome-abrev                                                               NO-UNDO.
/*pagina 2*/                                                                                                                    
DEFINE VARIABLE c-cnpj-agente-transp     AS   CHARACTER                                                                         NO-UNDO.
/*Itinerario di*/                                                                                                               
DEFINE VARIABLE c-pto-desc               AS   CHARACTER FORMAT "X(30)":U                                                        NO-UNDO.
DEFINE VARIABLE c-dsl-obs                AS   CHARACTER FORMAT "X(25)":U                                                        NO-UNDO.
/*Despesas DI*/                                                                                                                 
DEFINE VARIABLE c-desc-pto-control       AS   CHARACTER FORMAT "X(70)":U                                                        NO-UNDO.
DEFINE VARIABLE c-desp-moeda             AS   CHARACTER FORMAT "X(10)":U                                                        NO-UNDO.
DEFINE VARIABLE p-data-cotacao           AS   DATE                                                                              NO-UNDO. /*usada na rotina que busca cotacao*/
DEFINE VARIABLE p-cdn-moeda              AS   INTEGER                                                                           NO-UNDO. /*usada na rotina que busca cotacao*/
DEFINE VARIABLE d-cotacao                LIKE despes-decla-import.val-despes                                                    NO-UNDO. /*usada na rotina que busca cotacao*/
DEFINE VARIABLE d-valor-cotado           LIKE despes-decla-import.val-despes                                                    NO-UNDO. 
/*Vari veis Despesas DI / Despesas Embarque*/                                                                                   
DEFINE VARIABLE c-desc-desp              AS   CHARACTER FORMAT "x(21)":U                                                        NO-UNDO.
DEFINE VARIABLE c-tipo-despes            AS   CHARACTER FORMAT "x(20)":U                                                        NO-UNDO.
DEFINE VARIABLE c-desc-emitente          AS   CHARACTER FORMAT "x(21)":U                                                        NO-UNDO.
DEFINE VARIABLE c-desc-cond-pagto        AS   CHARACTER FORMAT "x(21)":U                                                        NO-UNDO.
DEFINE VARIABLE l-duplic                 AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE l-ii                     AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE l-ipi                    AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE l-icms                   AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE l-pis-adu                AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE l-pis-desp               AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE l-cofins-adu             AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE l-cofins-desp            AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE l-ibs-uf                 AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE l-ibs-mun                AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE l-cbs                    AS   LOGICAL   FORMAT "Sim/NÆo"                                                        NO-UNDO.
DEFINE VARIABLE d-valor-me               LIKE despes-decla-import.val-despes                                                    NO-UNDO.
DEFINE VARIABLE d-valor-mn               LIKE despes-decla-import.val-despes                                                    NO-UNDO.
DEFINE VARIABLE d-taxa-camb              LIKE decla-import-cotac.val-cotac                                                      NO-UNDO.
DEFINE VARIABLE i-pto-control-nacionaliz LIKE historico-embarque.cod-pto-contr                                                  NO-UNDO.
/*Variaveis dos totais das despesas*/
DEFINE VARIABLE d-val-tot-despes         LIKE desp-embarque.val-desp                                                            NO-UNDO.
DEFINE VARIABLE d-tot-pto-contr          LIKE despes-decla-import.val-desp LABEL "Total de Ponto de Controle"                   NO-UNDO.
DEFINE VARIABLE d-tot-pto-nac            LIKE despes-decla-import.val-desp LABEL "Total Despesas at‚ Ponto de Nacionaliza‡Æo"   NO-UNDO.
DEFINE VARIABLE d-tot-geral-desp         LIKE despes-decla-import.val-desp LABEL "Total Geral das Despesas"                     NO-UNDO.
/*Vari veis de valores*/
DEFINE VARIABLE lb-frete                 AS   CHARACTER FORMAT "X(6)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-seguro                AS   CHARACTER FORMAT "X(7)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-vmle                  AS   CHARACTER FORMAT "X(5)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-vmld                  AS   CHARACTER FORMAT "X(5)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-vmcv                  AS   CHARACTER FORMAT "X(5)":U                                                         NO-UNDO.
DEFINE VARIABLE c-moeda-frete            LIKE moeda.descricao                                                                   NO-UNDO.
DEFINE VARIABLE c-moeda-seguro           LIKE moeda.descricao                                                                   NO-UNDO.
DEFINE VARIABLE c-moeda-vmle             LIKE moeda.descricao                                                                   NO-UNDO.
DEFINE VARIABLE c-moeda-vmld             LIKE moeda.descricao                                                                   NO-UNDO.
DEFINE VARIABLE c-moeda-vmcv             LIKE moeda.descricao                                                                   NO-UNDO.
DEFINE VARIABLE c-moeda-acresc           LIKE moeda.descricao                                                                   NO-UNDO.
/*Vari veis de impostos*/
DEFINE VARIABLE lb-ii                    AS   CHARACTER FORMAT "x(3)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-ipi                   AS   CHARACTER FORMAT "x(4)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-pis                   AS   CHARACTER FORMAT "x(4)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-cofins                AS   CHARACTER FORMAT "x(7)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-icms                  AS   CHARACTER FORMAT "X(5)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-totais                AS   CHARACTER FORMAT "X(7)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-fcp                   AS   CHARACTER FORMAT "X(4)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-fcp-st                AS   CHARACTER FORMAT "X(7)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-icms-st               AS   CHARACTER FORMAT "X(8)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-icms-compl            AS   CHARACTER FORMAT "X(11)":U                                                        NO-UNDO.
DEFINE VARIABLE lb-ibs-uf                AS   CHARACTER FORMAT "X(7)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-ibs-mun               AS   CHARACTER FORMAT "X(8)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-cbs                   AS   CHARACTER FORMAT "X(4)":U                                                         NO-UNDO.
DEFINE VARIABLE lb-ibs-uf-reg            AS   CHARACTER FORMAT "X(11)":U                                                        NO-UNDO.
DEFINE VARIABLE lb-ibs-mun-reg           AS   CHARACTER FORMAT "X(12)":U                                                        NO-UNDO.
DEFINE VARIABLE lb-cbs-reg               AS   CHARACTER FORMAT "X(8)":U                                                         NO-UNDO.
DEFINE VARIABLE de-v-base-fcp            LIKE decla-import.val-base-icms                                                        NO-UNDO. 
DEFINE VARIABLE de-v-susp-fcp            LIKE decla-import.val-icms-nao-tribut                                                  NO-UNDO. 
DEFINE VARIABLE de-v-recolhe-fcp         LIKE decla-import.val-icms-db-cr                                                       NO-UNDO. 
DEFINE VARIABLE de-v-outros-fcp          LIKE decla-import.val-icms-outras                                                      NO-UNDO.
DEFINE VARIABLE de-v-base-fcp-st         LIKE decla-import.val-base-icms                                                        NO-UNDO. 
DEFINE VARIABLE de-v-susp-fcp-st         LIKE decla-import.val-icms-nao-tribut                                                  NO-UNDO. 
DEFINE VARIABLE de-v-recolhe-fcp-st      LIKE decla-import.val-icms-db-cr                                                       NO-UNDO. 
DEFINE VARIABLE de-v-outros-fcp-st       LIKE decla-import.val-icms-outras                                                      NO-UNDO.
DEFINE VARIABLE de-v-base-icms-st        LIKE decla-import.val-base-icms                                                        NO-UNDO. 
DEFINE VARIABLE de-v-susp-icms-st        LIKE decla-import.val-icms-nao-tribut                                                  NO-UNDO. 
DEFINE VARIABLE de-v-recolhe-icms-st     LIKE decla-import.val-icms-db-cr                                                       NO-UNDO. 
DEFINE VARIABLE de-v-outros-icms-st      LIKE decla-import.val-icms-outras                                                      NO-UNDO.
DEFINE VARIABLE de-v-base-icms-compl     LIKE decla-import.val-base-icms                                                        NO-UNDO. 
DEFINE VARIABLE de-v-susp-icms-compl     LIKE decla-import.val-icms-nao-tribut                                                  NO-UNDO. 
DEFINE VARIABLE de-v-recolhe-icms-compl  LIKE decla-import.val-icms-db-cr                                                       NO-UNDO. 
DEFINE VARIABLE de-v-outros-icms-compl   LIKE decla-import.val-icms-outras                                                      NO-UNDO. 
DEFINE VARIABLE d-tot-base               LIKE decla-import.val-ii-db-cr                                                         NO-UNDO.
DEFINE VARIABLE d-tot-nao-tribut         LIKE decla-import.val-ii-db-cr                                                         NO-UNDO.
DEFINE VARIABLE d-tot-db-cr              LIKE decla-import.val-ii-db-cr                                                         NO-UNDO.
DEFINE VARIABLE d-tot-outras             LIKE decla-import.val-ii-db-cr                                                         NO-UNDO.
DEFINE VARIABLE c-param-destino          AS   CHARACTER FORMAT "X(70)":U                                                        NO-UNDO.
DEFINE VARIABLE c-dest                   AS   CHARACTER FORMAT "X(10)":U                                                        NO-UNDO.
DEFINE VARIABLE c-classificacao          AS   CHARACTER FORMAT "X(50)":U                                                        NO-UNDO.
DEFINE VARIABLE d-tot-desp-n-incid       AS   DECIMAL                                                                           NO-UNDO.
DEFINE VARIABLE l-mostra-desp-di         AS   LOGICAL                                                                           NO-UNDO.
DEFINE VARIABLE l-mostra-desp-embarq     AS   LOGICAL                                                                           NO-UNDO.
DEFINE VARIABLE l-incide-val-aduana      AS   LOGICAL                                                                           NO-UNDO.
DEFINE VARIABLE l-nt2024002              AS   LOGICAL                                                                           NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).


/*:T--- Parametros ---------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR tt-decla-import.
DEFINE INPUT PARAMETER TABLE FOR tt-param.
DEFINE INPUT PARAMETER TABLE FOR tt-digita.

FIND FIRST tt-param NO-ERROR.

{imp/im0440.i4} /* Definicao FRAMES/FORMS */

IF NOT VALID-HANDLE(h-bocx395) THEN DO:
    RUN cxbo/bocx395.p PERSISTENT SET h-bocx395.
END.

/*###CRIA€ÇO DAS TEMP-TABLES######*/
FOR EACH tt-decla-import:

    /*MOEDAS*/
    EMPTY TEMP-TABLE tt-decla-imp-cotac-aux.
    RUN getMoedasDespesas IN h-bocx395(INPUT tt-decla-import.num-di-ems,
                                       INPUT tt-decla-import.cdd-siscomex-dts,
                                       OUTPUT TABLE tt-decla-imp-cotac-aux).
    FOR EACH tt-decla-imp-cotac-aux:
        IF NOT CAN-FIND(FIRST tt-decla-imp-cotac 
                        WHERE tt-decla-imp-cotac.num-di-ems       = tt-decla-imp-cotac-aux.num-di-ems
                        AND   tt-decla-imp-cotac.cdd-siscomex-dts = tt-decla-imp-cotac-aux.cdd-siscomex-dts
                        AND   tt-decla-imp-cotac.cdn-moed         = tt-decla-imp-cotac-aux.cdn-moed) THEN DO:
            CREATE tt-decla-imp-cotac.
            BUFFER-COPY tt-decla-imp-cotac-aux TO tt-decla-imp-cotac.
        END.
    END.
    /*FIM MOEDAS*/

    /*processos vinculados*/
    FOR EACH decla-import-proc
        WHERE decla-import-proc.num-di-ems = tt-decla-import.num-di-ems NO-LOCK:
        IF NOT CAN-FIND(FIRST tt-decla-import-proc
                            WHERE tt-decla-import-proc.num-di-ems        = decla-import-proc.num-di-ems 
                            AND   tt-decla-import-proc.cdd-siscomex-dts  = decla-import-proc.cdd-siscomex-dts 
                            AND   tt-decla-import-proc.cod-proces-vincul = decla-import-proc.cod-proces-vincul) THEN DO:
            CREATE tt-decla-import-proc.
            BUFFER-COPY decla-import-proc TO tt-decla-import-proc
            ASSIGN tt-decla-import-proc.desc-tipo = string(decla-import-proc.idi-tip-proces-vincul).
        END.
    END.
    

    /*embalagens*/
    FOR EACH decla-import-embal
        WHERE decla-import-embal.num-di-ems       = tt-decla-import.num-di-ems
        AND   decla-import-embal.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
        NO-LOCK:
        IF NOT CAN-FIND(FIRST tt-decla-imp-embal
                            WHERE tt-decla-imp-embal.num-di-ems       = decla-import-embal.num-di-ems
                            AND   tt-decla-imp-embal.cdd-siscomex-dts = decla-import-embal.cdd-siscomex-dts
                            AND   tt-decla-imp-embal.cod-sig-embal    = decla-import-embal.cod-sig-embal) THEN DO:
            CREATE tt-decla-imp-embal.
            BUFFER-COPY decla-import-embal TO tt-decla-imp-embal.
        END.
    END.
    

    /*historico di - (itinerario di)*/
    FOR EACH histor-decla-import
        WHERE histor-decla-import.num-di-ems       = tt-decla-import.num-di-ems 
        AND   histor-decla-import.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
        NO-LOCK:
        IF NOT CAN-FIND(FIRST tt-histor-di
                            WHERE tt-histor-di.num-di-ems       = histor-decla-import.num-di-ems
                            AND   tt-histor-di.cdd-siscomex-dts = histor-decla-import.cdd-siscomex-dts
                            AND   tt-histor-di.num-seq          = histor-decla-import.num-seq) THEN DO:
            CREATE tt-histor-di.
            BUFFER-COPY histor-decla-import TO tt-histor-di.
        END.
    END.
    

    /*Despesas DI*/
    FOR EACH despes-decla-import
        WHERE despes-decla-import.num-di-ems       = tt-decla-import.num-di-ems
        AND   despes-decla-import.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
        NO-LOCK:
        IF NOT CAN-FIND(FIRST tt-despes-decla-import
                            WHERE tt-despes-decla-import.num-di-ems       =  despes-decla-import.num-di-ems     
                            AND   tt-despes-decla-import.cdd-siscomex-dts =  despes-decla-import.cdd-siscomex-dts
                            AND   tt-despes-decla-import.cdn-pto-control  =  despes-decla-import.cdn-pto-control
                            AND   tt-despes-decla-import.cdn-despes       =  despes-decla-import.cdn-despes     
                            AND   tt-despes-decla-import.cdn-emit-despes  =  despes-decla-import.cdn-emit-despes) THEN DO:
            CREATE tt-despes-decla-import.
            BUFFER-COPY despes-decla-import TO tt-despes-decla-import.
            ASSIGN tt-despes-decla-import.i-tipo = 1.
        END.
    END.
    

    /*Despesas Embarque*/
    FOR EACH  decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.num-di-ems = tt-decla-import.num-di-ems
        AND   decla-import-embarq.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts,
        EACH  desp-embarque NO-LOCK
        WHERE desp-embarque.cod-estabel = decla-import-embarq.cod-estab
        AND   desp-embarque.embarque    = decla-import-embarq.cod-embarq :

        IF NOT CAN-FIND(FIRST tt-despes-decla-import
                        WHERE tt-despes-decla-import.num-di-ems       =  decla-import-embarq.num-di-ems
                        AND   tt-despes-decla-import.cdd-siscomex-dts =  decla-import-embarq.cdd-siscomex-dts
                        AND   tt-despes-decla-import.cdn-despes       =  desp-embarque.cod-desp) THEN DO:
            CREATE tt-despes-decla-import.
            ASSIGN tt-despes-decla-import.num-di-ems             = decla-import-embarq.num-di-ems
                   tt-despes-decla-import.cdd-siscomex-dts       = decla-import-embarq.cdd-siscomex-dts
                   tt-despes-decla-import.cdn-cond-pagto         = desp-embarque.cod-cond-pag 
                   tt-despes-decla-import.cdn-despes             = desp-embarque.cod-desp 
                   tt-despes-decla-import.cdn-emit-despes        = desp-embarque.cod-emitente-desp 
                   tt-despes-decla-import.cod-incoterm-rat       = desp-embarque.cod-incoterm-rat 
                   tt-despes-decla-import.cdn-pto-control        = desp-embarque.cod-pto-contr 
                   tt-despes-decla-import.log-forma-preco-compra = desp-embarque.log-forma-preco-compra 
                   tt-despes-decla-import.cdn-moed               = desp-embarque.mo-codigo 
                   tt-despes-decla-import.val-despes             = desp-embarque.val-desp
                   tt-despes-decla-import.i-tipo                 = 2.
        END.
    END.
    
    /*valores da tabela decla-import*/
    IF  NOT CAN-FIND(FIRST tt-valores-decla-import
                     WHERE tt-valores-decla-import.num-di-ems       = tt-decla-import.num-di-ems
                     AND   tt-valores-decla-import.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts) THEN DO:
        FIND FIRST decla-import-adic-itens WHERE decla-import-adic-itens.num-di-ems       = tt-decla-import.num-di-ems
                                           AND   decla-import-adic-itens.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                                           NO-LOCK NO-ERROR.
        IF  AVAIL decla-import-adic-itens THEN DO:
            RUN busca-desc-moeda(INPUT decla-import-adic-itens.cdn-moed-frete,
                                 OUTPUT c-moeda-frete).
            RUN busca-desc-moeda(INPUT decla-import-adic-itens.cdn-moed-seguro,
                                 OUTPUT c-moeda-seguro).
        END.

        FIND FIRST decla-import-adic WHERE decla-import-adic.num-di-ems       = tt-decla-import.num-di-ems
                                     AND   decla-import-adic.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                                     NO-LOCK NO-ERROR.
        IF  AVAIL  decla-import-adic THEN DO:
            RUN busca-desc-moeda(INPUT decla-import-adic.cdn-moeda,
                                 OUTPUT c-moeda-vmle).
            RUN busca-desc-moeda(INPUT decla-import-adic.cdn-moeda,
                                 OUTPUT c-moeda-vmld).
            RUN busca-desc-moeda(INPUT decla-import-adic.cdn-moeda,
                                 OUTPUT c-moeda-vmcv).
            RUN busca-desc-moeda(INPUT decla-import-adic.cdn-moeda,
                                 OUTPUT c-moeda-acresc).
        END.
        
            

        /*calculos tt-valores-decla-import*/
        
        /* fim calculos tt-valores-decla-import*/
        CREATE tt-valores-decla-import.
        ASSIGN tt-valores-decla-import.num-di-ems                =  tt-decla-import.num-di-ems
               tt-valores-decla-import.cdd-siscomex-dts          =  tt-decla-import.cdd-siscomex-dts
               tt-valores-decla-import.frete-moeda               =  c-moeda-frete
               tt-valores-decla-import.frete-valor-me            =  truncate(tt-decla-import.val-frete,2)
               tt-valores-decla-import.frete-valor-mn            =  truncate(tt-decla-import.val-frete-me[2],2)
               

               tt-valores-decla-import.seguro-moeda              =  c-moeda-seguro
               tt-valores-decla-import.seguro-valor-me           =  truncate(tt-decla-import.val-seguro,2)
               tt-valores-decla-import.seguro-valor-mn           =  truncate(tt-decla-import.val-seguro-me[2],2)
               
               
               tt-valores-decla-import.vmle-moeda                =  c-moeda-vmle
               tt-valores-decla-import.vmle-valor-me             =  tt-decla-import.val-vmle
               tt-valores-decla-import.vmle-valor-mn             =  tt-decla-import.val-vmle-me[2]
               

               tt-valores-decla-import.vmld-moeda                =  c-moeda-vmld
               tt-valores-decla-import.vmld-valor-me             =  truncate(tt-decla-import.val-vmld,2)
               tt-valores-decla-import.vmld-valor-mn             =  truncate(tt-decla-import.val-vmld-me[2],2)
               
               
               tt-valores-decla-import.vmcv-moeda                =  c-moeda-vmcv
               tt-valores-decla-import.vmcv-valor-me             =  truncate(tt-decla-import.val-vmcv,2)
               tt-valores-decla-import.vmcv-valor-mn             =  truncate(tt-decla-import.val-vmcv-me[2],2)
               

               tt-valores-decla-import.acresc-moeda              =  c-moeda-acresc
               tt-valores-decla-import.acresc-valor-me           =  truncate(tt-decla-import.val-acresc,2)
               tt-valores-decla-import.acresc-valor-mn           =  truncate(tt-decla-import.val-acresc-me[2],2)
               
               
               tt-valores-decla-import.val-base-ii               =  tt-decla-import.val-base-ii      
               tt-valores-decla-import.val-ii-nao-tribut         =  tt-decla-import.val-ii-nao-tribut
               tt-valores-decla-import.val-ii-db-cr              =  truncate(tt-decla-import.val-ii-db-cr,2)
               tt-valores-decla-import.val-ii-outras             =  tt-decla-import.val-ii-outras
               tt-valores-decla-import.ii-moeda                  =  c-moeda-vmld
               
                                                                    
               tt-valores-decla-import.val-base-ipi              =  tt-decla-import.val-base-ipi
               tt-valores-decla-import.val-ipi-nao-tributad      =  tt-decla-import.val-ipi-nao-tributad
               tt-valores-decla-import.val-ipi-db-cr             =  truncate(tt-decla-import.val-ipi-db-cr,2)
               tt-valores-decla-import.val-ipi-outras            =  tt-decla-import.val-ipi-outras
               tt-valores-decla-import.ipi-moeda                 =  c-moeda-vmld                                                   
               
                                                                    
               tt-valores-decla-import.val-base-pis              =  tt-decla-import.val-base-pis
               tt-valores-decla-import.val-pis-nao-tributad      =  tt-decla-import.val-pis-nao-tributad
               tt-valores-decla-import.val-pis-db-cr             =  truncate(tt-decla-import.val-pis-db-cr,2)
               tt-valores-decla-import.val-pis-outras            =  tt-decla-import.val-pis-outras
               tt-valores-decla-import.pis-moeda                 =  c-moeda-vmld                                                   
               
                                                                    
               tt-valores-decla-import.val-base-cofins           =  tt-decla-import.val-base-cofins
               tt-valores-decla-import.val-cofins-nao-tributad   =  tt-decla-import.val-cofins-nao-tributad
               tt-valores-decla-import.val-cofins-db-cr          =  truncate(tt-decla-import.val-cofins-db-cr,2)
               tt-valores-decla-import.val-cofins-outras         =  tt-decla-import.val-cofins-outras
               tt-valores-decla-import.cofins-moeda              =  c-moeda-vmld                                                   
               
                                                                    
               tt-valores-decla-import.val-base-icms             =  tt-decla-import.val-base-icms
               tt-valores-decla-import.val-icms-nao-tributad     =  tt-decla-import.val-icms-nao-tributad
               tt-valores-decla-import.val-icms-db-cr            =  truncate(tt-decla-import.val-icms-db-cr,2)
               tt-valores-decla-import.val-icms-outras           =  tt-decla-import.val-icms-outras
               tt-valores-decla-import.icms-moeda                =  c-moeda-vmld                                                   
            .

        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
        IF  l-nt2024002 THEN DO:
            
            FOR EACH decla-import-trib NO-LOCK
               WHERE decla-import-trib.num-di-ems       = tt-decla-import.num-di-ems
                 AND decla-import-trib.num-seq-retif    = tt-decla-import.num-seq-retif
                 AND decla-import-trib.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:
                
                CASE decla-import-trib.nom-trib:
                    WHEN "IBSUF":U THEN DO:
                        CASE decla-import-trib.cod-campo:
                            WHEN "BASE":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-base-ibs-uf = DEC(decla-import-trib.cod-conteudo).
                            END.
                            WHEN "SUSPENSO":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-ibs-uf-nao-tributad = DEC(decla-import-trib.cod-conteudo).
                            END.
                            WHEN "VALOR":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-ibs-uf-db-cr = DEC(decla-import-trib.cod-conteudo).
                            END.
                            WHEN "OUTROS":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-ibs-uf-outras = DEC(decla-import-trib.cod-conteudo).
                            END.
                        END CASE.
                    END.
                    WHEN "IBSMUN":U THEN DO:
                        CASE decla-import-trib.cod-campo:
                            WHEN "BASE":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-base-ibs-mun = DEC(decla-import-trib.cod-conteudo).
                            END.
                            WHEN "SUSPENSO":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-ibs-mun-nao-tributad = DEC(decla-import-trib.cod-conteudo).
                            END.
                            WHEN "VALOR":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-ibs-mun-db-cr = DEC(decla-import-trib.cod-conteudo).
                            END.
                            WHEN "OUTROS":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-ibs-mun-outras = DEC(decla-import-trib.cod-conteudo).
                            END.
                        END CASE.
                    END.
                    WHEN "CBS":U THEN DO:
                        CASE decla-import-trib.cod-campo:
                            WHEN "BASE":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-base-cbs = DEC(decla-import-trib.cod-conteudo).
                            END.
                            WHEN "SUSPENSO":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-cbs-nao-tributad = DEC(decla-import-trib.cod-conteudo).
                            END.
                            WHEN "VALOR":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-cbs-db-cr = DEC(decla-import-trib.cod-conteudo).
                            END.
                            WHEN "OUTROS":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-cbs-outras = DEC(decla-import-trib.cod-conteudo).
                            END.
                        END CASE.
                    END.
                END CASE.
            END.
            
            ASSIGN tt-valores-decla-import.ibs-uf-moeda          = c-moeda-vmld
                   tt-valores-decla-import.ibs-uf-valor-me       = 0
                   tt-valores-decla-import.ibs-uf-perc-naci      = 0
                   tt-valores-decla-import.ibs-uf-perc-inte      = 0
                   tt-valores-decla-import.val-base-ibs-uf-reg   = 0
                   tt-valores-decla-import.val-ibs-uf-outras-reg = 0
                   tt-valores-decla-import.ibs-mun-moeda         = c-moeda-vmld
                   tt-valores-decla-import.ibs-mun-valor-me      = 0
                   tt-valores-decla-import.ibs-mun-perc-naci     = 0
                   tt-valores-decla-import.ibs-mun-perc-inte     = 0
                   tt-valores-decla-import.val-base-ibs-mun-reg  = 0
                   tt-valores-decla-import.val-ibs-mun-outras-reg= 0
                   tt-valores-decla-import.cbs-moeda             = c-moeda-vmld
                   tt-valores-decla-import.cbs-valor-me          = 0
                   tt-valores-decla-import.cbs-perc-naci         = 0
                   tt-valores-decla-import.cbs-perc-inte         = 0
                   tt-valores-decla-import.val-base-cbs-reg      = 0
                   tt-valores-decla-import.val-cbs-outras-reg    = 0.
        
            /* totalizar os valores da tributa‡Æo regular */
            FOR EACH  decla-import-adic-trib NO-LOCK
                WHERE decla-import-adic-trib.num-di-ems       = tt-decla-import.num-di-ems                
                AND   decla-import-adic-trib.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:
                
                CASE decla-import-adic-trib.nom-trib:
                    WHEN "IBSUF":U THEN DO:
                        CASE decla-import-adic-trib.cod-campo:
                            WHEN "BASE-REG":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-base-ibs-uf-reg = tt-valores-decla-import.val-base-ibs-uf-reg + 
                                                                                     DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "VALOR-REG":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-ibs-uf-outras-reg = tt-valores-decla-import.val-ibs-uf-outras-reg +
                                                                                       DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                        END CASE.
                    END.
                    WHEN "IBSMUN":U THEN DO:
                        CASE decla-import-adic-trib.cod-campo:
                            WHEN "BASE-REG":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-base-ibs-mun-reg = tt-valores-decla-import.val-base-ibs-mun-reg + 
                                                                                      DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "VALOR-REG":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-ibs-mun-outras-reg = tt-valores-decla-import.val-ibs-mun-outras-reg +
                                                                                        DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                        END CASE.
                    END.
                    WHEN "CBS":U THEN DO:
                        CASE decla-import-adic-trib.cod-campo:
                            WHEN "BASE-REG":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-base-cbs-reg = tt-valores-decla-import.val-base-cbs-reg + 
                                                                                  DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                            WHEN "VALOR-REG":U THEN DO:
                                ASSIGN tt-valores-decla-import.val-cbs-outras-reg = tt-valores-decla-import.val-cbs-outras-reg +
                                                                                    DEC(decla-import-adic-trib.cod-conteudo).
                            END.
                        END CASE.
                    END.
                END CASE.
            END.
        
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */

        /* calculo de conversÆo dos impostos para moeda estrangeira*/
        IF AVAIL decla-import-adic  THEN DO:
        
            IF decla-import-adic.cdn-moeda <> 0 THEN DO:
                /* valor ii cotado para moeda estrangeira*/
               RUN valor-cotado(INPUT  tt-decla-import.num-di-ems,
                                INPUT  tt-decla-import.cdd-siscomex-dts,
                                INPUT  decla-import-adic.cdn-moeda,
                                INPUT  tt-decla-import.dat-di,
                                INPUT  tt-valores-decla-import.val-ii-db-cr,
                                OUTPUT d-valor-cotado,
                                OUTPUT d-cotacao). 
                ASSIGN tt-valores-decla-import.ii-valor-me =  d-valor-cotado.
    
                /* valor ipi cotado para moeda estrangeira*/
                RUN valor-cotado(INPUT  tt-decla-import.num-di-ems,
                                 INPUT  tt-decla-import.cdd-siscomex-dts,
                                 INPUT  decla-import-adic.cdn-moeda,
                                 INPUT  tt-decla-import.dat-di,
                                 INPUT  tt-valores-decla-import.val-ipi-db-cr,
                                 OUTPUT d-valor-cotado,
                                 OUTPUT d-cotacao). 
                ASSIGN tt-valores-decla-import.ipi-valor-me =  d-valor-cotado.
    
                /* valor pis cotado para moeda estrangeira*/
                RUN valor-cotado(INPUT tt-decla-import.num-di-ems,
                                 INPUT tt-decla-import.cdd-siscomex-dts,
                                 INPUT decla-import-adic.cdn-moeda,
                                 INPUT tt-decla-import.dat-di,
                                 INPUT tt-valores-decla-import.val-pis-db-cr,
                                 OUTPUT d-valor-cotado,
                                 OUTPUT d-cotacao). 
                ASSIGN tt-valores-decla-import.pis-valor-me =  d-valor-cotado.
    
                /* valor cofins cotado para moeda estrangeira*/
                RUN valor-cotado(INPUT tt-decla-import.num-di-ems,
                                 INPUT tt-decla-import.cdd-siscomex-dts,
                                 INPUT decla-import-adic.cdn-moeda,
                                 INPUT tt-decla-import.dat-di,
                                 INPUT tt-valores-decla-import.val-cofins-db-cr,
                                 OUTPUT d-valor-cotado,
                                 OUTPUT d-cotacao). 
                ASSIGN tt-valores-decla-import.cofins-valor-me =  d-valor-cotado.
    
                /* valor icms cotado para moeda estrangeira*/
                RUN valor-cotado(INPUT tt-decla-import.num-di-ems,
                                 INPUT tt-decla-import.cdd-siscomex-dts,
                                 INPUT decla-import-adic.cdn-moeda,
                                 INPUT tt-decla-import.dat-di,
                                 INPUT tt-valores-decla-import.val-icms-db-cr,
                                 OUTPUT d-valor-cotado,
                                 OUTPUT d-cotacao). 
                ASSIGN tt-valores-decla-import.icms-valor-me =  d-valor-cotado.
                
                /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
                IF  l-nt2024002 THEN DO:
                    RUN valor-cotado(INPUT  tt-decla-import.num-di-ems,
                                     INPUT  tt-decla-import.cdd-siscomex-dts,
                                     INPUT  decla-import-adic.cdn-moeda,
                                     INPUT  tt-decla-import.dat-di,
                                     INPUT  tt-valores-decla-import.val-ibs-uf-db-cr,
                                     OUTPUT d-valor-cotado,
                                     OUTPUT d-cotacao). 
                    ASSIGN tt-valores-decla-import.ibs-uf-valor-me = d-valor-cotado.
                    
                    RUN valor-cotado(INPUT  tt-decla-import.num-di-ems,
                                     INPUT  tt-decla-import.cdd-siscomex-dts,
                                     INPUT  decla-import-adic.cdn-moeda,
                                     INPUT  tt-decla-import.dat-di,
                                     INPUT  tt-valores-decla-import.val-ibs-mun-db-cr,
                                     OUTPUT d-valor-cotado,
                                     OUTPUT d-cotacao). 
                    ASSIGN tt-valores-decla-import.ibs-mun-valor-me = d-valor-cotado.
                    
                    RUN valor-cotado(INPUT  tt-decla-import.num-di-ems,
                                     INPUT  tt-decla-import.cdd-siscomex-dts,
                                     INPUT  decla-import-adic.cdn-moeda,
                                     INPUT  tt-decla-import.dat-di,
                                     INPUT  tt-valores-decla-import.val-cbs-db-cr,
                                     OUTPUT d-valor-cotado,
                                     OUTPUT d-cotacao). 
                    ASSIGN tt-valores-decla-import.cbs-valor-me = d-valor-cotado.
                END.
            END.
        END.
       
        /*totais*/                                      
        ASSIGN tt-valores-decla-import.val-tot-imp-me = (tt-valores-decla-import.ii-valor-me        + 
                                                         tt-valores-decla-import.ipi-valor-me       + 
                                                         tt-valores-decla-import.pis-valor-me       + 
                                                         tt-valores-decla-import.cofins-valor-me    +
                                                         tt-valores-decla-import.icms-valor-me)
                                                        
               tt-valores-decla-import.val-tot-imp-mn = (tt-valores-decla-import.val-ii-db-cr       +
                                                         tt-valores-decla-import.val-ipi-db-cr      +
                                                         tt-valores-decla-import.val-pis-db-cr      +
                                                         tt-valores-decla-import.val-cofins-db-cr   +
                                                         tt-valores-decla-import.val-icms-db-cr).
        
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
        IF  l-nt2024002 THEN DO:
            ASSIGN tt-valores-decla-import.val-tot-imp-me = tt-valores-decla-import.val-tot-imp-me + (tt-valores-decla-import.ibs-uf-valor-me  +
                                                                                                      tt-valores-decla-import.ibs-mun-valor-me +
                                                                                                      tt-valores-decla-import.cbs-valor-me)
                   tt-valores-decla-import.val-tot-imp-mn = tt-valores-decla-import.val-tot-imp-mn + (tt-valores-decla-import.val-ibs-uf-db-cr  +
                                                                                                      tt-valores-decla-import.val-ibs-mun-db-cr +
                                                                                                      tt-valores-decla-import.val-cbs-db-cr).
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
        
        /*ponto de nacionalizacao*/
        FOR FIRST histor-decla-import NO-LOCK
            WHERE histor-decla-import.num-di-ems       = tt-decla-import.num-di-ems
            AND   histor-decla-import.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:
            ASSIGN i-pto-control-nacionaliz = histor-decla-import.cdn-pto-nacionaliz.
        END.                                                               

        ASSIGN d-val-tot-despes = 0
               d-tot-pto-nac    = 0.                                       
        
        FOR EACH decla-import-embarq NO-LOCK
            WHERE decla-import-embarq.num-di-ems       = tt-decla-import.num-di-ems
            AND   decla-import-embarq.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:
    
            ASSIGN d-val-tot-despes = 0.
    
            FOR FIRST historico-embarque NO-LOCK
                WHERE historico-embarque.cod-estabel     = decla-import-embarq.cod-estab
                AND   historico-embarque.embarque        = decla-import-embarq.cod-embarq
                AND   historico-embarque.cod-pto-contr   = i-pto-control-nacionaliz:
    
                FOR EACH  bf-historico-embarque NO-LOCK
                    WHERE bf-historico-embarque.cod-estabel = decla-import-embarq.cod-estab
                    AND   bf-historico-embarque.embarque    = decla-import-embarq.cod-embarq
                    AND   bf-historico-embarque.sequencia  <= historico-embarque.sequencia,
                        EACH  desp-embarque
                        WHERE desp-embarque.cod-estabel   = bf-historico-embarque.cod-estabel
                        AND   desp-embarque.embarque      = bf-historico-embarque.embarque   
                        AND   desp-embarque.cod-pto-contr = bf-historico-embarque.cod-pto-contr:
                    /*ConversÆo da moeda*/
                    FIND FIRST desp-imp 
                            WHERE desp-imp.cod-desp = desp-embarque.cod-desp NO-LOCK NO-ERROR.
                     &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                        ASSIGN l-incide-val-aduana = desp-imp.log-incid-val-aduana.
                    &ELSE
                        ASSIGN l-incide-val-aduana = IF SUBSTRING(desp-imp.char-1,24,1) = '1' THEN YES ELSE NO.
                    &ENDIF
                    IF l-incide-val-aduana = NO THEN DO:
                        IF desp-embarque.mo-codigo <> 0 THEN DO:
                            RUN valor-cotado(INPUT decla-import-embarq.num-di-ems,
                                             INPUT decla-import-embarq.cdd-siscomex-dts,
                                             INPUT desp-embarque.mo-codigo,
                                             INPUT tt-decla-import.dat-di,
                                             INPUT desp-embarque.val-desp,
                                             OUTPUT d-valor-cotado,
                                             OUTPUT d-cotacao).
                            ASSIGN d-tot-desp-n-incid = d-tot-desp-n-incid + d-valor-cotado.
                        END.
                        ELSE DO:
                            ASSIGN d-tot-desp-n-incid = d-tot-desp-n-incid + desp-embarque.val-desp.
                        END.
                    END.
                    /*FIM ConversÆo da moeda*/
                END.
            END.
        END.
            

        ASSIGN tt-valores-decla-import.desp-n-incid-moeda    =  c-moeda-vmld
               tt-valores-decla-import.desp-n-incid-valor-mn =  d-tot-desp-n-incid.
        
        DEFINE VARIABLE i-desp-n-incid-moeda LIKE decla-import-adic.cdn-moeda NO-UNDO.
        ASSIGN i-desp-n-incid-moeda = decla-import-adic.cdn-moeda WHEN AVAIL decla-import-adic
               i-desp-n-incid-moeda = decla-import-adic-itens.cdn-moeda WHEN AVAIL decla-import-adic-itens.

        RUN valor-cotado(INPUT  tt-decla-import.num-di-ems,
                         INPUT  tt-decla-import.cdd-siscomex-dts,
                         INPUT  i-desp-n-incid-moeda, /*decla-import-adic.cdn-moeda,*/
                         INPUT  tt-decla-import.dat-di,
                         INPUT  tt-valores-decla-import.desp-n-incid-valor-mn,
                         OUTPUT d-valor-cotado,
                         OUTPUT d-cotacao).
        ASSIGN tt-valores-decla-import.desp-n-incid-valor-me =  d-valor-cotado.
        
        ASSIGN tt-valores-decla-import.val-nac-moeda         =  c-moeda-vmld
               tt-valores-decla-import.val-nac-valor-me      =  (tt-valores-decla-import.vmld-valor-me       +       
                                                                 tt-valores-decla-import.val-tot-imp-me         + 
                                                                 tt-valores-decla-import.desp-n-incid-valor-me) 
                                                                   
               tt-valores-decla-import.val-nac-valor-mn      =  (tt-valores-decla-import.vmld-valor-mn          +
                                                                 tt-valores-decla-import.val-tot-imp-mn         +
                                                                 tt-valores-decla-import.desp-n-incid-valor-mn)
            
               tt-valores-decla-import.desp-comp-moeda       = c-moeda-vmld
               tt-valores-decla-import.desp-comp-valor-me    = tt-decla-import.val-despes-compltar-me[2]
               tt-valores-decla-import.desp-comp-valor-mn    = tt-decla-import.val-despes-compltar   
                                     
               tt-valores-decla-import.val-int-moeda         = c-moeda-vmld
               tt-valores-decla-import.val-int-valor-me      = tt-valores-decla-import.val-nac-valor-me + tt-valores-decla-import.desp-comp-valor-me
               tt-valores-decla-import.val-int-valor-mn      = tt-valores-decla-import.val-nac-valor-mn + tt-valores-decla-import.desp-comp-valor-mn
            .
        
        /*calculo dos percentuais de nacionalizacao e de internacao*/
        ASSIGN tt-valores-decla-import.frete-perc-naci           = (tt-valores-decla-import.frete-valor-mn        * 100) / tt-valores-decla-import.val-nac-valor-mn
               tt-valores-decla-import.frete-perc-inte           = (tt-valores-decla-import.frete-valor-mn        * 100) / tt-valores-decla-import.val-int-valor-mn
               tt-valores-decla-import.seguro-perc-naci          = (tt-valores-decla-import.seguro-valor-mn       * 100) / tt-valores-decla-import.val-nac-valor-mn
               tt-valores-decla-import.seguro-perc-inte          = (tt-valores-decla-import.seguro-valor-mn       * 100) / tt-valores-decla-import.val-int-valor-mn
               tt-valores-decla-import.vmld-perc-naci            = (tt-valores-decla-import.vmld-valor-mn         * 100) / tt-valores-decla-import.val-nac-valor-mn
               tt-valores-decla-import.vmld-perc-inte            = (tt-valores-decla-import.vmld-valor-mn         * 100) / tt-valores-decla-import.val-int-valor-mn
               tt-valores-decla-import.vmcv-perc-naci            = (tt-valores-decla-import.vmcv-valor-mn         * 100) / tt-valores-decla-import.val-nac-valor-mn
               tt-valores-decla-import.vmcv-perc-inte            = (tt-valores-decla-import.vmcv-valor-mn         * 100) / tt-valores-decla-import.val-int-valor-mn
               tt-valores-decla-import.acresc-perc-naci          = (tt-valores-decla-import.acresc-valor-mn       * 100) / tt-valores-decla-import.val-nac-valor-mn
               tt-valores-decla-import.acresc-perc-inte          = (tt-valores-decla-import.acresc-valor-mn       * 100) / tt-valores-decla-import.val-int-valor-mn
               tt-valores-decla-import.ii-perc-naci              = (tt-valores-decla-import.val-ii-db-cr          * 100) / tt-valores-decla-import.val-nac-valor-mn
               tt-valores-decla-import.ii-perc-inte              = (tt-valores-decla-import.val-ii-db-cr          * 100) / tt-valores-decla-import.val-int-valor-mn
               tt-valores-decla-import.ipi-perc-naci             = (tt-valores-decla-import.val-ipi-db-cr         * 100) / tt-valores-decla-import.val-nac-valor-mn
               tt-valores-decla-import.ipi-perc-inte             = (tt-valores-decla-import.val-ipi-db-cr         * 100) / tt-valores-decla-import.val-int-valor-mn
               tt-valores-decla-import.pis-perc-naci             = (tt-valores-decla-import.val-pis-db-cr         * 100) / tt-valores-decla-import.val-nac-valor-mn 
               tt-valores-decla-import.pis-perc-inte             = (tt-valores-decla-import.val-pis-db-cr         * 100) / tt-valores-decla-import.val-int-valor-mn 
               tt-valores-decla-import.cofins-perc-naci          = (tt-valores-decla-import.val-cofins-db-cr      * 100) / tt-valores-decla-import.val-nac-valor-mn  
               tt-valores-decla-import.cofins-perc-inte          = (tt-valores-decla-import.val-cofins-db-cr      * 100) / tt-valores-decla-import.val-int-valor-mn  
               tt-valores-decla-import.icms-perc-naci            = (tt-valores-decla-import.val-icms-db-cr        * 100) / tt-valores-decla-import.val-nac-valor-mn  
               tt-valores-decla-import.icms-perc-inte            = (tt-valores-decla-import.val-icms-db-cr        * 100) / tt-valores-decla-import.val-int-valor-mn  
               tt-valores-decla-import.val-tot-imp-naci          = (tt-valores-decla-import.val-tot-imp-mn        * 100) / tt-valores-decla-import.val-nac-valor-mn
               tt-valores-decla-import.val-tot-imp-inte          = (tt-valores-decla-import.val-tot-imp-mn        * 100) / tt-valores-decla-import.val-int-valor-mn

               tt-valores-decla-import.desp-n-incid-perc-naci    = (tt-valores-decla-import.desp-n-incid-valor-mn * 100) / tt-valores-decla-import.val-nac-valor-mn
               tt-valores-decla-import.desp-n-incid-perc-inte    = (tt-valores-decla-import.desp-n-incid-valor-mn * 100) / tt-valores-decla-import.val-int-valor-mn
               tt-valores-decla-import.val-nac-perc-naci         = (tt-valores-decla-import.val-nac-valor-mn      * 100) / tt-valores-decla-import.val-nac-valor-mn
               tt-valores-decla-import.val-nac-perc-inte         = (tt-valores-decla-import.val-nac-valor-mn      * 100) / tt-valores-decla-import.val-int-valor-mn
               tt-valores-decla-import.desp-comp-perc-inte       = (tt-valores-decla-import.desp-comp-valor-mn    * 100) / tt-valores-decla-import.val-int-valor-mn
               tt-valores-decla-import.val-int-perc-inte         = (tt-valores-decla-import.val-int-valor-mn      * 100) / tt-valores-decla-import.val-int-valor-mn
            .
            
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
        IF  l-nt2024002 THEN DO:
            ASSIGN tt-valores-decla-import.ibs-uf-perc-naci  = (tt-valores-decla-import.val-ibs-uf-db-cr  * 100) / tt-valores-decla-import.val-nac-valor-mn
                   tt-valores-decla-import.ibs-uf-perc-inte  = (tt-valores-decla-import.val-ibs-uf-db-cr  * 100) / tt-valores-decla-import.val-int-valor-mn
                   tt-valores-decla-import.ibs-mun-perc-naci = (tt-valores-decla-import.val-ibs-mun-db-cr * 100) / tt-valores-decla-import.val-nac-valor-mn
                   tt-valores-decla-import.ibs-mun-perc-inte = (tt-valores-decla-import.val-ibs-mun-db-cr * 100) / tt-valores-decla-import.val-int-valor-mn
                   tt-valores-decla-import.cbs-perc-naci     = (tt-valores-decla-import.val-cbs-db-cr     * 100) / tt-valores-decla-import.val-nac-valor-mn
                   tt-valores-decla-import.cbs-perc-inte     = (tt-valores-decla-import.val-cbs-db-cr     * 100) / tt-valores-decla-import.val-int-valor-mn.
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-798) */
        /* fim - calculo dos percentuais de nacionalizacao e de internacao*/
    END.
END.

IF VALID-HANDLE(h-bocx395) THEN DO:
    DELETE PROCEDURE h-bocx395.
    ASSIGN h-bocx395 = ?.
END.
/*------------------ Fim cria‡Æo das temp-tables --------------*/


PROCEDURE valor-cotado:
/*------------------------------------------------------------------------------
  Purpose:    busca a cota‡Æo certa e fazer a conversÆo das moedas
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT  PARAM p-num-di-ems       LIKE decla-import.num-di-ems        NO-UNDO.
   DEF INPUT  PARAM p-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts  NO-UNDO.
   DEF INPUT  PARAM p-cdn-moeda        LIKE despes-decla-import.cdn-moeda  NO-UNDO.
   DEF INPUT  PARAM p-data-cotacao     LIKE decla-import.dat-di            NO-UNDO.
   DEF INPUT  PARAM p-valor            LIKE despes-decla-import.val-despes NO-UNDO.
   DEF OUTPUT PARAM p-valor-cotado     LIKE despes-decla-import.val-despes NO-UNDO.
   DEF OUTPUT PARAM p-cotacao          LIKE despes-decla-import.val-despes NO-UNDO.

   
   /*calculo do valor*/
    /*se o cod. da moeda for diferente de 0, significa que ‚ uma moeda estrangeira. 
     * Ou seja, o campo Valor ME recebe o valor da despesa (tt-despes-decla-import.val-despes) e o campo Valor MN precisa ser calculado.
     * Calculo do Valor MN =  Valor ME * cotacaoû.
     * û: o valor da cotacao deve ser buscado do im0400c
     *      se nÆo achar pega do cd0103
     *      se nÆo achar, atribui o valor da cotacao = 1.
    */
    IF p-cdn-moeda <> 0 THEN DO:
        /** FUN€ÇO QUE BUSCA COTA€ÇO (cxbo395.p - fnContacao **/
        IF NOT CAN-FIND(FIRST decla-import-cotac
                        WHERE decla-import-cotac.num-di-ems       = p-num-di-ems
                        AND   decla-import-cotac.cdd-siscomex-dts = p-cdd-siscomex-dts
                        AND   decla-import-cotac.cdn-moed         = p-cdn-moeda
                        AND   decla-import-cotac.val-cotac       <> 0) THEN DO:
            FIND cotacao
                WHERE cotacao.mo-codigo   = p-cdn-moeda
                AND   cotacao.ano-periodo = STRING(YEAR(p-data-cotacao)) 
                                          + STRING(MONTH(p-data-cotacao),"99")
                AND cotacao.cotacao[INT(DAY(p-data-cotacao))] <> 0 NO-LOCK NO-ERROR.
            IF  NOT AVAIL cotacao THEN DO:
                IF  p-cdn-moeda <> 0 THEN DO:
                    ASSIGN d-cotacao = 0.
                END.
                ELSE
                    ASSIGN d-cotacao = 1.
            END.
            ELSE
                ASSIGN d-cotacao = cotacao.cotacao[INT(DAY(p-data-cotacao))].
        END.
        ELSE DO:
            FOR FIRST decla-import-cotac NO-LOCK
                WHERE decla-import-cotac.num-di-ems       = p-num-di-ems
                AND   decla-import-cotac.cdd-siscomex-dts = p-cdd-siscomex-dts
                AND   decla-import-cotac.cdn-moed         = p-cdn-moeda :
                ASSIGN d-cotacao = decla-import-cotac.val-cotac.
            END.
        END.

        ASSIGN p-valor-cotado = p-valor * d-cotacao
               p-cotacao = d-cotacao.
    END.
    ELSE DO:
        ASSIGN p-valor-cotado = p-valor
               p-cotacao = 0.
    END.
    

    RETURN STRING(p-valor-cotado).

END PROCEDURE.


PROCEDURE busca-desc-moeda:
/*------------------------------------------------------------------------------
  Purpose:    Retorna a descricao da moeda
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cdn-moeda  LIKE moeda.mo-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER p-desc-moeda LIKE moeda.descricao NO-UNDO.

    FIND FIRST moeda
         WHERE moeda.mo-codigo = p-cdn-moeda NO-LOCK NO-ERROR.

    ASSIGN p-desc-moeda = moeda.descricao WHEN AVAIL moeda.

    RETURN "OK":U.
END PROCEDURE.



