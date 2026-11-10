/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXQAR002 2.00.00.002 } /*** 010002 ***/


/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            AR2
&GLOBAL-DEFINE XmlMod            MCE
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    208
&GLOBAL-DEFINE XmlTranName       InventoryCountingQuery
&GLOBAL-DEFINE XmlMinTranVersion 208.000
&GLOBAL-DEFINE XmlMaxTranVersion 999.000
&GLOBAL-DEFINE XmlListOfAction   qry

/* DEFINICAO DE PRE-PROCESSADORES - END */

/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR cReturnValue AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranEvent AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranVersion AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR FinalBinLocationID AS CHARACTER INITIAL ? NO-UNDO.  /*Localizaá∆o final da consulta. Se for enviado somente o parÉmetro inicial o sistema entende que o final Ç o mesmo que o inicial.*/
DEFINE VAR FinalCountingSheetNumber AS integer INITIAL ? NO-UNDO.  /*N£mero da ficha de contagem final da consulta. Se for enviado somente o parÉmetro inicial o sistema entende que o final Ç o mesmo que o inicial.*/
DEFINE VAR FinalItemCode AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo de item final da consulta. Se for enviado somente o parÉmetro inicial o sistema entende que o final Ç o mesmo que o inicial.*/
DEFINE VAR FinalLot AS CHARACTER INITIAL ? NO-UNDO.  /*Lote final da consulta. Se for enviado somente o parÉmetro inicial o sistema entende que o final Ç o mesmo que o inicial.*/
DEFINE VAR FinalWarehouseID AS CHARACTER INITIAL ? NO-UNDO.  /*Dep¢sito final da consulta. Se for enviado somente o parÉmetro inicial o sistema entende que o final Ç o mesmo que o inicial.*/
DEFINE VAR hBusinessContent AS HANDLE NO-UNDO.
DEFINE VAR hGenXml AS HANDLE NO-UNDO.
DEFINE VAR hMessageHandler AS HANDLE NO-UNDO.
DEFINE VAR hQueryReturnContent AS HANDLE NO-UNDO.
DEFINE VAR InitialBinLocationID AS CHARACTER INITIAL ? NO-UNDO.  /*Localizaá∆o inicial da consulta*/
DEFINE VAR InitialCountingSheetNumber AS integer INITIAL ? NO-UNDO.  /*N£mero da ficha de contagem inicial da consulta*/
DEFINE VAR InitialItemCode AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo de item inicial da consulta*/
DEFINE VAR InitialLot AS CHARACTER INITIAL ? NO-UNDO.  /*Lote inicial da consulta*/
DEFINE VAR InitialWarehouseID AS CHARACTER INITIAL ? NO-UNDO.  /*Dep¢sito inicial da consulta*/
DEFINE VAR InventoryDate AS date INITIAL ? NO-UNDO.  /*Data de invent†rio. (Uso interno: Campo = mgind.inventario.dt-saldo)*/
DEFINE VAR LecturerUser AS CHARACTER INITIAL ? NO-UNDO.  /*Conferente da contagem. (Uso interno:              Tabela = mgind.inventario.   Campos = cod-confte-contag-1 ou cod-confte-contag-2 ou cod-confte-contag-3)*/
DEFINE VAR lSuccessProcess AS LOGICAL INITIAL ? NO-UNDO.
DEFINE VAR Site AS CHARACTER INITIAL ? NO-UNDO.  /*Estabelecimento.(Uso interno: Campo = mgind.inventario.cod-estabel)*/
DEFINE VAR iCountingSheets AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VAR lSelectedRange AS LOGICAL INITIAL NO NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro AS integer INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro AS character INITIAL ?
.

DEFINE TEMP-TABLE ttBatchValues NO-UNDO
     FIELD LaborValue AS decimal INITIAL ?  /*Valor de m∆o-de-obra. (Uso interno: Campo = mgind.inventario.valor-mob-m[1..3])*/
     FIELD MaterialValue AS decimal INITIAL ?  /*Valor de material. (Uso interno: Campo = mgind.inventario.valor-mat-m[1..3])*/
     FIELD OverHeadValue AS decimal INITIAL ?  /*Valor de gastos gerais de fabricaá∆o (GGF). (Uso interno: Campo = mgind.inventario.valor-ggf-m[1..3])*/
     FIELD Sequence AS integer INITIAL ?  /*Identificador sequencial. De 1 a 3*/
     FIELD ttBatchValuesID AS INTEGER INITIAL ?
     FIELD ttCountingSheetsID AS INTEGER INITIAL ?
