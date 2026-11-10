/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD036 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD036 MPD}
&ENDIF

/******************************************************************************
**  Programa: anepd036.p
**  Funcao  : Sender Unidade Negocio
**  Data    : 03/2008
**  Autor   : M†rcio Lohmann
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

DEFINE INPUT PARAMETER p-rowid        AS ROWID                   NO-UNDO.
DEFINE INPUT PARAMETER c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEFINE INPUT PARAMETER i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEFINE VARIABLE c-root             AS CHAR   NO-UNDO. 
DEFINE VARIABLE c-message          AS CHAR   NO-UNDO.
DEFINE VARIABLE c-BusinessUnitColl AS CHAR   NO-UNDO.
DEFINE VARIABLE c-BusinessUnitInfo AS CHAR   NO-UNDO.
DEFINE VARIABLE c-campo            AS CHAR   NO-UNDO.
DEFINE VARIABLE c-BusinessUnit     AS CHAR   NO-UNDO.
DEFINE VARIABLE c-FromRole         AS CHAR   NO-UNDO.
DEFINE VARIABLE c-ToRole           AS CHAR   NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /* sender */
{cdp/cd9762.i} /* temp-table de unidade de neg¢cio */

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST para-dis     NO-LOCK NO-ERROR.

&IF "{&bf_dis_versao_ems}" >= "2.062" &THEN

    FOR EACH unid-negoc NO-LOCK:
        CREATE tt_unid_negoc.
        ASSIGN tt_unid_negoc.cod_unid_negoc = unid-negoc.cod-unid-negoc
               tt_unid_negoc.des_unid_negoc = unid-negoc.des-unid-negoc.
    END.

&ELSE

    /* EMS2 X EMS5 */
    {btb/btb009za.i}

    DEFINE VARIABLE h-btb009za       AS HANDLE NO-UNDO.
    DEFINE VARIABLE l-conecta-emsuni AS LOG    NO-UNDO.
    DEFINE VARIABLE l-conecta-emsbas AS LOG    NO-UNDO.

    IF NOT CONNECTED("emsuni") 
    OR NOT CONNECTED("emsbas")  THEN DO:

        /* Inicializa API de integracao com o EMS5 */
        IF NOT VALID-HANDLE(h-btb009za)
        OR  h-btb009za:TYPE       <> "PROCEDURE":U
        OR  h-btb009za:FILE-NAME  <> "btb/btb009za.p":U THEN DO:
            RUN btb/btb009za.p PERSISTENT SET h-btb009za.
        END.

        /* Conecta Bases EMS 5  */ 
        RUN pi-conecta-bco IN h-btb009za (INPUT  1, /* Versao API  */
                                          INPUT  1, /* Conectar */
                                          INPUT  i-ep-codigo-usuario,
                                          INPUT  "all":U,
                                          OUTPUT TABLE tt_erros_conexao).

        IF RETURN-VALUE <> "OK":U THEN
           RETURN "NOK":U.
        ELSE
           ASSIGN l-conecta-emsuni = YES
                  l-conecta-emsbas = YES.

    END.

    RUN prgint/utb/utb907za.py (INPUT 1,
                                INPUT-OUTPUT TABLE tt_unid_negoc ).

    IF (CONNECTED("emsuni") AND l-conecta-emsuni) 
    OR (CONNECTED("emsbas") and l-conecta-emsbas) THEN DO:
       
       /* Conecta Bases EMS 5  */ 
       RUN pi-conecta-bco IN h-btb009za (INPUT 1, /*versao api */
                                         INPUT 2, /* 1 - conex∆o, 2 - desconex∆o */
                                         INPUT param-global.empresa-prin,  /* cod empresa*/
                                         INPUT "all", 
                                         OUTPUT TABLE tt_erros_conexao).

       /*  Finaliza API de integracao com o EMS5 */
       IF  valid-handle(h-btb009za) THEN DO:
           DELETE PROCEDURE h-btb009za.
           ASSIGN h-btb009za = ?.
       END.
    END.   
    
&ENDIF

RUN pi-cabecalho-msg.

FOR EACH tt_unid_negoc NO-LOCK:
    RUN pi-corpo.
END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root                   = CreateNeoGridDoc("BusinessUnit","1.01.001","1")
             c-message              = AddElement(c-root,"CRM")
             c-message              = AddElement(c-root,"Message")
               c-BusinessUnit       = AddElement(c-message,"BusinessUnit")
                 c-BusinessUnitColl = AddElement(c-BusinessUnit,"BusinessUnitCollection")
                 c-FromRole         = AddElement(c-BusinessUnit,"FromRole")
                 c-ToRole           = AddElement(c-BusinessUnit,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo:
   
    ASSIGN c-BusinessUnitInfo = AddElement(c-BusinessUnitColl,"BusinessUnitInformation")
           c-campo            = AddEleChar(c-BusinessUnitInfo,"BusinessUnitCode" , tt_unid_negoc.cod_unid_negoc)
           c-campo            = AddEleChar(c-BusinessUnitInfo,"BusinessUnitName" , tt_unid_negoc.des_unid_negoc). 
        
END PROCEDURE.

PROCEDURE pi-rodape-msg:
    ASSIGN c-campo   = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo   = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-campo   = AddEleChar(c-ToRole,"LegacyLocationIdentifier",IF  i-cod-emitente <> 0
                                                                      THEN STRING(i-cod-emitente)
                                                                      ELSE "")
           c-campo   = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.

&ENDIF
