/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD018 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD018 MPD}
&ENDIF



/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */


    {utp/ut-glob.i}

    DEFINE INPUT  PARAMETER c-itemrefer              AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER changecode               AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE c-root                           AS CHAR NO-UNDO. 
    DEFINE VARIABLE c-message                        AS CHAR NO-UNDO.
    DEFINE VARIABLE c-itemreference                  AS CHAR NO-UNDO.
    DEFINE VARIABLE c-itemReferenceInformationCollec AS CHAR NO-UNDO. 
    DEFINE VARIABLE c-itemReferenceInformation       AS CHAR NO-UNDO. 
    DEFINE VARIABLE c-ExchangeRateInformation        AS CHAR NO-UNDO.
    DEFINE VARIABLE c-itemreferenceCollection        AS CHAR NO-UNDO.
    DEFINE VARIABLE c-ExchRatePeriodInfoCollection   AS CHAR NO-UNDO.

    DEFINE VARIABLE c-ExchRatePeriodInfo             AS CHAR NO-UNDO.
    DEFINE VARIABLE c-ExchangeRateCollection         AS CHAR NO-UNDO.
    DEFINE VARIABLE c-campo                          AS CHAR NO-UNDO.
    DEFINE VARIABLE c-FromRole                       AS CHAR NO-UNDO.
    DEFINE VARIABLE c-ToRole                         AS CHAR NO-UNDO.

    &IF int(entry(1,proversion,".")) >= 8 &THEN


    {adapters/neogrid/include/anein004.i} /*sender*/


    RUN pi-cabecalho-msg.

      IF  c-itemrefer <> ? THEN DO:
          FIND FIRST REF-ITEM WHERE ROWID(REF-ITEM) =  c-itemrefer NO-LOCK NO-ERROR.
          IF AVAIL ref-item THEN DO:
             RUN   pi-corpo-msg.
          END.
      END.
      ELSE DO:
           FOR EACH REF-ITEM NO-LOCK:
               RUN  pi-corpo-msg.
           END.
      END.

    WRITExml().

    PROCEDURE pi-cabecalho-msg:

        ASSIGN c-root = CreateNeoGridDoc("itemreference","1.01.001","1")
               c-message                     = AddElement(c-root,"CRM")
               c-message = AddElement(c-root,"Message")
               /*c-ToRole                        = AddElement(c-message,"reference")*/
               c-campo = AddEleChar(c-message,"GlobalItemReferenceChangeCode",changecode)
               c-ITEMReference        = AddElement(c-message,"Itemreference") 
               c-itemReferenceCollection    = AddElement(c-itemReference,"ItemReferenceCollection").



    END PROCEDURE.

    PROCEDURE pi-corpo-msg:

            ASSIGN c-itemreferenceInformation = AddElement(c-itemreferenceCollection,"ItemreferenceInformation")
                   c-campo = AddEleChar(c-ItemreferenceInformation,"ReferenceItem",REF-ITEM.IT-CODIGO)
                   c-campo = AddElechar(c-ItemreferenceInformation,"ReferenceCode",REF-ITEM.COD-REFER).

    END PROCEDURE.

    &ENDIF