.

DEFINE TEMP-TABLE ttCount NO-UNDO
     FIELD LecturerUser AS CHARACTER INITIAL ?  /*Conferente da contagem. (Uso interno:              Tabela = mgind.inventario.   Campos = cod-confte-contag-1 ou cod-confte-contag-2 ou cod-confte-contag-3)*/
     FIELD Quantity AS decimal INITIAL ?  /*Quantidade da contagem. (Uso interno: Campo = mgind.inventario.val-apurado[1..3])*/
     FIELD Sequence AS integer INITIAL ?  /*Identificador sequencial da contagem. De 1 a 3*/
     FIELD ttCountID AS INTEGER INITIAL ?
     FIELD ttCountingSheetsID AS INTEGER INITIAL ?
.
 
DEFINE TEMP-TABLE ttCountingSheets NO-UNDO
     FIELD BinLocationDescription AS CHARACTER INITIAL ?  /*Descriá∆o da localizaá∆o do material. (Uso interno: Campo = mgind.localizacao.descricao)*/
     FIELD BinLocationID AS CHARACTER INITIAL ?  /*C¢digo da localizaá∆o do material. (Uso interno: Campo = mgind.inventario.cod-localiz)*/
     FIELD CountingSheetNumber AS integer INITIAL ?  /*N£mero da ficha de contagem. Sequencial. (Uso interno: Campo = mgind.inventario.nr-ficha)*/
     FIELD CurrentQuantity AS decimal INITIAL ?  /*Quantidade Atual. (Uso interno: Campo = mgind.inventario.qtidade-atu)*/
     FIELD FinalQuantity AS decimal INITIAL ?  /*Quantidade final. (Uso interno: Campo = mgind.inventario.valor-final)*/
     FIELD InventoryDate AS date INITIAL ?  /*Data de invent†rio. (Uso interno: Campo = mgind.inventario.dt-saldo)*/
     FIELD ItemCode AS CHARACTER INITIAL ?  /*C¢digo do item. (Uso interno: Campo = mgind.inventario.it-codigo)*/
     FIELD ItemDescription AS CHARACTER INITIAL ?  /*Descriá∆o do item. (Uso interno: Campo = mgind.item.desc-item)*/
     FIELD LastEntryDate AS date INITIAL ?  /*Data da ultima entrada. (Uso interno: Campo = mgind.inventario.dt-ult-entra)*/
     FIELD LastOutputDate AS date INITIAL ?  /*Data da ultima sa°da. (Uso interno: Campo = mgind.inventario.dt-ult-saida)*/
     FIELD LotOrSerialNumber AS CHARACTER INITIAL ?  /*N£mero do lote ou n£mero de sÇrie do item. Elemento obrigat¢rio para itens controlados por lote, referencia ou n£mero de sÇrie. (Uso interno: Campo = mgind.inventario.lote)*/
     FIELD PrintStatus AS LOGICAL INITIAL ?  /*Status de impress∆o, se a ficha j† foi impressa. (Uso interno: Campo = mgind.inventario.impressa)*/
     FIELD ReferenceCode AS CHARACTER INITIAL ?  /*C¢digo da referància do item. (Uso interno: Campo = mgind.inventario.cod-refer)*/
     FIELD ReferenceDescription AS CHARACTER INITIAL ?  /*Descriá∆o da referància. (Uso interno: Campo = mgind.referencia.descricao)*/
     FIELD SiteDescription AS CHARACTER INITIAL ?  /*Descriá∆o do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
     FIELD SiteID AS CHARACTER INITIAL ?  /*C¢digo do estabelecimento. (Uso interno: Campo = mgind.inventario.cod-estabel)*/
     FIELD Situation AS integer INITIAL ?  /*Situaá∆o da ficha de contagem. Valores poss°veis: 1-Atualizado; 2-N∆o Atualizado; 3-Invent†rio OK, 4-OK p/Inventario. (Uso interno: Campo = mgind.inventario.situacao - Include = ininc/i01in157.i)*/
     FIELD SituationWMS AS integer INITIAL ?  /*Situaá∆o da ficha no m¢dulo WMS. (Uso interno: Campo = mgind.inventario.ind-sit-invent-wms)*/
     FIELD ttCountingSheetsID AS INTEGER INITIAL ?
     FIELD UpdateDate AS date INITIAL ?  /*Data de atualizaá∆o do invent†rio. (Uso interno: Campo = mgind.inventario.dt-atualiza)*/
     FIELD WarehouseDescription AS CHARACTER INITIAL ?  /*Descriá∆o do dep¢sito. (Uso interno: Campo = mgind.deposito.nome)*/
     FIELD WarehouseID AS CHARACTER INITIAL ?  /*C¢digo dep¢sito. (Uso interno: Campo = mgind.inventario.cod-depos)*/
     INDEX ixttCountingSheetsID IS PRIMARY UNIQUE ttCountingSheetsID ASCENDING
