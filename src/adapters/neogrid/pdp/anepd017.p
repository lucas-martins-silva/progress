/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD017 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD017 MPD}
&ENDIF


/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

{utp/ut-glob.i}

DEFINE INPUT  PARAMETER c-refer                  AS ROWID      NO-UNDO.
DEFINE INPUT  PARAMETER changecode               AS CHARACTER  NO-UNDO.

DEFINE VARIABLE c-root                           AS CHAR NO-UNDO. 
DEFINE VARIABLE c-message                        AS CHAR NO-UNDO.
DEFINE VARIABLE c-reference                      AS CHAR NO-UNDO.
DEFINE VARIABLE c-ReferenceInformationCollec     AS CHAR NO-UNDO. 
DEFINE VARIABLE c-ReferenceInformation           AS CHAR NO-UNDO. 
DEFINE VARIABLE c-ExchangeRateInformation        AS CHAR NO-UNDO.
DEFINE VARIABLE c-referenceCollection            AS CHAR NO-UNDO.
DEFINE VARIABLE c-ExchRatePeriodInfoCollection   AS CHAR NO-UNDO.

DEFINE VARIABLE c-ExchRatePeriodInfo             AS CHAR NO-UNDO.
DEFINE VARIABLE c-ExchangeRateCollection         AS CHAR NO-UNDO.
DEFINE VARIABLE c-campo                          AS CHAR NO-UNDO.
DEFINE VARIABLE c-FromRole                       AS CHAR NO-UNDO.
DEFINE VARIABLE c-ToRole                         AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN


{adapters/neogrid/include/anein004.i} /*sender*/


RUN pi-cabecalho-msg.

  IF  c-refer <> ? THEN DO:
      FIND FIRST referencia WHERE ROWID(referencia) =  c-refer NO-LOCK NO-ERROR.
          RUN  pi-corpo-msg.
      
  END.
  ELSE DO:
       FOR EACH referencia NO-LOCK:
           RUN  pi-corpo-msg.
       END.
  END.

WRITExml().

PROCEDURE pi-cabecalho-msg:

    ASSIGN c-root                        = CreateNeoGridDoc("reference","1.01.001","1")       
           c-message                     = AddElement(c-root,"CRM")
           c-message                     = AddElement(c-root,"Message")  
           c-campo = AddEleChar(c-message,"GlobalReferenceChangeCode",changecode)
           c-reference        = AddElement(c-message,"reference")                
           c-referenceCollection    = AddElement(c-reference,"referenceCollection").    


END PROCEDURE.

PROCEDURE pi-corpo-msg:
    
        ASSIGN c-referenceInformation = AddElement(c-referenceCollection,"referenceInformation")
               c-campo = AddEleChar(c-referenceInformation,"ReferenceName",REFERENCIA.DESCRICAO)
               c-campo = AddElechar(c-referenceInformation,"ReferenceCode",REFERENCIA.COD-REFER).
    
END PROCEDURE.

&ENDIF