.

DEFINE TEMP-TABLE ttOnLineValues NO-UNDO
     FIELD LaborValue AS decimal INITIAL ?  /*Valor de m∆o-de-obra. (Uso interno: Campo = mgind.inventario.valor-mob-o[1..3])*/
     FIELD MaterialValue AS decimal INITIAL ?  /*Valor de material. (Uso interno: Campo = mgind.inventario.valor-mat-o[1..3])*/
     FIELD OverHeadValue AS decimal INITIAL ?  /*Valor de gastos gerais de fabricaá∆o (GGF). (Uso interno: Campo = mgind.inventario.valor-ggf-o[1..3])*/
     FIELD Sequence AS integer INITIAL ?  /*Identificador sequencial. De 1 a 3.*/
     FIELD ttCountingSheetsID AS INTEGER INITIAL ?
     FIELD ttOnLineValuesID AS INTEGER INITIAL ?
.

DEFINE TEMP-TABLE ttStandardValues NO-UNDO
     FIELD LaborValue AS decimal INITIAL ?  /*Valor de m∆o-de-obra. (Uso interno: Campo = mgind.inventario.valor-mob-p[1..3])*/
     FIELD MaterialValue AS decimal INITIAL ?  /*Valor de material. (Uso interno: Campo = mgind.inventario.valor-mat-p[1..3])*/
     FIELD OverHeadValue AS decimal INITIAL ?  /*Valor de gastos gerais de fabricaá∆o (GGF). (Uso interno: Campo = mgind.inventario.valor-ggf-p[1..3])*/
     FIELD Sequence AS integer INITIAL ?  /*Identificador sequencial. De 1 a 3*/
     FIELD ttCountingSheetsID AS INTEGER INITIAL ?
     FIELD ttStandardValuesID AS INTEGER INITIAL ?
.

/*LOCAL VARIABLES - END*/

/*PARAMETERS - BEGIN*/
/*PARAMETERS - END*/

{adapters/xml/ar2/axqar002ExtraDeclarations.i}

/* DEF. VARIµVEIS USADAS EM xmlLoadMessageHandlerRec.i */
{xmlinc/xmlLoadMessageHandlerRecDef.i}

/* DEFINE AS VARAIVEIS PARA USO DO xmlLoadGenXmlRec.i */
{xmlinc/xmlLoadGenXmlRecDef.i}


/* DEFINE AS VARIAVEIS PARA USO DO xmlgettranssubsinfo */
{xmlinc/xmlgettranssubsinfo.i}

DEFINE TEMP-TABLE ttStack NO-UNDO
     FIELD ttID AS INTEGER
     FIELD ttPos AS INTEGER
     INDEX tt_id IS PRIMARY UNIQUE
           ttID  ASCENDING.

FUNCTION addStack RETURN INTEGER (INPUT val AS INTEGER).
     DEFINE VAR id AS INTEGER INITIAL 1 NO-UNDO.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          id = ttStack.ttID + 1.

     CREATE ttStack.
     ASSIGN ttStack.ttID = id.
     ASSIGN ttStack.ttPos = val.
END FUNCTION.

FUNCTION delStack RETURN INTEGER.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          DELETE ttStack.

     FIND LAST ttStack NO-ERROR.
END FUNCTION.

FUNCTION getStack RETURN INTEGER.
     IF AVAIL(ttStack) THEN
          RETURN ttStack.ttPos.
     ELSE
          RETURN 0.
END FUNCTION.

/****** INTERNAL PROCEDURES - BEGIN*/
PROCEDURE PIQuery:

/*PARAMETERS - BEGIN*/
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR iId AS INTEGER INITIAL ? NO-UNDO.
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

     /* OBTEM A PARTE DA MENSAGEM QUE ESTÊ ABAIXO DO ELEMENTO BusinessContent */
     RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).

     /* LIMPA AS TEMP-TABLES INTERNAS DA API XML */
     RUN reset IN hGenXml.

     /* CARREGA A ESTRUTURA FILHA DE BusinessContent */
     RUN loadXml IN hGenXml (hBusinessContent).

     /* ELIMINA A MENSAGEM OBTIDA NO MêTODO getBusinessContent */
     DELETE OBJECT hBusinessContent NO-ERROR.

     /* ********* LEITURA DA MENSAGEM - BEGIN ********* */
     addStack(1).
          RUN searchTag IN hGenXml (INPUT "Parameters", INPUT getStack(), OUTPUT iId).
          if (iId <> ?) THEN DO:
               addStack(iId).

                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "Site", OUTPUT Site).
                    RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "InventoryDate", OUTPUT InventoryDate).
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "LecturerUser", OUTPUT LecturerUser).
                    RUN searchTag IN hGenXml (INPUT "Warehouse", INPUT getStack(), OUTPUT iId).
                    if (iId <> ?) THEN DO:
                         addStack(iId).

                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialWarehouseID", OUTPUT InitialWarehouseID).
                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalWarehouseID", OUTPUT FinalWarehouseID).
                         delStack().
                    END.

                    RUN searchTag IN hGenXml (INPUT "BinLocation", INPUT getStack(), OUTPUT iId).
                    if (iId <> ?) THEN DO:
                         addStack(iId).

                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialBinLocationID", OUTPUT InitialBinLocationID).
                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalBinLocationID", OUTPUT FinalBinLocationID).
                         delStack().
                    END.

                    RUN searchTag IN hGenXml (INPUT "Lot", INPUT getStack(), OUTPUT iId).
                    if (iId <> ?) THEN DO:
                         addStack(iId).

                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialLot", OUTPUT InitialLot).
                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalLot", OUTPUT FinalLot).
                         delStack().
                    END.

                    RUN searchTag IN hGenXml (INPUT "ItemCode", INPUT getStack(), OUTPUT iId).
                    if (iId <> ?) THEN DO:
                         addStack(iId).

                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialItemCode", OUTPUT InitialItemCode).
                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalItemCode", OUTPUT FinalItemCode).
                         delStack().
                    END.

                    RUN searchTag IN hGenXml (INPUT "CountingSheetNumber", INPUT getStack(), OUTPUT iId).
                    if (iId <> ?) THEN DO:
                         addStack(iId).

                              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "InitialCountingSheetNumber", OUTPUT InitialCountingSheetNumber).
                              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "FinalCountingSheetNumber", OUTPUT FinalCountingSheetNumber).
                         delStack().
                    END.

               delStack().
          END.

     delStack().
     /* ********* LEITURA DA MENSAGEM - END   ********* */


     /* ********* EFETIVAÄ«O - BEGIN ********* */

{adapters/xml/ar2/axqar002Query.i}

     /* ********* EFETIVAÄ«O - END   ********* */

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.


PROCEDURE createReturnTables:
    DEFINE VARIABLE iCount AS INTEGER INITIAL 0 NO-UNDO.

    /* Verifica se o valor da contagem est† em branco e se o  */
    /* usuario conferente Ç o conferente da contagem, no caso */
    /* de o conferente ter sido informado.                    */
    IF inventario.val-apurado[1] = ? THEN DO:
        IF LecturerUser <> ?
        AND LecturerUser <> inventario.cod-confte-contag-1 THEN 
            NEXT.
    END.
    ELSE DO:
        IF inventario.val-apurado[2] = ? THEN DO:
            IF LecturerUser <> ?
            AND LecturerUser <> inventario.cod-confte-contag-2 THEN 
                NEXT.
        END.
        ELSE DO:
            IF inventario.val-apurado[3] = ? THEN DO:
                IF LecturerUser <> ?
                AND LecturerUser <> inventario.cod-confte-contag-3 THEN 
                    NEXT.                                               
            END.
        END.
    END.

    assign iCountingSheets = iCountingSheets + 1.

    CREATE ttCountingSheets.
    ASSIGN ttCountingSheets.ttCountingSheetsID = iCountingSheets
           ttCountingSheets.CountingSheetNumber = inventario.nr-ficha
           ttCountingSheets.ItemCode = inventario.it-codigo
           ttCountingSheets.InventoryDate = inventario.dt-saldo
           ttCountingSheets.CurrentQuantity = inventario.qtidade-atu
           ttCountingSheets.FinalQuantity = inventario.valor-final
           ttCountingSheets.BinLocationID = inventario.cod-localiz
           ttCountingSheets.LastEntryDate = inventario.dt-ult-entra
           ttCountingSheets.LastOutputDate = inventario.dt-ult-saida
           ttCountingSheets.LotOrSerialNumber = inventario.lote
           ttCountingSheets.PrintStatus = inventario.impressa
           ttCountingSheets.ReferenceCode = inventario.cod-refer
           ttCountingSheets.SiteID = inventario.cod-estabel
           ttCountingSheets.Situation = inventario.situacao
           ttCountingSheets.SituationWMS = inventario.ind-sit-invent-wms
           ttCountingSheets.UpdateDate = inventario.dt-atualiza
           ttCountingSheets.WarehouseID = inventario.cod-depos.
           
    FIND FIRST item NO-LOCK 
         WHERE item.it-codigo = inventario.it-codigo NO-ERROR.
    IF AVAIL item THEN DO:
        ASSIGN ttCountingSheets.ItemDescription  = item.desc-item.
		
	  IF item.tipo-con-est = 4 THEN DO: /* Item controlado por referencia */
		FIND FIRST referencia NO-LOCK
                  WHERE referencia.cod-refer = inventario.cod-refer NO-ERROR.
		IF AVAIL referencia THEN
		    ASSIGN ttCountingSheets.ReferenceDescription = referencia.descricao.
	  END.
    END.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = inventario.cod-estabel NO-ERROR.
    IF AVAIL estabelec THEN
       ASSIGN ttCountingSheets.SiteDescription = estabelec.nome.

    FIND FIRST deposito NO-LOCK 
          WHERE deposito.cod-depos = inventario.cod-depos NO-ERROR.
    IF AVAIL deposito THEN
        ASSIGN ttCountingSheets.WarehouseDescription = deposito.nome.

    FIND FIRST localizacao NO-LOCK 
         WHERE localizacao.cod-estabel = inventario.cod-estabel
         AND   localizacao.cod-depos   = inventario.cod-depos
         AND   localizacao.cod-localiz = inventario.cod-localiz NO-ERROR.
    IF AVAIL localizacao THEN
       ASSIGN ttCountingSheets.BinLocationDescription = localizacao.descricao.

	DO iCount = 1 TO 3:
		/* Cria ttCount com as Contagens de cada ficha */

        IF inventario.valor-mob-m[iCount] <> 0
        OR inventario.valor-mat-m[iCount] <> 0 
        OR inventario.valor-ggf-m[iCount] <> 0 THEN DO:
            CREATE ttBatchValues.
            ASSIGN ttBatchValues.Sequence = iCount
                   ttBatchValues.LaborValue = inventario.valor-mob-m[iCount]
                   ttBatchValues.MaterialValue = inventario.valor-mat-m[iCount]
                   ttBatchValues.OverHeadValue = inventario.valor-ggf-m[iCount]
                   ttBatchValues.ttCountingSheetsID = ttCountingSheets.ttCountingSheetsID
    			   ttBatchValues.ttBatchValuesID = iCount.
        END.

        IF inventario.valor-mob-o[iCount] <> 0
        OR inventario.valor-mat-o[iCount] <> 0 
        OR inventario.valor-ggf-o[iCount] <> 0 THEN DO:
            CREATE ttOnLineValues. 
            ASSIGN ttOnLineValues.LaborValue = inventario.valor-mob-o[iCount]
                   ttOnLineValues.MaterialValue = inventario.valor-mat-o[iCount]
                   ttOnLineValues.OverHeadValue = inventario.valor-ggf-o[iCount]
                   ttOnLineValues.Sequence = iCount
                   ttOnLineValues.ttCountingSheetsID = ttCountingSheets.ttCountingSheetsID
                   ttOnLineValues.ttOnLineValuesID = iCount.
        END.                                            

        IF inventario.valor-mob-p[iCount] <> 0 
        OR inventario.valor-mat-p[iCount] <> 0 
        OR inventario.valor-ggf-p[iCount] <> 0 THEN DO:
            CREATE ttStandardValues.
            ASSIGN ttStandardValues.LaborValue = inventario.valor-mob-p[iCount]
                   ttStandardValues.MaterialValue = inventario.valor-mat-p[iCount]
                   ttStandardValues.OverHeadValue = inventario.valor-ggf-p[iCount]
                   ttStandardValues.Sequence = iCount
                   ttStandardValues.ttCountingSheetsID = ttCountingSheets.ttCountingSheetsID
                   ttStandardValues.ttStandardValuesID = iCount.
        END.                                                
                    
        CASE iCount:
            WHEN 1 THEN DO:
                IF inventario.val-apurado[1] = ? THEN DO:
                   IF LecturerUser = ?
                   OR LecturerUser = inventario.cod-confte-contag-1 THEN DO:
                       CREATE ttCount.
                       ASSIGN ttCount.ttCountingSheetsID = ttCountingSheets.ttCountingSheetsID
                              ttCount.ttCountID = iCount
                              ttCount.Sequence = iCount            
                              ttCount.Quantity = inventario.val-apurado[iCount]
                              ttCount.LecturerUser = inventario.cod-confte-contag-1.
                   END.
                END.
            END.
            WHEN 2 THEN DO:
                IF inventario.val-apurado[2] = ? THEN DO:
                   IF LecturerUser = ?
                   OR LecturerUser = inventario.cod-confte-contag-2 THEN DO:
                       CREATE ttCount.
                       ASSIGN ttCount.ttCountingSheetsID = ttCountingSheets.ttCountingSheetsID
                              ttCount.ttCountID = iCount
                              ttCount.Sequence = iCount            
                              ttCount.Quantity = inventario.val-apurado[iCount]
                              ttCount.LecturerUser = inventario.cod-confte-contag-2.
                   END.
                END.
            END.
            WHEN 3 THEN DO:
               IF LecturerUser = ?
               OR LecturerUser = inventario.cod-confte-contag-3 THEN DO:
                   CREATE ttCount.
                   ASSIGN ttCount.ttCountingSheetsID = ttCountingSheets.ttCountingSheetsID
                          ttCount.ttCountID = iCount
                          ttCount.Sequence = iCount            
                          ttCount.Quantity = inventario.val-apurado[iCount]
                          ttCount.LecturerUser = inventario.cod-confte-contag-3.
               END.
            END.
       END CASE.
    END.                                                    
    
END PROCEDURE.

PROCEDURE PIQueryReturnType:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM TABLE FOR ttBatchValues.
DEFINE INPUT PARAM TABLE FOR ttCount.
DEFINE INPUT PARAM TABLE FOR ttCountingSheets.
DEFINE INPUT PARAM TABLE FOR ttOnLineValues.
DEFINE INPUT PARAM TABLE FOR ttStandardValues.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR iId AS INTEGER INITIAL ? NO-UNDO.
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

     /* RESETA OS VALORES */
     RUN reset IN hGenXml.


     RUN addNode IN hGenXml (getStack(), "ListOfCountingSheets", "", OUTPUT iId).
     addStack(iId).

          FOR EACH ttCountingSheets:
               RUN addNode IN hGenXml (getStack(), "CountingSheets", "", OUTPUT iId).
               addStack(iId).

                    RUN addNodeDec IN hGenXml (getStack(), "CountingSheetNumber", ttCountingSheets.CountingSheetNumber, OUTPUT iId).
                    RUN addNodeDate IN hGenXml (getStack(), "InventoryDate", ttCountingSheets.InventoryDate, OUTPUT iId).
                    RUN addNode IN hGenXml (getStack(), "Item", "", OUTPUT iId).
                    addStack(iId).

                         RUN addNode IN hGenXml (getStack(), "ItemCode", ttCountingSheets.ItemCode, OUTPUT iId).
                         RUN addNode IN hGenXml (getStack(), "ItemDescription", ttCountingSheets.ItemDescription, OUTPUT iId).
                         RUN addNode IN hGenXml (getStack(), "Reference", "", OUTPUT iId).
                         addStack(iId).

                              RUN addNode IN hGenXml (getStack(), "ReferenceCode", ttCountingSheets.ReferenceCode, OUTPUT iId).
                              RUN addNode IN hGenXml (getStack(), "ReferenceDescription", ttCountingSheets.ReferenceDescription, OUTPUT iId).
                         delStack().

                    delStack().

                    RUN addNode IN hGenXml (getStack(), "Location", "", OUTPUT iId).
                    addStack(iId).

                         RUN addNode IN hGenXml (getStack(), "Site", "", OUTPUT iId).
                         addStack(iId).

                              RUN addNode IN hGenXml (getStack(), "SiteID", ttCountingSheets.SiteID, OUTPUT iId).
                              RUN addNode IN hGenXml (getStack(), "SiteDescription", ttCountingSheets.SiteDescription, OUTPUT iId).
                         delStack().

                         RUN addNode IN hGenXml (getStack(), "Warehouse", "", OUTPUT iId).
                         addStack(iId).

                              RUN addNode IN hGenXml (getStack(), "WarehouseID", ttCountingSheets.WarehouseID, OUTPUT iId).
                              RUN addNode IN hGenXml (getStack(), "WarehouseDescription", ttCountingSheets.WarehouseDescription, OUTPUT iId).
                         delStack().

                         RUN addNode IN hGenXml (getStack(), "BinLocation", "", OUTPUT iId).
                         addStack(iId).

                              RUN addNode IN hGenXml (getStack(), "BinLocationID", ttCountingSheets.BinLocationID, OUTPUT iId).
                              RUN addNode IN hGenXml (getStack(), "BinLocationDescription", ttCountingSheets.BinLocationDescription, OUTPUT iId).
                         delStack().

                         RUN addNode IN hGenXml (getStack(), "LotOrSerialNumber", ttCountingSheets.LotOrSerialNumber, OUTPUT iId).
                    delStack().

                    RUN addNodeDec IN hGenXml (getStack(), "BalanceAccounting", 0, OUTPUT iId).
                    RUN addNodeDec IN hGenXml (getStack(), "Situation", ttCountingSheets.Situation, OUTPUT iId).
                    RUN addNode IN hGenXml (getStack(), "Counts", "", OUTPUT iId).
                    addStack(iId).

                         FOR EACH ttCount OF ttCountingSheets:
                              RUN addNode IN hGenXml (getStack(), "Count", "", OUTPUT iId).
                              addStack(iId).

                                   RUN addNodeDec IN hGenXml (getStack(), "Sequence", ttCount.Sequence, OUTPUT iId).
                                   RUN addNodeDec IN hGenXml (getStack(), "Quantity", ttCount.Quantity, OUTPUT iId).
                                   RUN addNode IN hGenXml (getStack(), "LecturerUser", ttCount.LecturerUser, OUTPUT iId).
                              delStack().

                         END.
                    delStack().

                    RUN addNodeDate IN hGenXml (getStack(), "UpdateDate", ttCountingSheets.UpdateDate, OUTPUT iId).
                    RUN addNodeDate IN hGenXml (getStack(), "LastEntryDate", ttCountingSheets.LastEntryDate, OUTPUT iId).
                    RUN addNodeDate IN hGenXml (getStack(), "LastOutputDate", ttCountingSheets.LastOutputDate, OUTPUT iId).
                    RUN addNodeDec IN hGenXml (getStack(), "CurrentQuantity", ttCountingSheets.CurrentQuantity, OUTPUT iId).
                    RUN addNodeDec IN hGenXml (getStack(), "FinalQuantity", ttCountingSheets.FinalQuantity, OUTPUT iId).
                    RUN addNode IN hGenXml (getStack(), "CostingValues", "", OUTPUT iId).
                    addStack(iId).

                         RUN addNode IN hGenXml (getStack(), "ListOfBatchAverageValues", "", OUTPUT iId).
                         addStack(iId).

                              FOR EACH ttBatchValues OF ttCountingSheets:
                                   RUN addNode IN hGenXml (getStack(), "BatchValues", "", OUTPUT iId).
                                   addStack(iId).

                                        RUN addNodeDec IN hGenXml (getStack(), "Sequence", ttBatchValues.Sequence, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "MaterialValue", ttBatchValues.MaterialValue, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "LaborValue", ttBatchValues.LaborValue, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "OverHeadValue", ttBatchValues.OverHeadValue, OUTPUT iId).
                                   delStack().

                              END.
                         delStack().

                         RUN addNode IN hGenXml (getStack(), "ListOfOnLineAverageValues", "", OUTPUT iId).
                         addStack(iId).

                              FOR EACH ttOnLineValues OF ttCountingSheets:
                                   RUN addNode IN hGenXml (getStack(), "OnLineValues", "", OUTPUT iId).
                                   addStack(iId).

                                        RUN addNodeDec IN hGenXml (getStack(), "Sequence", ttOnLineValues.Sequence, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "MaterialValue", ttOnLineValues.MaterialValue, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "LaborValue", ttOnLineValues.LaborValue, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "OverHeadValue", ttOnLineValues.OverHeadValue, OUTPUT iId).
                                   delStack().

                              END.
                         delStack().

                         RUN addNode IN hGenXml (getStack(), "ListOfStandardCostValues", "", OUTPUT iId).
                         addStack(iId).

                              FOR EACH ttStandardValues OF ttCountingSheets:
                                   RUN addNode IN hGenXml (getStack(), "StandardValues", "", OUTPUT iId).
                                   addStack(iId).

                                        RUN addNodeDec IN hGenXml (getStack(), "Sequence", ttStandardValues.Sequence, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "MaterialValue", ttStandardValues.MaterialValue, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "LaborValue", ttStandardValues.LaborValue, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "OverHeadValue", ttStandardValues.OverHeadValue, OUTPUT iId).
                                   delStack().

                              END.
                         delStack().

                    delStack().

                    RUN addNodeLog IN hGenXml (getStack(), "PrintStatus", ttCountingSheets.PrintStatus, OUTPUT iId).
                    RUN addNodeDec IN hGenXml (getStack(), "SituationWMS", ttCountingSheets.SituationWMS, OUTPUT iId).
               delStack().

          END.
     delStack().



     /* OBTEM O XML NUMA HANDLE */
     RUN generateXML IN hGenXml (OUTPUT hQueryReturnContent). /* gera XML */
/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.


PROCEDURE receiveMessage:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM hInputXML AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAM hOutputXML AS HANDLE NO-UNDO.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

     /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
     {xmlinc/xmlLoadMessageHandlerRec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

     IF cReturnValue <> "OK" THEN DO:
          RETURN cReturnValue.
     END.

     /* INTERPRETA, ARMAZENA E VALIDA A MENSAGEM QUE RECEBE */
     RUN parseMessage IN hMessageHandler (
          INPUT  hInputXml, INPUT "{&XmlTranName}", 
          INPUT "{&XmlMaxTranVersion}", 
          INPUT "{&XmlMinTranVersion}", 
          INPUT "{&XmlListOfEvents}",
          OUTPUT lSuccessProcess,
          OUTPUT cTranAction, 
          OUTPUT cTranEvent,
          OUTPUT cTranVersion,
          OUTPUT hOutputXML ).

     /* SE N«O PROCESSOU CORRETAMENTE RETORNA ERRO */
     IF NOT lSuccessProcess OR RETURN-VALUE <> "OK" THEN 
     /* DAR TRATAMENTO CONVENIENTE ANTES DE RETORNAR */
          RETURN RETURN-VALUE.

     /* VERIFICA SE APIXML ESTA NA MEMORIA */
     {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOutputXML"}

     /* VERIFICA SE O ut-genxml FOI INICIADO CORRETAMENTE */
     IF cReturnValue <> "OK"
     THEN DO:
          /* ELIMINA A MENSAGEM OBTIDA NO M?TODO getBusinessContent */
          DELETE OBJECT hBusinessContent NO-ERROR.

          RETURN cReturnValue.
     END.



{adapters/xml/ar2/axqar002VersionControl.i}



/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.


/****** INTERNAL PROCEDURES - END*/




