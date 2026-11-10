&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX312C 2.00.00.046 } /*** "010046" 07/10/2024 16:59:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx312c MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName Pedido-drb
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName Pedido-drb
&GLOBAL-DEFINE TableLabel Pedido-drb
&GLOBAL-DEFINE QueryName qr{&TableName}


/*--- Include com definiá∆o da temptable RowObject ---*/
{cxbo/bocx312.i RowObject}
{cxbo/bocx312.i tt-ped-drb}
{cxbo/bocx332.i tt-movto-ato}
{inbo/boin111a.i tt-item-estrut} /* Definiá∆o TempTable Estrutura do Item */
{inbo/boin111a.i tt-item-estrut-agrup} /* Definiá∆o TempTable Estrutura do Item */
{exp/ex4330.i} /* Definiá∆o da Temp-Table tt-ex4330-retorno */
{exp/ex4333.i tt-itens-sem-saldo}

{include/boerrtab.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}

{utp/ut-glob.i}

{include/i-epc200.i bocx312c}

/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/

DEFINE VARIABLE h-boin111a              AS HANDLE     NO-UNDO.
DEFINE VARIABLE d-qtd-baixada           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE d-qtd-indisp            AS DECIMAL    NO-UNDO.
DEFINE VARIABLE l-hab-contr-pai         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-controle-cab          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-controle-cab-pai      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-controle-cab-comps    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-controle-componentes  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-controle-rodape       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-seq-erro              AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-cont-seq              AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-programa              AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-ult-seq-nota          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-nao-encontrou-pai-saida AS LOGICAL  NO-UNDO.
define variable l-executado-flex        as logical    no-undo.
DEFINE VARIABLE h-bocx332               AS HANDLE NO-UNDO.

DEFINE VARIABLE c-cod-est        AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-pedido-ant     AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE d-data-val       AS DATE                        NO-UNDO.
DEFINE VARIABLE de-valor-baixa   AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-tot-quant-ent AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-tot-valor-ent AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-valor-conv    AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE c-nr-re          LIKE proc-siscomex.nr-re       NO-UNDO.
DEFINE VARIABLE d-data-emis-nf   LIKE nota-fiscal.dt-emis-nota  NO-UNDO.
DEFINE VARIABLE l-internacional  AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-next           AS LOGICAL INITIAL NO          NO-UNDO.
DEFINE VARIABLE i-moeda-aux      AS INTEGER                     NO-UNDO.
DEFINE VARIABLE dcTotal          AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE l-verifica-saldo AS LOGICAL                     NO-UNDO.
define variable c-nome-abrev   like it-pre-fat.nome-abrev no-undo.
define variable c-nr-pedcli    like it-pre-fat.nr-pedcli  no-undo.
define variable c-it-codigo    like it-pre-fat.it-codigo  no-undo.
define variable d-qtd-item-pai like it-pre-fat.qt-alocada no-undo.
define variable c-cod-refer    like it-pre-fat.cod-refer  no-undo.
define variable i-nr-seq       like it-pre-fat.nr-sequencia no-undo.
define variable c-cod-registro as   character             no-undo.

DEF VAR d-novo-saldo-proporcional      LIKE movto-ato.val-movto-ato-me NO-UNDO.
DEF VAR d-novo-saldo-proporcional-conv LIKE movto-ato.val-movto-ato-me NO-UNDO.
DEF VAR d-qtd-saldo-aux    AS DECIMAL FORMAT ">>>>>,>>9.9999":U NO-UNDO.
DEF VAR d-val-saldo-aux    AS DECIMAL FORMAT ">>>>>,>>9.9999":U NO-UNDO.
DEF VAR d-tot-qtd-ent-aux  AS DECIMAL FORMAT ">>>>>,>>9.9999":U NO-UNDO.
DEF VAR d-tot-qtd-sai-aux  AS DECIMAL FORMAT ">>>>>,>>9.9999":U NO-UNDO.
DEF VAR de-novo-valor      AS DECIMAL FORMAT ">>>>>,>>9.9999":U NO-UNDO.
DEF VAR i-tip-item-movto   AS INTEGER                           NO-UNDO. /* 1 - internacional; 2 - nacional */


DEFINE VAR de-qtde-tot-movto  LIKE movto-ato.val-quant-movto-ato NO-UNDO.
DEFINE VAR de-valor-tot-movto LIKE movto-ato.val-movto-ato-me    NO-UNDO. 
/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName}    FOR {&TableName}.
DEFINE BUFFER bfPedido-drb-item FOR pedido-drb-item.

DEFINE TEMP-TABLE tt-pedido-drb-aux NO-UNDO
    FIELD cod-estabel       LIKE pedido-drb.cod-estabel
    FIELD nr-pedido-drb     LIKE pedido-drb.nr-pedido-drb
    FIELD data-validade-ato LIKE pedido-drb.data-validade-ato.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.13
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* **********************  Internal Procedures  *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraMovtoAto DBOProgram 
PROCEDURE geraMovtoAto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER r-rowid-nota-fiscal  AS ROWID NO-UNDO. 
    DEFINE INPUT PARAMETER r-rowid-it-nota-fisc AS ROWID NO-UNDO.   

    DEFINE VARIABLE de-qt-usada-total   AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE de-qt-aloc-total    AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE l-embarque          AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE i-cont-prog         AS INTEGER            NO-UNDO.
    
    assign i-cont-prog = 1.
    
    cont-prog:
    DO  WHILE PROGRAM-NAME(i-cont-prog) <> ?:
        IF  PROGRAM-NAME(i-cont-prog) MATCHES "*ft4002*":U  THEN DO:
            ASSIGN i-programa = 4002.
            LEAVE cont-prog.
        END.

        IF PROGRAM-NAME(i-cont-prog) MATCHES "*ft4001*":U  THEN DO:
            ASSIGN i-programa = 4001.
            LEAVE cont-prog.
        end.
        ASSIGN i-cont-prog = i-cont-prog + 1.
    END.

    FOR FIRST nota-fiscal
        WHERE ROWID(nota-fiscal) = r-rowid-nota-fiscal NO-LOCK:
    END.
    
    FOR FIRST it-nota-fisc FIELDS(it-codigo nr-seq-fat cod-refer qt-faturada it-codigo) 
        WHERE ROWID(it-nota-fisc) = r-rowid-it-nota-fisc NO-LOCK:
    END.
    
    IF NOT AVAIL nota-fiscal OR NOT AVAIL it-nota-fisc THEN
        RETURN.
    
    IF  c-nom-prog-dpc-mg97  <> "" 
    OR  c-nom-prog-appc-mg97 <> "" 
    OR  c-nom-prog-upc-mg97  <> "" THEN DO:
        FOR EACH tt-epc
            WHERE tt-epc.cod-event = "BaixaSaldoAto":U :
            DELETE tt-epc.
        END.

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "BaixaSaldoAto":U
               tt-epc.cod-parameter = "RowidNotafiscal":U
               tt-epc.val-parameter = STRING(r-rowid-nota-fiscal).

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "BaixaSaldoAto":U
               tt-epc.cod-parameter = "RowidItNotafisc":U
               tt-epc.val-parameter = STRING(r-rowid-it-nota-fisc).
        
        {include/i-epc201.i "BaixaSaldoAto"}
        
    END.                 

    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = "BaixaSaldoAto"             
         AND   tt-epc.cod-parameter = "RetornoBaixaSaldoAto"      
         AND   tt-epc.val-parameter = "OK" NO-LOCK NO-ERROR.
    IF AVAIL tt-epc THEN
        RETURN.
    
    assign l-verifica-saldo = no.

    FIND first emitente WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.
    
    FIND proc-ped-ent WHERE proc-ped-ent.cod-estabel  = nota-fiscal.cod-estab-proces-export AND
                            proc-ped-ent.nr-proc-exp  = nota-fiscal.nr-proc-exp AND
                            proc-ped-ent.nome-abrev   = it-nota-fisc.nome-ab-cli AND
                            proc-ped-ent.nr-pedcli    = it-nota-fisc.nr-pedcli AND
                            proc-ped-ent.nr-sequencia = it-nota-fisc.nr-seq-ped AND
                            proc-ped-ent.it-codigo    = it-nota-fisc.it-codigo AND
                            proc-ped-ent.cod-refer    = it-nota-fisc.cod-refer AND
                            proc-ped-ent.nr-entrega   = it-nota-fisc.nr-entrega NO-LOCK NO-ERROR.

    IF nota-fiscal.nr-siscomex <> "" THEN
        ASSIGN c-nr-re = nota-fiscal.nr-siscomex.
    ELSE DO:
        IF AVAIL proc-ped-ent THEN DO:
            FIND FIRST reg-export-item
                WHERE  reg-export-item.cod-estabel = proc-ped-ent.cod-estabel   AND 
                       reg-export-item.nr-proc-exp = proc-ped-ent.nr-proc-exp   AND
                       reg-export-item.nome-abrev  = proc-ped-ent.nome-abrev    AND
                       reg-export-item.nr-pedcli   = proc-ped-ent.nr-pedcli     AND
                       reg-export-item.it-codigo   = proc-ped-ent.it-codigo     AND
                       reg-export-item.cod-refer   = proc-ped-ent.cod-refer     AND
                       reg-export-item.nr-entrega  = proc-ped-ent.nr-entrega    NO-LOCK NO-ERROR.
            IF AVAIL reg-export-item THEN DO:
                FIND FIRST reg-export
                    WHERE reg-export.nr-re-ems = reg-export-item.nr-re-ems NO-LOCK NO-ERROR.
                IF AVAIL reg-export THEN
                    ASSIGN c-nr-re        = reg-export.nr-re-siscomex 
                           d-data-emis-nf = reg-export.dat-reg-export.
            END.                             
        END.                          
    END.
    
    find first proc-siscomex where proc-siscomex.cod-estabel = nota-fiscal.cod-estab-proces-export AND 
                                   proc-siscomex.nr-proc-exp = nota-fiscal.nr-proc-exp AND
                                   proc-siscomex.nr-re       = c-nr-re no-lock no-error.

    FIND ITEM WHERE item.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

    FIND ped-venda WHERE ped-venda.nome-abrev = it-nota-fisc.nome-ab-cli AND
                         ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli NO-LOCK NO-ERROR.

    ASSIGN d-data-emis-nf = nota-fiscal.dt-emis-nota.
    
    FOR EACH tt-item-estrut:
        DELETE tt-item-estrut.
    END.

    /**/

    ASSIGN l-hab-contr-pai      = NO
           l-controle-cab-pai   = NO
           l-controle-cab-comps = NO.

    IF CAN-FIND(FIRST tt-ex4330-retorno 
                WHERE tt-ex4330-retorno.it-codigo-pai  = it-nota-fisc.it-codigo 
                  AND tt-ex4330-retorno.nr-seq-ped-pai = it-nota-fisc.nr-seq-ped) THEN DO:

        /* Rotina Manual pelo programa Faturamento de Pedidos - ft4002 */
        IF nota-fiscal.nr-resumo <> 0 THEN
            ASSIGN l-embarque = YES.
        ELSE
            ASSIGN l-embarque = NO.

        FOR EACH tt-ex4330-retorno 
           WHERE tt-ex4330-retorno.it-codigo-pai  = it-nota-fisc.it-codigo 
             AND tt-ex4330-retorno.nr-seq-ped-pai = it-nota-fisc.nr-seq-ped NO-LOCK:

            /*Deve considerar apenas os movtos do resumo da NOTA selecionada*/
            IF l-embarque 
                AND tt-ex4330-retorno.nr-resumo <> nota-fiscal.nr-resumo
                THEN
                NEXT.

            ASSIGN i-cont-seq = 0
                   l-controle-componentes = NO.
    
            FOR EACH movto-ato WHERE movto-ato.cod-estabel   = tt-ex4330-retorno.cod-estabel   AND
                                     movto-ato.nr-pedido-drb = tt-ex4330-retorno.nr-pedido-drb AND
                                     movto-ato.it-codigo     = tt-ex4330-retorno.it-codigo     NO-LOCK:
                IF movto-ato.sequencia > i-cont-seq THEN
                    ASSIGN i-cont-seq = movto-ato.sequencia.
            END.

            FIND pedido-drb-item WHERE pedido-drb-item.cod-estabel   = tt-ex4330-retorno.cod-estabel   AND
                                       pedido-drb-item.nr-pedido-drb = tt-ex4330-retorno.nr-pedido-drb AND
                                       pedido-drb-item.it-codigo     = tt-ex4330-retorno.it-codigo     AND 
                                       pedido-drb-item.idi-reg       = 1 EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL pedido-drb-item THEN DO:

                ASSIGN de-tot-quant-ent = 0
                       de-tot-valor-ent = 0.

                FOR EACH  movto-ato
                    WHERE movto-ato.cod-estabel   = pedido-drb-item.cod-estabel
                    AND   movto-ato.nr-pedido-drb = pedido-drb-item.nr-pedido-drb
                    AND   movto-ato.it-codigo     = pedido-drb-item.it-codigo
                    AND   movto-ato.idi-tip-movto = 1 /*Entrada*/ NO-LOCK:
                            
                    IF pedido-drb-item.moeda <> 0 THEN
                        RUN cdp/cd0812.p (input movto-ato.mo-codigo,
                                          INPUT pedido-drb-item.moeda , 
                                          INPUT movto-ato.val-movto-ato-me, 
                                          INPUT movto-ato.dat-cotac, 
                                          OUTPUT de-valor-conv).
                    ELSE
                        ASSIGN de-valor-conv = movto-ato.val-movto-ato-me.
                    
                    ASSIGN de-tot-quant-ent = de-tot-quant-ent + movto-ato.val-quant-movto-ato
                           de-tot-valor-ent = de-tot-valor-ent + de-valor-conv.
                END.

				FIND FIRST estabelec 
					 WHERE estabelec.cod-estabel = pedido-drb-item.cod-estabel NO-LOCK NO-ERROR.
				
                IF emitente.natureza > 2 
                    AND emitente.pais <> estabelec.pais THEN /*internacional*/
                    FIND FIRST pedido-drb WHERE pedido-drb.cod-estabel         = pedido-drb-item.cod-estabel 
                                          AND pedido-drb.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb NO-LOCK NO-ERROR.
                ELSE /*nacional*/
                    FIND FIRST pedido-drb WHERE pedido-drb.cod-estabel         = pedido-drb-item.cod-estabel 
                                          AND pedido-drb.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb 
                                          AND pedido-drb.log-draw-integrad NO-LOCK NO-ERROR.
                IF AVAIL pedido-drb THEN DO:
                    /* N∆o permite que sejam gerados movto-ato.dat-movto para atos concess¢rios vencidos
                       A data de movimento de baixa do ato concessorio Ç criado com "today" */
                    IF pedido-drb.data-validade-ato < TODAY THEN NEXT. 

                    /* Validaá∆o Saldo - Inicio */
					
						IF  tt-ex4330-retorno.quantidade > 0 AND
                            tt-ex4330-retorno.quantidade > pedido-drb-item.qtd-sdo-item THEN DO:
														
							IF l-hab-contr-pai = NO THEN
								ASSIGN l-controle-cab-pai   = YES
									   l-controle-cab-comps = YES
									   l-hab-contr-pai      = YES.
							ELSE 
								ASSIGN l-controle-cab-pai   = NO
									   l-controle-cab-comps = NO.
														
							ASSIGN l-controle-componentes       = YES
								   d-qtd-baixada                = pedido-drb-item.qtd-sdo-item
								   d-qtd-indisp                 = tt-ex4330-retorno.quantidade - d-qtd-baixada
								   tt-ex4330-retorno.quantidade = d-qtd-baixada.

						END.

                        IF tt-ex4330-retorno.quantidade > 0 THEN
                            RUN pi-gera-movto-ato-tipo-mercado (INPUT 1).

                        ASSIGN l-controle-cab-pai     = NO
                               l-controle-cab-comps   = NO
                               l-hab-contr-pai        = NO
							   l-controle-componentes = NO
                               d-qtd-baixada          = 0
                               d-qtd-indisp           = 0.

                        ASSIGN i-cont-seq = i-cont-seq + 1.
                               
						IF  pedido-drb.log-draw-integrad       AND
                            tt-ex4330-retorno.qtd-item-nac > 0 AND
                            tt-ex4330-retorno.qtd-item-nac > pedido-drb-item.qtd-sdo-item-nac THEN DO:
														
							IF l-hab-contr-pai = NO THEN
								ASSIGN l-controle-cab-pai = YES
									   l-controle-cab-comps = YES
									   l-hab-contr-pai = YES.
							ELSE 
								ASSIGN l-controle-cab-pai = NO
									   l-controle-cab-comps = NO.
														
							ASSIGN l-controle-componentes = YES
								   d-qtd-baixada = pedido-drb-item.qtd-sdo-item-nac
								   d-qtd-indisp = tt-ex4330-retorno.quantidade - d-qtd-baixada
								   tt-ex4330-retorno.quantidade = d-qtd-baixada.
						END.
                        IF tt-ex4330-retorno.qtd-item-nac > 0 THEN
                            RUN pi-gera-movto-ato-tipo-mercado (INPUT 2).
                END.
            END.
        END.
    END.
    ELSE DO:

        /* Rotina Autom†tica Faturamento de Pedidos - FIFO */

        FIND FIRST param-global NO-LOCK NO-ERROR.

        IF param-global.modulo-en THEN DO:

            IF NOT VALID-HANDLE(h-boin111a) OR
                h-boin111a:TYPE <> "PROCEDURE":U OR
                h-boin111a:FILE-NAME <> "inbo/boin111a.p":U THEN DO:

                RUN inbo/boin111a.p persistent set h-boin111a.
            END.
            
            RUN setConstraint2 IN h-boin111a (INPUT STRING(it-nota-fisc.cod-refer),
                                              INPUT STRING(it-nota-fisc.qt-faturada[1]),
                                              INPUT "19",
                                              INPUT STRING(TODAY),
                                              INPUT ">>>>>,>>9.9999", 
                                              INPUT STRING(it-nota-fisc.it-codigo)).

            IF i-pais-impto-usuario <> 1 THEN
                run isDrbInternacional in h-boin111a.                                      

            RUN montaEstrutura IN h-boin111a.
            RUN openQuery IN h-boin111a (INPUT 1).
            RUN getTTEstrutura IN h-boin111a (OUTPUT TABLE tt-item-estrut).
			
			IF VALID-HANDLE(h-boin111a) THEN DO:
				DELETE PROCEDURE h-boin111a.
				ASSIGN h-boin111a = ?.
			END.
            
            ASSIGN c-cod-est    = ""
                   c-pedido-ant = ""
                   d-data-val   = ?.

            EMPTY TEMP-TABLE tt-pedido-drb-aux.
            EMPTY TEMP-TABLE tt-item-estrut-agrup.


            FOR EACH tt-item-estrut:

                FIND FIRST tt-item-estrut-agrup 
                     WHERE tt-item-estrut-agrup.it-codigo = tt-item-estrut.it-codigo NO-ERROR.

                IF NOT AVAIL tt-item-estrut-agrup THEN DO:
                    CREATE tt-item-estrut-agrup.
                    BUFFER-COPY tt-item-estrut TO tt-item-estrut-agrup.
                END.
                ELSE 
                    ASSIGN tt-item-estrut-agrup.quant-usada = tt-item-estrut-agrup.quant-usada + tt-item-estrut.quant-usada.

                ASSIGN l-nao-encontrou-pai-saida = YES.

				IF  c-nom-prog-dpc-mg97  <> "" 
				OR  c-nom-prog-appc-mg97 <> "" 
				OR  c-nom-prog-upc-mg97  <> "" THEN DO:
					
					FOR EACH tt-epc
						WHERE tt-epc.cod-event = "NextPedido-drb-item":U :
						DELETE tt-epc.
					END.

					assign l-next = no.
			
					CREATE tt-epc.
					ASSIGN tt-epc.cod-event     = "NextPedido-drb-item":U
						   tt-epc.cod-parameter = "rowid-nota-fiscal":U
						   tt-epc.val-parameter = STRING(r-rowid-nota-fiscal).

					CREATE tt-epc.
					ASSIGN tt-epc.cod-event     = "NextPedido-drb-item":U
						   tt-epc.cod-parameter = "rowid-pedido-drb-item":U
						   tt-epc.val-parameter = STRING(ROWID(pedido-drb-item)).

					CREATE tt-epc.
					ASSIGN tt-epc.cod-event     = "NextPedido-drb-item":U
						   tt-epc.cod-parameter = "quant-usada":U
						   tt-epc.val-parameter = STRING(tt-item-estrut.quant-usada).
					
					{include/i-epc201.i "NextPedido-drb-item"}
	
					FIND FIRST tt-epc
						 WHERE tt-epc.cod-event     = "NextPedido-drb-item":U 
						 AND   tt-epc.cod-parameter = "next" NO-LOCK NO-ERROR.
					if avail tt-epc then
						assign l-next = LOGICAL(tt-epc.val-parameter).

					FIND FIRST tt-epc
						 WHERE tt-epc.cod-event     = "NextPedido-drb-item":U 
						 AND   tt-epc.cod-parameter = "quant-usada-nova" NO-LOCK NO-ERROR.
					if avail tt-epc then
						assign tt-item-estrut.quant-usada = DEC(tt-epc.val-parameter).
				END.

				if l-next then
					next.

                FOR EACH  pedido-drb-item
                    WHERE pedido-drb-item.it-codigo = tt-item-estrut.it-codigo
                          NO-LOCK:

                    IF emitente.natureza > 2  THEN /*internacional*/
                        FIND pedido-drb WHERE pedido-drb.cod-estabel         = pedido-drb-item.cod-estabel 
                                          AND pedido-drb.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb 
                                          AND pedido-drb.modalidade          = 1 
                                          AND pedido-drb.nr-ato-concessorio <> "" NO-LOCK NO-ERROR.
                    ELSE /*nacional*/
                        FIND pedido-drb WHERE pedido-drb.cod-estabel         = pedido-drb-item.cod-estabel 
                                          AND pedido-drb.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb 
                                          AND pedido-drb.modalidade          = 1 
                                          AND pedido-drb.nr-ato-concessorio <> "" 
                                          AND pedido-drb.log-draw-integrad NO-LOCK NO-ERROR.

                    IF AVAIL pedido-drb THEN DO:

                        /*N∆o permite que sejam gerados movto-ato.dat-movto para atos concess¢rios vencidos
                          A data de movimento de baixa do ato concessorio Ç criado com "today"*/
                        IF pedido-drb.data-validade-ato < TODAY THEN NEXT. 

                        FOR FIRST estabelec NO-LOCK
                            WHERE estabelec.cod-estabel = pedido-drb.cod-estabel: END.

                        IF NOT pedido-drb.log-draw-integrad THEN DO:

                            IF emitente.natureza > 2 
                               AND emitente.pais <> estabelec.pais THEN DO:
                                IF pedido-drb-item.qtd-sdo-item <= 0 THEN DO:                                
                                    NEXT.
                                END.
                            END.
                            ELSE DO:
                                IF pedido-drb-item.qtd-sdo-item-nac <= 0 THEN DO:
                                    NEXT.
                                END.
                            END.
                        END.

                        ELSE DO:
                            /*Se for drawback integrado tem que somar os saldos*/
                            IF (pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac ) <= 0 THEN NEXT.
                        END.
                        
                        IF c-pedido-ant = "" THEN 
                            ASSIGN  c-cod-est    = pedido-drb.cod-estabel
                                    c-pedido-ant = pedido-drb.nr-pedido-drb
                                    d-data-val   = pedido-drb.data-validade-ato.
                        
                        IF d-data-val > pedido-drb.data-validade-ato THEN
                            ASSIGN  c-cod-est    = pedido-drb.cod-estabel
                                    c-pedido-ant = pedido-drb.nr-pedido-drb
                                    d-data-val   = pedido-drb.data-validade-ato.

                        IF NOT CAN-FIND(FIRST tt-pedido-drb-aux
                                        WHERE tt-pedido-drb-aux.cod-estabel       = pedido-drb.cod-estabel        
                                          AND tt-pedido-drb-aux.nr-pedido-drb     = pedido-drb.nr-pedido-drb) THEN DO:
                            CREATE tt-pedido-drb-aux.
                            ASSIGN tt-pedido-drb-aux.cod-estabel       = pedido-drb.cod-estabel        
                                   tt-pedido-drb-aux.nr-pedido-drb     = pedido-drb.nr-pedido-drb      
                                   tt-pedido-drb-aux.data-validade-ato = pedido-drb.data-validade-ato. 
                        END.
                    END.
                END.    
            END.

            FOR EACH tt-pedido-drb-aux 
                /*BY tt-pedido-drb-aux.data-validade-ato*/:                                

                IF NOT CAN-FIND (FIRST tt-item-estrut WHERE tt-item-estrut.quant-usada > 0) THEN LEAVE.

                FIND pedido-drb WHERE pedido-drb.cod-estabel   = tt-pedido-drb-aux.cod-estabel AND
                                      pedido-drb.nr-pedido-drb = tt-pedido-drb-aux.nr-pedido-drb NO-LOCK NO-ERROR.
                
                IF AVAIL pedido-drb THEN DO:

                    FOR EACH tt-item-estrut-agrup NO-LOCK: //Agrupado 

                        IF tt-item-estrut-agrup.quant-usada <= 0 THEN NEXT.

                        ASSIGN de-qt-usada-total = tt-item-estrut-agrup.quant-usada
                               de-qt-aloc-total  = 0.
                
                        ASSIGN i-cont-seq = 0
                               l-controle-componentes = NO.
                
                        FOR EACH movto-ato WHERE movto-ato.cod-estabel   = pedido-drb.cod-estabel   AND
                                                 movto-ato.nr-pedido-drb = pedido-drb.nr-pedido-drb AND
                                                 movto-ato.it-codigo     = tt-item-estrut-agrup.it-codigo NO-LOCK:
                
                            IF movto-ato.sequencia > i-cont-seq THEN
                                ASSIGN i-cont-seq = movto-ato.sequencia.                
                        END.
                
                        FIND pedido-drb-item WHERE pedido-drb-item.cod-estabel   = pedido-drb.cod-estabel    AND
                                                   pedido-drb-item.nr-pedido-drb = pedido-drb.nr-pedido-drb  AND
                                                   pedido-drb-item.it-codigo     = tt-item-estrut-agrup.it-codigo  AND 
                                                   pedido-drb-item.idi-reg       = 1 EXCLUSIVE-LOCK NO-ERROR.
                
                        IF AVAIL pedido-drb-item THEN DO:

                            ASSIGN de-tot-quant-ent = 0
                                   de-tot-valor-ent = 0.
                
                            FOR EACH  movto-ato
                                WHERE movto-ato.cod-estabel   = pedido-drb-item.cod-estabel
                                AND   movto-ato.nr-pedido-drb = pedido-drb-item.nr-pedido-drb
                                AND   movto-ato.it-codigo     = pedido-drb-item.it-codigo
                                AND   movto-ato.idi-tip-movto = 1 /*Entrada*/ NO-LOCK:
                
                                IF pedido-drb-item.moeda <> 0 THEN
                                    RUN cdp/cd0812.p (input movto-ato.mo-codigo,
                                                      INPUT pedido-drb-item.moeda , 
                                                      INPUT movto-ato.val-movto-ato-me, 
                                                      INPUT movto-ato.dat-cotac, 
                                                      OUTPUT de-valor-conv).
                                ELSE
                                    ASSIGN de-valor-conv = movto-ato.val-movto-ato-me.
                
                                ASSIGN de-tot-quant-ent = de-tot-quant-ent + movto-ato.val-quant-movto-ato
                                       de-tot-valor-ent = de-tot-valor-ent + de-valor-conv.
                            END.
                
                            FIND FIRST estabelec WHERE estabelec.cod-estabel = pedido-drb-item.cod-estabel NO-LOCK NO-ERROR.
			    			
			    			/*Valida Saldo*/                        
                            IF pedido-drb.log-draw-integrad THEN DO:
                                /*Quando for Drawback Integrado ent∆o soma as quantidades (Internacional + Nacinal) para verificar se tem saldo*/                                
                                IF tt-item-estrut-agrup.quant-usada > (pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac) THEN DO:
                                    IF l-hab-contr-pai = NO THEN
			    						ASSIGN l-controle-cab-pai = YES
			    							   l-controle-cab-comps = YES
			    							   l-hab-contr-pai = YES.
			    					ELSE 
			    						ASSIGN l-controle-cab-pai = NO
			    							   l-controle-cab-comps = NO.
                
                                    ASSIGN l-controle-componentes = YES
    		    						   d-qtd-baixada = (pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac)
    		    						   d-qtd-indisp  = tt-item-estrut-agrup.quant-usada - d-qtd-baixada
    		    						   tt-item-estrut-agrup.quant-usada = d-qtd-baixada.
                                END.
                            END.

                            ELSE DO:
                                /*Se n∆o Ç Drawback integrado quantinua validando os saldos individualmente*/
                                IF tt-item-estrut-agrup.quant-usada > pedido-drb-item.qtd-sdo-item THEN DO:
                                    IF l-hab-contr-pai = NO THEN
                                        ASSIGN l-controle-cab-pai = YES
                                               l-controle-cab-comps = YES
                                               l-hab-contr-pai = YES.
                                    ELSE 
                                        ASSIGN l-controle-cab-pai = NO
                                               l-controle-cab-comps = NO.
                                                                              
                                    ASSIGN l-controle-componentes     = YES
                                           d-qtd-baixada              = pedido-drb-item.qtd-sdo-item
                                           d-qtd-indisp               = tt-item-estrut.quant-usada - d-qtd-baixada
                                           tt-item-estrut.quant-usada = d-qtd-baixada.
                                END.
                            END.
			    			
                            IF l-controle-cab-pai OR l-controle-cab-comps OR l-controle-componentes then do:
                                assign c-cod-registro = if i-programa = 4001 then string(nota-fiscal.cdd-embarq) else string(it-nota-fisc.nr-pedcli).
                                for first tt-itens-sem-saldo
                                    where tt-itens-sem-saldo.cod-registro = c-cod-registro
                                      and tt-itens-sem-saldo.item-pai     = it-nota-fisc.it-codigo
                                      and tt-itens-sem-saldo.item-filho   = tt-item-estrut.it-codigo 
                                      and tt-itens-sem-saldo.nr-sequencia = it-nota-fisc.nr-seq-fat no-lock:
                                end.
                                if not avail tt-itens-sem-saldo then do:
                                    create tt-itens-sem-saldo.
                                    assign tt-itens-sem-saldo.cod-registro = c-cod-registro
                                           tt-itens-sem-saldo.nome-abrev   = emitente.nome-abrev
                                           tt-itens-sem-saldo.item-pai     = it-nota-fisc.it-codigo
                                           tt-itens-sem-saldo.item-filho   = tt-item-estrut.it-codigo
                                           tt-itens-sem-saldo.nr-sequencia = it-nota-fisc.nr-seq-fat.
                                end.
                                assign tt-itens-sem-saldo.qtd-faturada = it-nota-fisc.qt-faturada[1]
                                       tt-itens-sem-saldo.qtd-baixada  = tt-itens-sem-saldo.qtd-baixada + d-qtd-baixada
                                       tt-itens-sem-saldo.qtd-indisp   = tt-itens-sem-saldo.qtd-indisp  + d-qtd-indisp.


                            end.
                            
                            ASSIGN dcTotal = tt-item-estrut-agrup.quant-usada.

                            IF NOT VALID-HANDLE(h-bocx332) THEN
                                RUN cxbo/bocx332.p PERSISTENT SET h-bocx332.
                
                            /*Indica para a bo da movto-ato que a criaá∆o Ç autom†tica*/
                            RUN pi-seta-cria-automatico in h-bocx332(INPUT TRUE).

                            IF pedido-drb.log-draw-integrad THEN DO:
                                /*Quando for Drawback Integrado tem que verificar a prioridade de baixa.
                                    No Drawback Integrado Ç considerado a soma dos Saldos Internacionais e Nacionais*/
                
                                /*Agora Independente do tipo de natureza tem que somar as duas quantidades para compor o saldo*/
                                IF (pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac ) <= 0 THEN NEXT.
                
                                /*Verifica se ainda tem quantidade para baixar*/
                                DO WHILE tt-item-estrut-agrup.quant-usada > 0:

                                    CREATE tt-movto-ato.
                                    /*Se a Prioridade for para baixar primeiro o saldo nacional*/
                                    IF SUBSTRING(pedido-drb.char-1,1,1) = "3" THEN DO: /*Prioridade de Baixa Ç pelo mercado NACIONAL*/
                                        /*NACIONAL*/
                                        /*Verifica se ainda existe saldo nacional para baixar*/
                                        IF pedido-drb-item.qtd-sdo-item-nac > 0 THEN DO:
                                            ASSIGN de-qtde-tot-movto    = 0
                                                   de-valor-tot-movto   = 0.

                                            /*Busca o valor total e a quantidade total do Ato para fazer um regra de 3*/
                                            RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                        														INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                        														INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                        														INPUT  2, /*i-tip-item-movto  */
                        														OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                        														OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/

                                            /*Se ainda tem saldo nacional para baixar, verifica se a quantidade para baixa Ç maior que o saldo*/
                                            IF tt-item-estrut-agrup.quant-usada - pedido-drb-item.qtd-sdo-item-nac >= 0 THEN DO:                                        
                                                /*Se a quantidade para baixar for maior que a que o saldo nacional, ent∆o diminui o saldo da quantidade a baixar,
                                                    zera o saldo nacional e o valor*/
                                                ASSIGN tt-item-estrut-agrup.quant-usada     = tt-item-estrut-agrup.quant-usada - pedido-drb-item.qtd-sdo-item-nac
                                                       tt-movto-ato.val-quant-movto-ato     = pedido-drb-item.qtd-sdo-item-nac
                                                       tt-movto-ato.val-quant-movto-ato-re  = it-nota-fisc.qt-faturada[1] * (((pedido-drb-item.qtd-sdo-item-nac * 100) / dcTotal) / 100)
                                                       d-novo-saldo-proporcional            = (de-valor-tot-movto * pedido-drb-item.qtd-sdo-item-nac) / de-qtde-tot-movto
                                                       pedido-drb-item.val-sdo-item-nac     = 0
                                                       pedido-drb-item.qtd-sdo-item-nac     = 0
                                                       tt-movto-ato.idi-tip-item-movto      = 2.
                                            END.
                                            ELSE DO:
                                                /*Se a quantidade a baixar for menor que o saldo nacional, ent∆o diminui a quantidade a baixar do saldo
                                                    e faz a regra de 3 para baixar o valor.*/
                                                ASSIGN pedido-drb-item.qtd-sdo-item-nac = pedido-drb-item.qtd-sdo-item-nac - tt-item-estrut-agrup.quant-usada
                                                       tt-movto-ato.val-quant-movto-ato    = tt-item-estrut-agrup.quant-usada
                                                       tt-movto-ato.val-quant-movto-ato-re = it-nota-fisc.qt-faturada[1] * (((tt-item-estrut.quant-usada * 100) / dcTotal) / 100)
                                                       d-novo-saldo-proporcional        = (de-valor-tot-movto * tt-item-estrut-agrup.quant-usada) / de-qtde-tot-movto
                                                       pedido-drb-item.val-sdo-item-nac = pedido-drb-item.val-sdo-item-nac - IF d-novo-saldo-proporcional = ? THEN 0 ELSE d-novo-saldo-proporcional
                                                       tt-item-estrut-agrup.quant-usada       = 0
                                                       tt-movto-ato.idi-tip-item-movto  = 2.
                                            END.
                                        END.
                                        ELSE DO:
                                            /*INTERNACIONAL*/
                                            ASSIGN de-qtde-tot-movto    = 0
                                                   de-valor-tot-movto   = 0.
                                            RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                        														INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                        														INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                        														INPUT  1, /*i-tip-item-movto  */
                        														OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                        														OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
                
                                            /*Se a prioridade for nacional e j† baixou todo o saldo nacional, baixa o que resta do saldo internacional*/
                                            ASSIGN tt-movto-ato.val-quant-movto-ato = tt-item-estrut-agrup.quant-usada
                                                   pedido-drb-item.qtd-sdo-item     = pedido-drb-item.qtd-sdo-item - tt-item-estrut-agrup.quant-usada                                           
                                                   tt-movto-ato.val-quant-movto-ato-re = it-nota-fisc.qt-faturada[1] * (((tt-item-estrut-agrup.quant-usada * 100) / dcTotal) / 100)
                                                   d-novo-saldo-proporcional        = (de-valor-tot-movto * tt-item-estrut-agrup.quant-usada) / de-qtde-tot-movto
                                                   pedido-drb-item.val-sdo-item     = pedido-drb-item.val-sdo-item - IF d-novo-saldo-proporcional = ? THEN 0 ELSE d-novo-saldo-proporcional
                                                   tt-item-estrut-agrup.quant-usada       = 0                                           
                                                   tt-movto-ato.idi-tip-item-movto  = 1.
                                        END.
                                    END.


                                    ELSE DO: /*Prioridade de Baixa Ç pelo mercado INTERNACIONAL OU AMBOS*/

                                        IF pedido-drb-item.qtd-sdo-item > 0 THEN DO:
                                            /*Quando a prioridade for por baixa Internacional ou Ambos, segue a mesma regra da baixa com prioridade nacional,
                                                mas primeiro baixa do Saldo Internacional, e se sobrar quantidade para baixar ent∆o baixa do saldo nacional.
                                            */
                                            /*INTERNACIONAL*/

                                            ASSIGN de-qtde-tot-movto    = 0
                                                   de-valor-tot-movto   = 0.

                                            RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                        														INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                        														INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                        														INPUT  1, /*i-tip-item-movto  */
                        														OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                        														OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/               
                
                                            IF tt-item-estrut-agrup.quant-usada - pedido-drb-item.qtd-sdo-item >= 0 THEN DO:
                                                                                                
                                                ASSIGN tt-item-estrut-agrup.quant-usada     = tt-item-estrut-agrup.quant-usada - pedido-drb-item.qtd-sdo-item
                                                       tt-movto-ato.val-quant-movto-ato     = pedido-drb-item.qtd-sdo-item
                                                       tt-movto-ato.val-quant-movto-ato-re  = it-nota-fisc.qt-faturada[1] * (((pedido-drb-item.qtd-sdo-item * 100) / dcTotal) / 100)
                                                       d-novo-saldo-proporcional            = (de-valor-tot-movto * pedido-drb-item.qtd-sdo-item) / de-qtde-tot-movto
                                                       pedido-drb-item.val-sdo-item         = 0
                                                       pedido-drb-item.qtd-sdo-item         = 0
                                                       tt-movto-ato.idi-tip-item-movto      = 1.

                                            END.
                                            ELSE DO:

                                                ASSIGN pedido-drb-item.qtd-sdo-item         = pedido-drb-item.qtd-sdo-item - tt-item-estrut-agrup.quant-usada
                                                       tt-movto-ato.val-quant-movto-ato     = tt-item-estrut-agrup.quant-usada
                                                       tt-movto-ato.val-quant-movto-ato-re  = it-nota-fisc.qt-faturada[1] * (((tt-item-estrut-agrup.quant-usada * 100) / dcTotal) / 100)
                                                       d-novo-saldo-proporcional            = (de-valor-tot-movto * tt-item-estrut-agrup.quant-usada) / de-qtde-tot-movto
                                                       pedido-drb-item.val-sdo-item         = pedido-drb-item.val-sdo-item - IF d-novo-saldo-proporcional = ? THEN 0 ELSE d-novo-saldo-proporcional
                                                       tt-item-estrut-agrup.quant-usada     = 0
                                                       tt-movto-ato.idi-tip-item-movto      = 1.

                                            END.                                           
                                        END.
                                        ELSE DO:

                                            /*NACIONAL*/
                                             ASSIGN de-qtde-tot-movto    = 0
                                                    de-valor-tot-movto   = 0.

                                             RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                        														INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                        														INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                        														INPUT  2, /*i-tip-item-movto  */
                        														OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                        														OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
                
                                            ASSIGN tt-movto-ato.val-quant-movto-ato = tt-item-estrut-agrup.quant-usada
                                                   pedido-drb-item.qtd-sdo-item-nac = pedido-drb-item.qtd-sdo-item-nac - tt-item-estrut-agrup.quant-usada                                           
                                                   tt-movto-ato.val-quant-movto-ato-re = it-nota-fisc.qt-faturada[1] * (((tt-item-estrut-agrup.quant-usada * 100) / dcTotal) / 100)
                                                   /*d-novo-saldo-proporcional        = ((it-nota-fisc.vl-preuni * dcTotal) * tt-item-estrut.quant-usada) / dcTotal*/
                                                   d-novo-saldo-proporcional        = (de-valor-tot-movto * tt-item-estrut-agrup.quant-usada) / de-qtde-tot-movto
                                                   pedido-drb-item.val-sdo-item-nac = pedido-drb-item.val-sdo-item-nac - IF d-novo-saldo-proporcional = ? THEN 0 ELSE d-novo-saldo-proporcional
                                                   tt-item-estrut-agrup.quant-usada       = 0                                           
                                                   tt-movto-ato.idi-tip-item-movto  = 2.
                                        END.


                                    END.
                
                                    ASSIGN i-cont-seq                          = i-cont-seq + 1
                                           tt-movto-ato.dat-movto              = today
                                           tt-movto-ato.cod-estabel            = pedido-drb.cod-estabel
                                           tt-movto-ato.cod-estab-docto        = it-nota-fisc.cod-estabel
                                           tt-movto-ato.nro-docto              = it-nota-fisc.nr-nota-fis
                                           tt-movto-ato.serie                  = it-nota-fisc.serie
                                           tt-movto-ato.nat-operacao           = it-nota-fisc.nat-operacao
                                           tt-movto-ato.cod-emitente           = emitente.cod-emitente
                                           tt-movto-ato.num-re                 = c-nr-re
                                           tt-movto-ato.dat-nf                 = d-data-emis-nf
                                           tt-movto-ato.cdd-ncm                = it-nota-fisc.class-fiscal
                                           tt-movto-ato.val-peso               = it-nota-fisc.peso-liq-fat
                                           tt-movto-ato.un                     = item.un
                                           tt-movto-ato.mo-codigo              = ped-venda.mo-codigo  
                                           tt-movto-ato.nr-pedido-drb          = pedido-drb.nr-pedido-drb  
                                           tt-movto-ato.it-codigo              = tt-item-estrut-agrup.it-codigo
                                           tt-movto-ato.it-codigo-re           = it-nota-fisc.it-codigo 
                                           tt-movto-ato.seq-docto              = it-nota-fisc.nr-seq-fat                                                                              
                                           tt-movto-ato.val-movto-ato-me       = IF d-novo-saldo-proporcional = ? THEN 0 ELSE d-novo-saldo-proporcional
                                           tt-movto-ato.val-movto-ato-orig     = (it-nota-fisc.vl-preuni * tt-movto-ato.val-quant-movto-ato-re)
                                           tt-movto-ato.val-movto-ato-re-me    = (it-nota-fisc.vl-preuni * tt-movto-ato.val-quant-movto-ato-re) / nota-fiscal.vl-taxa-exp
                                           /*tt-movto-ato.val-movto-ato-me       = (it-nota-fisc.vl-preuni * tt-movto-ato.val-quant-movto-ato-re) / nota-fiscal.vl-taxa-exp*/
                                           tt-movto-ato.dat-cotac              = d-data-emis-nf
                                           tt-movto-ato.cotacao                = nota-fiscal.vl-taxa-exp
                                           tt-movto-ato.idi-tip-movto          = 2 /*Baixa*/
                                           tt-movto-ato.sequencia              = i-cont-seq.  

                                    ASSIGN de-qt-aloc-total = de-qt-aloc-total + tt-movto-ato.val-quant-movto-ato.

                                    IF AVAIL proc-siscomex THEN
                                        ASSIGN tt-movto-ato.dat-reg-export = proc-siscomex.dt-re.               

                                    RUN pi-efetiva-criacao-movto-ato.                                    
                                END.
                            END.
                            ELSE DO:
                                /* Essa validaá‰es s∆o apenas para quando n∆o for o Drawback integrado*/
                
                                IF pedido-drb-item.qtd-sdo-item <= 0 THEN NEXT.
                
                                FIND FIRST estabelec WHERE estabelec.cod-estabel = pedido-drb-item.cod-estabel NO-LOCK NO-ERROR.
                                
    		    				IF NOT VALID-HANDLE(h-bocx332) THEN
    		    				    RUN cxbo/bocx332.p PERSISTENT SET h-bocx332.
                                
                                ASSIGN i-tip-item-movto = 1. /* internacional */
                
    		    				RUN calculo-saldo-itens IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
    		    													 INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
    		    													 INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
    		    													 INPUT  i-tip-item-movto, /*i-tip-item-movto  */
    		    													 OUTPUT d-qtd-saldo-aux, /*de-quant-saldo    */
    		    													 OUTPUT d-val-saldo-aux, /*de-valor-saldo    */
    		    													 OUTPUT d-tot-qtd-ent-aux, /*de-tot-quant-ent  */
    		    													 OUTPUT d-tot-qtd-sai-aux). /*de-tot-quant-baixa*/
                
                                RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
        	    													INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
        	    													INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
        	    													INPUT  i-tip-item-movto, /*i-tip-item-movto  */
        	    													OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
        	    													OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
    		    				
                                ASSIGN d-novo-saldo-proporcional = 0.
                
                                IF pedido-drb-item.val-sdo-item = ? THEN
                                    ASSIGN pedido-drb-item.val-sdo-item = 0.
                
                                ASSIGN de-valor-baixa  = (tt-item-estrut-agrup.quant-usada * de-tot-valor-ent) / de-tot-quant-ent
                                       d-novo-saldo-proporcional = (de-valor-tot-movto * tt-item-estrut-agrup.quant-usada) / de-qtde-tot-movto
                                       pedido-drb-item.qtd-sdo-item = pedido-drb-item.qtd-sdo-item - tt-item-estrut-agrup.quant-usada
                                       pedido-drb-item.val-sdo-item = pedido-drb-item.val-sdo-item - IF d-novo-saldo-proporcional = ? THEN 0 ELSE d-novo-saldo-proporcional.
                
                                IF d-novo-saldo-proporcional = ? THEN d-novo-saldo-proporcional = 0.    					 
                
                                ASSIGN i-moeda-aux = pedido-drb-item.moeda.
                
                                IF i-moeda-aux <> ped-venda.mo-codigo THEN DO:	
                                   RUN cdp/cd0812.p (input pedido-drb-item.moeda,
                                                     INPUT i-moeda-aux, 
                                                     INPUT d-novo-saldo-proporcional, 
                                                     INPUT d-data-emis-nf, 
                                                     OUTPUT d-novo-saldo-proporcional-conv).												                                                
                                END.
                                ELSE
                                    ASSIGN d-novo-saldo-proporcional-conv = d-novo-saldo-proporcional.
                               
                
                                CREATE tt-movto-ato.
                                ASSIGN tt-movto-ato.dat-movto              = today
                                       tt-movto-ato.cod-estabel            = pedido-drb.cod-estabel
                                       tt-movto-ato.cod-estab-docto        = it-nota-fisc.cod-estabel
                                       tt-movto-ato.nro-docto              = it-nota-fisc.nr-nota-fis
                                       tt-movto-ato.serie                  = it-nota-fisc.serie
                                       tt-movto-ato.nat-operacao           = it-nota-fisc.nat-operacao
                                       tt-movto-ato.cod-emitente           = emitente.cod-emitente
                                       tt-movto-ato.num-re                 = c-nr-re
                                       tt-movto-ato.dat-nf                 = d-data-emis-nf
                                       tt-movto-ato.cdd-ncm                = it-nota-fisc.class-fiscal
                                       tt-movto-ato.val-peso               = it-nota-fisc.peso-liq-fat
                                       tt-movto-ato.un                     = item.un
                                       tt-movto-ato.mo-codigo              = ped-venda.mo-codigo  
                                       tt-movto-ato.nr-pedido-drb          = pedido-drb.nr-pedido-drb  
                                       tt-movto-ato.it-codigo              = tt-item-estrut-agrup.it-codigo
                                       tt-movto-ato.it-codigo-re           = it-nota-fisc.it-codigo 
                                       tt-movto-ato.seq-docto              = it-nota-fisc.nr-seq-fat
                                       tt-movto-ato.val-quant-movto-ato    = tt-item-estrut-agrup.quant-usada
                                       tt-movto-ato.val-quant-movto-ato-re = it-nota-fisc.qt-faturada[1]
                                       tt-movto-ato.val-movto-ato-me       = d-novo-saldo-proporcional-conv
                                       tt-movto-ato.val-movto-ato-orig     = (it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1])
                                       tt-movto-ato.val-movto-ato-re-me    = (it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]) / nota-fiscal.vl-taxa-exp
                                       tt-movto-ato.dat-cotac              = d-data-emis-nf
                                       tt-movto-ato.cotacao                = nota-fiscal.vl-taxa-exp
                                       tt-movto-ato.idi-tip-movto          = 2 /*Baixa*/
                                       tt-movto-ato.sequencia              = i-cont-seq + 1
                                       tt-movto-ato.idi-tip-item-movto     = 1.   

                                ASSIGN de-qt-aloc-total = de-qt-aloc-total + tt-movto-ato.val-quant-movto-ato.

                                IF AVAIL proc-siscomex THEN
                                    ASSIGN tt-movto-ato.dat-reg-export = proc-siscomex.dt-re.

                                RUN pi-efetiva-criacao-movto-ato.
                            END.

                            IF VALID-HANDLE(h-bocx332) THEN DO:
                                DELETE PROCEDURE h-bocx332.
                                ASSIGN h-bocx332 = ?.
                            END.

                            ASSIGN tt-item-estrut-agrup.quant-usada = de-qt-usada-total - de-qt-aloc-total.
                        END.
                    END.
                END.
            END.
        END.
    END.

    if l-ult-seq-nota
    and can-find(first tt-itens-sem-saldo) then do:
        run exp/ex4333rp.p (input table tt-itens-sem-saldo,
                            input i-programa,
                            input rowid(nota-fiscal)).
        empty temp-table tt-itens-sem-saldo.
    end.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 define input parameter i-abertura as integer no-undo.
 
    case i-abertura:
        when 1 then 
           run openQueryStatic ("Main").
        when 2 then 
           run openQueryStatic ("CodEstabel").
        end. /*end case*/
        
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb NO-LOCK by Pedido-drb.nr-ato-concessorio.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiVerificaItem DBOProgram 
PROCEDURE PiVerificaItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER c-cod-refer   LIKE wt-it-docto.cod-refer     NO-UNDO.
    DEFINE INPUT  PARAMETER de-quantidade LIKE wt-it-docto.quantidade[1] NO-UNDO.
    DEFINE INPUT  PARAMETER c-it-codigo   LIKE wt-it-docto.it-codigo     NO-UNDO.
    DEFINE INPUT  PARAMETER c-nome-abrev  LIKE wt-docto.nome-abrev       NO-UNDO.
    DEFINE INPUT  PARAMETER c-cod-estab   LIKE wt-docto.cod-estabel      NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-cod-erro   AS   INTEGER                   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pl-proc-ok-aux AS LOGICAL              NO-UNDO.

    DEFINE VARIABLE c-cod-est        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-pedido-ant     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE d-data-val       AS DATE       NO-UNDO.
    DEFINE VARIABLE l-existe         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-existe-pai     AS LOGICAL    NO-UNDO.
	DEFINE VARIABLE l-saldo-insuficiente AS LOGICAL    NO-UNDO.

    DEFINE VARIABLE de-saldo-drb AS DECIMAL     NO-UNDO.
	
    ASSIGN l-existe = YES.

    IF  NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    IF param-global.modulo-en THEN DO:
        
        IF NOT VALID-HANDLE(h-boin111a) OR
            h-boin111a:TYPE <> "PROCEDURE":U OR
            h-boin111a:FILE-NAME <> "inbo/boin111a.p":U THEN DO:

            RUN inbo/boin111a.p PERSISTENT SET h-boin111a.
        END.
        
        RUN setConstraint2 IN h-boin111a (INPUT STRING(c-cod-refer),
                                          INPUT STRING(de-quantidade),
                                          INPUT "19",
                                          INPUT STRING(TODAY),
                                          INPUT ">>>>>,>>9.9999", 
                                          INPUT STRING(c-it-codigo)).
        
        RUN montaEstrutura IN h-boin111a.
        RUN openQuery IN h-boin111a (INPUT 1).
        RUN getTTEstrutura IN h-boin111a (OUTPUT TABLE tt-item-estrut).
		
		IF VALID-HANDLE(h-boin111a) THEN DO:
			DELETE PROCEDURE h-boin111a.
			ASSIGN h-boin111a = ?.
		END.
        
        ASSIGN c-cod-est    = ""
               c-pedido-ant = ""
               d-data-val   = ?.

        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = c-cod-estab: END.

        /*Incluso para a validaá∆o com Drawback Integrado*/
        FOR FIRST emitente FIELDS(cod-emitente natureza nome-abrev) 
            WHERE emitente.nome-abrev = c-nome-abrev NO-LOCK: END.

        EMPTY TEMP-TABLE tt-pedido-drb-aux.

        FOR EACH tt-item-estrut:

            ASSIGN l-existe-pai = YES.

            bloco:

            FOR EACH bfPedido-drb-item
               WHERE bfPedido-drb-item.it-codigo = tt-item-estrut.it-codigo NO-LOCK:

                IF (bfPedido-drb-item.qtd-sdo-item-nac + bfPedido-drb-item.qtd-sdo-item) < tt-item-estrut.quant-usada THEN
                    NEXT.                                                  
                
                ASSIGN l-existe = CAN-FIND (FIRST bfpedido-drb 
                                            WHERE bfpedido-drb.cod-estabel         = bfPedido-drb-item.cod-estabel 
                                              AND bfpedido-drb.nr-pedido-drb       = bfPedido-drb-item.nr-pedido-drb 
                                              AND bfpedido-drb.modalidade          = 1  
                                              AND bfpedido-drb.nr-ato-concessorio <> "" 
                                              AND bfpedido-drb.data-validade-ato >= TODAY).

                IF  l-existe THEN DO:
                    ASSIGN l-existe-pai = CAN-FIND(FIRST pedido-drb-item 
                                                   WHERE pedido-drb-item.cod-estabel   = bfPedido-drb-item.cod-estabel     
                                                   AND   pedido-drb-item.nr-pedido-drb = bfPedido-drb-item.nr-pedido-drb
                                                   AND   pedido-drb-item.it-codigo     = c-it-codigo /**busca se existe um pai cadastrado na aba ITENS SA÷DA do dk2000**/
                                                   AND   pedido-drb-item.idi-reg       = 2).
                    IF l-existe-pai THEN
                        LEAVE bloco.                
                END.
            END.

            IF NOT l-existe THEN do:
                assign pl-proc-ok-aux = NO.
				if l-executado-flex THEN DO:

                    RUN utp/ut-msgs.p (INPUT 'codType',
                                       INPUT 52557,
                                       INPUT '').

                    run _insertErrorManual in this-procedure (input 52557,               /* pErrorNumber      */
                                                              input "EMS",               /* pErrorType        */
                                                              input RETURN-VALUE,        /* pErrorSubType     */
                                                              input "",                  /* pErrorDescription */
                                                              input "",                  /* pErrorHelp        */
                                                              input "").                 /* pErrorParameters  */
					ASSIGN pi-cod-erro    = 52557.
                END.
			    ELSE DO:
                    RUN utp/ut-msgs.p (INPUT 'codType',
                                       INPUT 33305,
                                       INPUT '').

                    run _insertErrorManual in this-procedure (input 33305,               /* pErrorNumber      */
                                                              input "EMS",               /* pErrorType        */
                                                              input RETURN-VALUE,        /* pErrorSubType     */
                                                              input "",                  /* pErrorDescription */
                                                              input "",                  /* pErrorHelp        */
                                                              input "").                 /* pErrorParameters  */
                    ASSIGN pi-cod-erro    = 33305.
                    return.

                END.					
			END.
            ELSE
                IF NOT l-existe-pai THEN DO:
                    ASSIGN pl-proc-ok-aux = NO
                           pi-cod-erro    = 52555.

                    RUN utp/ut-msgs.p (INPUT 'codType',
                                       INPUT 52555,
                                       INPUT '').

                    run _insertErrorManual in this-procedure (input 52555,               /* pErrorNumber      */
                                                              input "EMS",               /* pErrorType        */
                                                              input RETURN-VALUE,        /* pErrorSubType     */
                                                              input "",                  /* pErrorDescription */
                                                              input "",                  /* pErrorHelp        */
                                                              input "").                 /* pErrorParameters  */
                    return.

                END.

            FOR EACH  pedido-drb-item
                WHERE pedido-drb-item.it-codigo = tt-item-estrut.it-codigo 
                //AND   ( pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac) > 0
                AND   pedido-drb-item.idi-reg = 1 NO-LOCK:

                FIND pedido-drb WHERE pedido-drb.cod-estabel         = pedido-drb-item.cod-estabel   AND
                                      pedido-drb.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb AND
                                      pedido-drb.modalidade          = 1  AND 
                                      pedido-drb.nr-ato-concessorio <> "" AND 
                                      pedido-drb.data-validade-ato  >= TODAY NO-LOCK NO-ERROR.

                IF AVAIL pedido-drb THEN DO:                    

                    IF c-pedido-ant = "" THEN 
                        ASSIGN  c-cod-est    = pedido-drb.cod-estabel
                                c-pedido-ant = pedido-drb.nr-pedido-drb
                                d-data-val   = pedido-drb.data-validade-ato.
                    
                    IF d-data-val > pedido-drb.data-validade-ato THEN
                        ASSIGN  c-cod-est    = pedido-drb.cod-estabel
                                c-pedido-ant = pedido-drb.nr-pedido-drb
                                d-data-val   = pedido-drb.data-validade-ato.

                    IF NOT CAN-FIND(FIRST tt-pedido-drb-aux
                                    WHERE tt-pedido-drb-aux.cod-estabel       = pedido-drb.cod-estabel        
                                      AND tt-pedido-drb-aux.nr-pedido-drb     = pedido-drb.nr-pedido-drb) THEN DO:

                        CREATE tt-pedido-drb-aux.
                        ASSIGN tt-pedido-drb-aux.cod-estabel       = pedido-drb.cod-estabel        
                               tt-pedido-drb-aux.nr-pedido-drb     = pedido-drb.nr-pedido-drb      
                               tt-pedido-drb-aux.data-validade-ato = pedido-drb.data-validade-ato. 
                    END.
                END.
            END.
        END.

        ASSIGN l-saldo-insuficiente = NO.

        FOR EACH tt-item-estrut NO-LOCK:

            IF l-saldo-insuficiente = YES THEN
                 NEXT.

            ASSIGN de-saldo-drb = 0.

            FOR EACH tt-pedido-drb-aux NO-LOCK,
                FIRST pedido-drb NO-LOCK
                WHERE pedido-drb.cod-estabel        = tt-pedido-drb-aux.cod-estabel
                  AND pedido-drb.nr-pedido-drb      = tt-pedido-drb-aux.nr-pedido-drb:
    
                FIND pedido-drb-item WHERE pedido-drb-item.cod-estabel   = pedido-drb.cod-estabel   AND
                                           pedido-drb-item.nr-pedido-drb = pedido-drb.nr-pedido-drb AND
                                           pedido-drb-item.it-codigo     = tt-item-estrut.it-codigo AND 
                                           pedido-drb-item.idi-reg       = 1 EXCLUSIVE-LOCK NO-ERROR.

                IF AVAIL pedido-drb-item THEN DO:
                    ASSIGN de-saldo-drb = de-saldo-drb + pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac.

                    IF tt-item-estrut.quant-usada > de-saldo-drb THEN                                                                     
                         ASSIGN l-saldo-insuficiente = yes.
                     ELSE 
                         ASSIGN l-saldo-insuficiente = NO.
                END.
            END.
        END.

        IF l-saldo-insuficiente THEN do:
            ASSIGN pl-proc-ok-aux = NO.
            IF l-executado-flex THEN DO:

                ASSIGN pi-cod-erro = 52558.

                RUN utp/ut-msgs.p (INPUT 'codType',
                                   INPUT 52558,
                                   INPUT '').

                RUN _insertErrorManual in this-procedure (input 52558,               /* pErrorNumber      */
                                                          input "EMS",               /* pErrorType        */
                                                          input RETURN-VALUE,        /* pErrorSubType     */
                                                          input "",                  /* pErrorDescription */
                                                          input "",                  /* pErrorHelp        */
                                                          input "").                 /* pErrorParameters  */
            END.            				
            ELSE DO:
                ASSIGN pi-cod-erro = 57641.

                RUN utp/ut-msgs.p (INPUT 'codType',
                                   INPUT 57641,
                                   INPUT '').

                RUN _insertErrorManual in this-procedure (input 57641,               /* pErrorNumber      */
                                                          input "EMS",               /* pErrorType        */
                                                          input return-value,        /* pErrorSubType     */
                                                          input "",                  /* pErrorDescription */
                                                          input "",                  /* pErrorHelp        */
                                                          input "").                 /* pErrorParameters  */
            END.                           
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaSaldo DBOProgram 
PROCEDURE piVerificaSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-seq-wt-docto LIKE  wt-docto.seq-wt-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-cod-erro    AS    INTEGER               NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-proc-ok-aux AS    LOGICAL               NO-UNDO.

    
    IF  NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR FIRST wt-docto
        WHERE wt-docto.seq-wt-docto = p-seq-wt-docto NO-LOCK:
    END.
    
    ASSIGN pl-proc-ok-aux = YES.
    
    IF AVAIL wt-docto THEN DO:
        bloco:
        do trans on error undo bloco, leave bloco:
            FOR EACH wt-it-docto
               WHERE wt-it-docto.seq-wt-docto = p-seq-wt-docto NO-LOCK:
                
                if wt-it-docto.ind-componen > 2 then next. //somente considera item normal e item pai

                /* Somente devera entrar na piVerificaItem quando o movimento de baixa acontecer por FIFO */
                IF NOT CAN-FIND(FIRST tt-ex4330-retorno WHERE tt-ex4330-retorno.it-codigo-pai  = wt-it-docto.it-codigo   AND
                                                              tt-ex4330-retorno.nr-seq-ped-pai = wt-it-docto.nr-seq-ped) THEN DO:
    
                    RUN piVerificaItem IN THIS-PROCEDURE (INPUT wt-it-docto.cod-refer,
                                                          INPUT STRING(wt-it-docto.quantidade[1]),
                                                          INPUT STRING(wt-it-docto.it-codigo),
                                                          INPUT wt-docto.nome-abrev,
                                                          INPUT wt-docto.cod-estabel,
                                                          OUTPUT pi-cod-erro,
                                                          INPUT-OUTPUT pl-proc-ok-aux).
                    
                    if pi-cod-erro = 57641 then do:
                        RUN piRetornaItensSemSaldoDrawback (INPUT ?,
                                                            INPUT ?,
                                                            input wt-docto.seq-wt-docto,
                                                            input wt-it-docto.seq-wt-it-docto).
                        
                    end.
                END.
            END.
            if can-find(first tt-itens-sem-saldo) then do:
                run exp/ex4333rp.p (input table tt-itens-sem-saldo,
                                    input i-programa,
                                    input ?).
                undo bloco.
            end.
        end.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaSaldoEmbarque DBOProgram 
PROCEDURE piVerificaSaldoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER i-nr-resumo    AS INTEGER    NO-UNDO.
    DEFINE INPUT  PARAMETER de-cdd-embarq  AS DECIMAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-cod-erro    AS INTEGER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-proc-ok-aux AS LOGICAL    NO-UNDO.

    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    ASSIGN pl-proc-ok-aux = YES.

    empty temp-table tt-itens-sem-saldo.

    bloco:
    do trans on error undo bloco, leave bloco:
        FOR EACH it-pre-fat
           WHERE it-pre-fat.cdd-embarq   = de-cdd-embarq
             AND it-pre-fat.nr-resumo    = i-nr-resumo NO-LOCK,
            FIRST pre-fatur OF it-pre-fat NO-LOCK:
    
            FOR FIRST natur-oper FIELDS( nat-operacao log-natur-operac-draw )
                WHERE natur-oper.nat-operacao = it-pre-fat.nat-operacao NO-LOCK:
            END.
    
            FOR FIRST emitente FIELDS(natureza cod-emitente)
                WHERE emitente.nome-abrev = pre-fatur.nome-abrev NO-LOCK:
            END.
    
            IF  (AVAIL natur-oper 
                 AND natur-oper.log-natur-operac-draw) 
            AND param-global.log-modul-draw THEN DO:
                
                RUN piVerificaItem IN THIS-PROCEDURE (INPUT it-pre-fat.cod-refer,
                                                      INPUT STRING(it-pre-fat.qt-alocada),
                                                      INPUT STRING(it-pre-fat.it-codigo),
                                                      INPUT pre-fatur.nome-abrev,
                                                      INPUT pre-fatur.cod-estabel,
                                                      OUTPUT pi-cod-erro,
                                                      INPUT-OUTPUT pl-proc-ok-aux).
    
                RUN piRetornaItensSemSaldoDrawback (INPUT ROWID(pre-fatur),
                                                    INPUT ROWID(it-pre-fat),
                                                    input 0,
                                                    input 0).
            end.
        end.
        if can-find(first tt-itens-sem-saldo) then do:
            run exp/ex4333rp.p (input table tt-itens-sem-saldo,
                                input i-programa,
                                input ?).
        end.
        undo bloco.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-movto-ato-tipo-mercado DBOProgram 
PROCEDURE pi-gera-movto-ato-tipo-mercado:

    DEFINE INPUT PARAM p-idi-tip-movto AS INT NO-UNDO.

    ASSIGN de-tot-quant-ent = 0
           de-tot-valor-ent = 0.

    FOR EACH  movto-ato
        WHERE movto-ato.cod-estabel        = pedido-drb-item.cod-estabel
        AND   movto-ato.nr-pedido-drb      = pedido-drb-item.nr-pedido-drb
        AND   movto-ato.it-codigo          = pedido-drb-item.it-codigo
        AND   movto-ato.idi-tip-movto      = 1 /*Entrada*/ 
        AND   movto-ato.idi-tip-item-movto = p-idi-tip-movto NO-LOCK:

        /*Fazer a diferenciaá∆o das moedas, pois s¢ Ç gravado no campo correspondente conforme tipo do movimento.
            Se essa validaá∆o n∆o for feita a convers∆o Ç feita de forma errada.*/
        IF p-idi-tip-movto = 1 THEN /* internacional */
              ASSIGN i-moeda-aux = pedido-drb-item.moeda.
          ELSE /* nacional */
              ASSIGN i-moeda-aux = pedido-drb-item.cdn-moed-nac.

        IF (i-moeda-aux <> movto-ato.mo-codigo)THEN
            RUN cdp/cd0812.p (input movto-ato.mo-codigo,
                              INPUT i-moeda-aux , 
                              INPUT movto-ato.val-movto-ato-me,
                              INPUT movto-ato.dat-cotac, 
                              OUTPUT de-valor-conv).
        ELSE
            ASSIGN de-valor-conv = movto-ato.val-movto-ato-me.
        
        ASSIGN de-tot-quant-ent = de-tot-quant-ent + movto-ato.val-quant-movto-ato
               de-tot-valor-ent = de-tot-valor-ent + de-valor-conv.
    END.

    FIND FIRST estabelec WHERE estabelec.cod-estabel = pedido-drb-item.cod-estabel NO-LOCK NO-ERROR.
    
    IF NOT VALID-HANDLE(h-bocx332) THEN
        RUN cxbo/bocx332.p PERSISTENT SET h-bocx332.

    /*Indica para a bo da movto-ato que a criaá∆o Ç autom†tica*/
    if not l-verifica-saldo then
        RUN pi-seta-cria-automatico in h-bocx332(INPUT TRUE).

    ASSIGN d-qtd-saldo-aux     = 0  /*de-quant-saldo    */
           d-val-saldo-aux     = 0  /*de-valor-saldo    */
           d-tot-qtd-ent-aux   = 0  /*de-tot-quant-ent  */
           d-tot-qtd-sai-aux   = 0  /*de-tot-quant-baixa*/
           de-qtde-tot-movto   = 0  /*de-tot-quant-ent  */
           de-valor-tot-movto  = 0. /*de-tot-quant-baixa*/

    RUN calculo-saldo-itens IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                                         INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                                         INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                                         INPUT  p-idi-tip-movto, /*i-tip-item-movto  */
                                         OUTPUT d-qtd-saldo-aux, /*de-quant-saldo    */
                                         OUTPUT d-val-saldo-aux, /*de-valor-saldo    */
                                         OUTPUT d-tot-qtd-ent-aux, /*de-tot-quant-ent  */
                                         OUTPUT d-tot-qtd-sai-aux). /*de-tot-quant-baixa*/
    
    RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                                        INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                                        INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                                        INPUT  p-idi-tip-movto, /*i-tip-item-movto  */
                                        OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                                        OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
   
    ASSIGN d-novo-saldo-proporcional = 0.

    IF p-idi-tip-movto = 1 /*INTERNACIONAL*/ THEN DO:
        ASSIGN de-valor-baixa               = (tt-ex4330-retorno.quantidade * de-tot-valor-ent) / d-tot-qtd-ent-aux
               pedido-drb-item.qtd-sdo-item = pedido-drb-item.qtd-sdo-item - tt-ex4330-retorno.quantidade
               d-novo-saldo-proporcional = (de-valor-tot-movto * tt-ex4330-retorno.quantidade) / de-qtde-tot-movto
               pedido-drb-item.val-sdo-item = pedido-drb-item.val-sdo-item - IF d-novo-saldo-proporcional = ? THEN 0 ELSE d-novo-saldo-proporcional
               l-internacional = YES.   
       
    END.
    ELSE DO: /*NACIONAL*/
        ASSIGN de-valor-baixa                = (tt-ex4330-retorno.qtd-item-nac * de-tot-valor-ent) / d-tot-qtd-ent-aux
               pedido-drb-item.qtd-sdo-item-nac = pedido-drb-item.qtd-sdo-item-nac  - tt-ex4330-retorno.qtd-item-nac
               d-novo-saldo-proporcional = (de-valor-tot-movto * tt-ex4330-retorno.qtd-item-nac) / de-qtde-tot-movto     
               pedido-drb-item.val-sdo-item-nac = pedido-drb-item.val-sdo-item-nac - IF d-novo-saldo-proporcional = ? THEN 0 ELSE d-novo-saldo-proporcional. /*round(deValMovtoNovaImp,2).*/
               l-internacional = NO.         
    END.

    
    IF pedido-drb-item.moeda <> ped-venda.mo-codigo THEN DO:	
       RUN cdp/cd0812.p (input pedido-drb-item.moeda,
                         INPUT ped-venda.mo-codigo, 
                         INPUT d-novo-saldo-proporcional, 
                         INPUT d-data-emis-nf, 
                         OUTPUT d-novo-saldo-proporcional-conv).												                                                
    END.
    ELSE
       ASSIGN d-novo-saldo-proporcional-conv = d-novo-saldo-proporcional.

    CREATE tt-movto-ato.
    ASSIGN tt-movto-ato.dat-movto              = today
           tt-movto-ato.cod-estabel            = tt-ex4330-retorno.cod-estabel
           tt-movto-ato.cod-estab-docto        = it-nota-fisc.cod-estabel
           tt-movto-ato.nro-docto              = it-nota-fisc.nr-nota-fis
           tt-movto-ato.serie                  = it-nota-fisc.serie
           tt-movto-ato.nat-operacao           = it-nota-fisc.nat-operacao
           tt-movto-ato.cod-emitente           = emitente.cod-emitente
           tt-movto-ato.num-re                 = c-nr-re
           tt-movto-ato.dat-nf                 = d-data-emis-nf
           tt-movto-ato.cdd-ncm                = it-nota-fisc.class-fiscal
           tt-movto-ato.val-peso               = it-nota-fisc.peso-liq-fat
           tt-movto-ato.un                     = item.un
           tt-movto-ato.mo-codigo              = ped-venda.mo-codigo  
           tt-movto-ato.nr-pedido-drb          = tt-ex4330-retorno.nr-pedido-drb  
           tt-movto-ato.it-codigo              = tt-ex4330-retorno.it-codigo
           tt-movto-ato.it-codigo-re           = it-nota-fisc.it-codigo 
           tt-movto-ato.seq-docto              = it-nota-fisc.nr-seq-fat
           tt-movto-ato.val-quant-movto-ato    = tt-ex4330-retorno.quantidade   WHEN p-idi-tip-movto = 1
           tt-movto-ato.val-quant-movto-ato    = tt-ex4330-retorno.qtd-item-nac WHEN p-idi-tip-movto = 2
           tt-movto-ato.val-quant-movto-ato-re = it-nota-fisc.qt-faturada[1]
           tt-movto-ato.val-movto-ato-me       = d-novo-saldo-proporcional-conv
           tt-movto-ato.val-movto-ato-orig     = (it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1])
           tt-movto-ato.val-movto-ato-re-me    = (it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]) / nota-fiscal.vl-taxa-exp
           tt-movto-ato.dat-cotac              = d-data-emis-nf
           tt-movto-ato.cotacao                = nota-fiscal.vl-taxa-exp
           tt-movto-ato.idi-tip-movto          = 2 /*Baixa*/
           tt-movto-ato.sequencia              = i-cont-seq + 1
           tt-movto-ato.idi-tip-item-movto     = p-idi-tip-movto.
    IF AVAIL proc-siscomex THEN
        ASSIGN tt-movto-ato.dat-reg-export = proc-siscomex.dt-re.

    if not l-verifica-saldo then
        RUN pi-efetiva-criacao-movto-ato.
              
    IF l-controle-cab-pai OR l-controle-cab-comps OR l-controle-componentes then do:
        for first tt-itens-sem-saldo
            where tt-itens-sem-saldo.cod-registro = it-nota-fisc.nr-pedcli
              and tt-itens-sem-saldo.item-pai     = it-nota-fisc.it-codigo
              and tt-itens-sem-saldo.item-filho   = tt-item-estrut.it-codigo no-lock:
        end.
        if not avail tt-itens-sem-saldo then do:
            create tt-itens-sem-saldo.
            assign tt-itens-sem-saldo.cod-registro = it-nota-fisc.nr-pedcli
                   tt-itens-sem-saldo.item-pai     = it-nota-fisc.it-codigo
                   tt-itens-sem-saldo.item-filho   = tt-item-estrut.it-codigo.
        end.
        assign tt-itens-sem-saldo.qtd-faturada = d-qtd-item-pai
               tt-itens-sem-saldo.qtd-baixada  = tt-itens-sem-saldo.qtd-baixada + d-qtd-baixada
               tt-itens-sem-saldo.qtd-indisp   = tt-itens-sem-saldo.qtd-indisp  + d-qtd-indisp.
    end.

    IF VALID-HANDLE(h-bocx332) THEN DO:
        DELETE PROCEDURE h-bocx332.
        ASSIGN h-bocx332 = ?.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recebeTTComponenteDrb DBOProgram 
PROCEDURE recebeTTComponenteDrb:

DEFINE INPUT PARAMETER TABLE FOR tt-ex4330-retorno.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executa-flex DBOProgram 
PROCEDURE pi-executa-flex :

DEFINE INPUT PARAMETER pl-flex as logical no-undo.

assign l-executado-flex = pl-flex.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-efetiva-criacao-movto-ato DBOProgram 
PROCEDURE pi-efetiva-criacao-movto-ato :
/*------------------------------------------------------------------------------
  Purpose: Efetiva a criaá∆o da movto-ato atravÇs da BO    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CAN-FIND (FIRST tt-movto-ato) THEN DO:
       
        run openQueryStatic in h-bocx332 (input "Main":U) no-error.
        run emptyRowErrors in h-bocx332.
        RUN emptyRowObject IN h-bocx332.
        run setRecord in h-bocx332 (input table tt-movto-ato).
        run createRecord in h-bocx332.
        
        if return-value = "NOK":U then do:
            run getRowErrors in h-bocx332 (output table RowErrors).
            run emptyRowErrors in h-bocx332.
        end.
        
        EMPTY TEMP-TABLE tt-movto-ato.
    END.
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaItensSemSaldoDrawback DBOProgram 
PROCEDURE piRetornaItensSemSaldoDrawback : 
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-rw-pre-fatur     AS   ROWID                        NO-UNDO.
    DEFINE INPUT  PARAMETER pr-rw-it-pre-fat    AS   ROWID                        NO-UNDO.
    define input  parameter pi-seq-wt-docto     like wt-docto.seq-wt-docto        no-undo.
    define input  parameter pi-seq-wt-it-docto  like wt-it-docto.seq-wt-it-docto  no-undo.

    DEFINE VARIABLE de-qt-usada-total   AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE de-qt-aloc-total    AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE l-embarque          AS LOGICAL  INITIAL NO  NO-UNDO.

    if pr-rw-pre-fatur <> ? and pr-rw-it-pre-fat <> ? then do:
        FOR FIRST pre-fatur
            WHERE ROWID(pre-fatur) = pr-rw-pre-fatur NO-LOCK:
        END.
    
        FOR FIRST it-pre-fat
            WHERE ROWID(it-pre-fat) = pr-rw-it-pre-fat NO-LOCK:
        END.
    
        IF NOT AVAIL pre-fatur OR NOT AVAIL it-pre-fat THEN
            RETURN.

        assign c-nome-abrev   = it-pre-fat.nome-abrev
               c-nr-pedcli    = it-pre-fat.nr-pedcli
               c-it-codigo    = it-pre-fat.it-codigo
               d-qtd-item-pai = it-pre-fat.qt-alocada
               c-cod-refer    = it-pre-fat.cod-refer
               c-cod-registro = string(pre-fatur.cdd-embarq)
               i-nr-seq       = it-pre-fat.nr-sequencia.
    end.
    else
        if pi-seq-wt-docto <> ? and pi-seq-wt-it-docto <> ? then do:
            for first wt-docto
                where wt-docto.seq-wt-docto = pi-seq-wt-docto no-lock:
            end.

            for first wt-it-docto
                where wt-it-docto.seq-wt-docto    = pi-seq-wt-docto
                  and wt-it-docto.seq-wt-it-docto = pi-seq-wt-it-docto no-lock:
            end.

            IF NOT AVAIL wt-docto OR NOT AVAIL wt-it-docto THEN
                RETURN.

            assign c-nome-abrev   = wt-docto.nome-abrev
                   c-nr-pedcli    = wt-docto.nr-pedcli
                   c-it-codigo    = wt-it-docto.it-codigo
                   d-qtd-item-pai = wt-it-docto.quantidade[1]
                   c-cod-refer    = wt-it-docto.cod-refer.

            FIND first ped-venda 
                 WHERE ped-venda.nome-abrev = c-nome-abrev 
                   AND ped-venda.nr-pedcli  = c-nr-pedcli NO-LOCK NO-ERROR.
            if avail ped-venda then
                assign c-cod-registro = string(ped-venda.nr-pedido).

        end.
    assign l-verifica-saldo = yes.

    FIND FIRST emitente 
         WHERE emitente.nome-abrev = c-nome-abrev NO-LOCK NO-ERROR.
    
    FIND first ITEM 
         WHERE item.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

    if not avail ped-venda then
        find first ped-venda 
             where ped-venda.nome-abrev = c-nome-abrev 
               and ped-venda.nr-pedcli  = c-nr-pedcli NO-LOCK NO-ERROR.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR EACH tt-item-estrut:
        DELETE tt-item-estrut.
    END.

    ASSIGN l-hab-contr-pai      = NO
           l-controle-cab-pai   = NO
           l-controle-cab-comps = NO.

    IF CAN-FIND(FIRST tt-ex4330-retorno WHERE tt-ex4330-retorno.it-codigo-pai  = it-nota-fisc.it-codigo AND
                                              tt-ex4330-retorno.nr-seq-ped-pai = it-nota-fisc.nr-seq-ped) THEN DO:

        /* Rotina Manual pelo programa Faturamento de Pedidos - ft4002 */
        IF nota-fiscal.nr-resumo <> 0 THEN
            ASSIGN l-embarque = YES.
        ELSE
            ASSIGN l-embarque = NO.

        FOR EACH tt-ex4330-retorno WHERE tt-ex4330-retorno.it-codigo-pai  = it-nota-fisc.it-codigo AND
                                         tt-ex4330-retorno.nr-seq-ped-pai = it-nota-fisc.nr-seq-ped NO-LOCK:

            /*Deve considerar apenas os movtos do resumo da NOTA selecionada*/
            IF l-embarque 
                AND tt-ex4330-retorno.nr-resumo <> nota-fiscal.nr-resumo
                THEN
                NEXT.

            ASSIGN i-cont-seq = 0
                   l-controle-componentes = NO.
    
            FOR EACH movto-ato WHERE movto-ato.cod-estabel   = tt-ex4330-retorno.cod-estabel   AND
                                     movto-ato.nr-pedido-drb = tt-ex4330-retorno.nr-pedido-drb AND
                                     movto-ato.it-codigo     = tt-ex4330-retorno.it-codigo     NO-LOCK:
                IF movto-ato.sequencia > i-cont-seq THEN
                    ASSIGN i-cont-seq = movto-ato.sequencia.
            END.

            FIND pedido-drb-item WHERE pedido-drb-item.cod-estabel   = tt-ex4330-retorno.cod-estabel   AND
                                       pedido-drb-item.nr-pedido-drb = tt-ex4330-retorno.nr-pedido-drb AND
                                       pedido-drb-item.it-codigo     = tt-ex4330-retorno.it-codigo     AND 
                                       pedido-drb-item.idi-reg       = 1 EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL pedido-drb-item THEN DO:

                ASSIGN de-tot-quant-ent = 0
                       de-tot-valor-ent = 0.

                FOR EACH  movto-ato
                    WHERE movto-ato.cod-estabel   = pedido-drb-item.cod-estabel
                    AND   movto-ato.nr-pedido-drb = pedido-drb-item.nr-pedido-drb
                    AND   movto-ato.it-codigo     = pedido-drb-item.it-codigo
                    AND   movto-ato.idi-tip-movto = 1 /*Entrada*/ NO-LOCK:
                            
                    IF pedido-drb-item.moeda <> 0 THEN
                        RUN cdp/cd0812.p (input movto-ato.mo-codigo,
                                          INPUT pedido-drb-item.moeda , 
                                          INPUT movto-ato.val-movto-ato-me, 
                                          INPUT movto-ato.dat-cotac, 
                                          OUTPUT de-valor-conv).
                    ELSE
                        ASSIGN de-valor-conv = movto-ato.val-movto-ato-me.
                    
                    ASSIGN de-tot-quant-ent = de-tot-quant-ent + movto-ato.val-quant-movto-ato
                           de-tot-valor-ent = de-tot-valor-ent + de-valor-conv.
                END.

				FIND FIRST estabelec 
					 WHERE estabelec.cod-estabel = pedido-drb-item.cod-estabel NO-LOCK NO-ERROR.
				
                IF emitente.natureza > 2 
                    AND emitente.pais <> estabelec.pais THEN /*internacional*/
                    FIND FIRST pedido-drb WHERE pedido-drb.cod-estabel         = pedido-drb-item.cod-estabel 
                                          AND pedido-drb.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb NO-LOCK NO-ERROR.
                ELSE /*nacional*/
                    FIND FIRST pedido-drb WHERE pedido-drb.cod-estabel         = pedido-drb-item.cod-estabel 
                                          AND pedido-drb.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb 
                                          AND pedido-drb.log-draw-integrad NO-LOCK NO-ERROR.
                IF AVAIL pedido-drb THEN DO:
                    /* N∆o permite que sejam gerados movto-ato.dat-movto para atos concess¢rios vencidos
                       A data de movimento de baixa do ato concessorio Ç criado com "today" */
                    IF pedido-drb.data-validade-ato < TODAY THEN NEXT. 

                    /* Validaá∆o Saldo - Inicio */
					
						IF  tt-ex4330-retorno.quantidade > 0 AND
                            tt-ex4330-retorno.quantidade > pedido-drb-item.qtd-sdo-item THEN DO:
														
							IF l-hab-contr-pai = NO THEN
								ASSIGN l-controle-cab-pai = YES
									   l-controle-cab-comps = YES
									   l-hab-contr-pai = YES.
							ELSE 
								ASSIGN l-controle-cab-pai = NO
									   l-controle-cab-comps = NO.
														
							ASSIGN l-controle-componentes = YES
								   d-qtd-baixada = pedido-drb-item.qtd-sdo-item
								   d-qtd-indisp = tt-ex4330-retorno.quantidade - d-qtd-baixada
								   tt-ex4330-retorno.quantidade = d-qtd-baixada.

						END.

                        IF tt-ex4330-retorno.quantidade > 0 THEN
                            RUN pi-gera-movto-ato-tipo-mercado (INPUT 1).

                        ASSIGN l-controle-cab-pai     = NO
                               l-controle-cab-comps   = NO
                               l-hab-contr-pai        = NO
							   l-controle-componentes = NO
                               d-qtd-baixada          = 0
                               d-qtd-indisp           = 0.

                        ASSIGN i-cont-seq = i-cont-seq + 1.
                               
						IF  pedido-drb.log-draw-integrad       AND
                            tt-ex4330-retorno.qtd-item-nac > 0 AND
                            tt-ex4330-retorno.qtd-item-nac > pedido-drb-item.qtd-sdo-item-nac THEN DO:
														
							IF l-hab-contr-pai = NO THEN
								ASSIGN l-controle-cab-pai = YES
									   l-controle-cab-comps = YES
									   l-hab-contr-pai = YES.
							ELSE 
								ASSIGN l-controle-cab-pai = NO
									   l-controle-cab-comps = NO.
														
							ASSIGN l-controle-componentes = YES
								   d-qtd-baixada = pedido-drb-item.qtd-sdo-item-nac
								   d-qtd-indisp = tt-ex4330-retorno.quantidade - d-qtd-baixada
								   tt-ex4330-retorno.quantidade = d-qtd-baixada.
						END.
                        IF tt-ex4330-retorno.qtd-item-nac > 0 THEN
                            RUN pi-gera-movto-ato-tipo-mercado (INPUT 2).
                END.
            END.
        END.
    END.
    ELSE DO:
    /* Rotina Autom†tica Faturamento de Pedidos - FIFO */
    IF param-global.modulo-en THEN DO:
        IF NOT VALID-HANDLE(h-boin111a) OR
            h-boin111a:TYPE <> "PROCEDURE":U OR
            h-boin111a:FILE-NAME <> "inbo/boin111a.p":U THEN DO:

            RUN inbo/boin111a.p persistent set h-boin111a.
        END.
        
        RUN setConstraint2 IN h-boin111a (INPUT STRING(c-cod-refer),
                                          INPUT STRING(d-qtd-item-pai),
                                          INPUT "19",
                                          INPUT STRING(TODAY),
                                          INPUT ">>>>>,>>9.9999", 
                                          INPUT STRING(c-it-codigo)).

        IF i-pais-impto-usuario <> 1 THEN
            run isDrbInternacional in h-boin111a.                                      

        RUN montaEstrutura IN h-boin111a.
        RUN openQuery IN h-boin111a (INPUT 1).
        RUN getTTEstrutura IN h-boin111a (OUTPUT TABLE tt-item-estrut).
        
        IF VALID-HANDLE(h-boin111a) THEN DO:
            DELETE PROCEDURE h-boin111a.
            ASSIGN h-boin111a = ?.
        END.
        
        ASSIGN c-cod-est    = ""
               c-pedido-ant = ""
               d-data-val   = ?.

        EMPTY TEMP-TABLE tt-pedido-drb-aux.

        FOR EACH tt-item-estrut:
            ASSIGN l-nao-encontrou-pai-saida = YES.

            FOR EACH  pedido-drb-item
                WHERE pedido-drb-item.it-codigo = tt-item-estrut.it-codigo
                      NO-LOCK:

                IF emitente.natureza > 2  THEN /*internacional*/
                    FIND pedido-drb WHERE pedido-drb.cod-estabel         = pedido-drb-item.cod-estabel 
                                      AND pedido-drb.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb 
                                      AND pedido-drb.modalidade          = 1 
                                      AND pedido-drb.nr-ato-concessorio <> "" NO-LOCK NO-ERROR.
                ELSE /*nacional*/
                    FIND pedido-drb WHERE pedido-drb.cod-estabel         = pedido-drb-item.cod-estabel 
                                      AND pedido-drb.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb 
                                      AND pedido-drb.modalidade          = 1 
                                      AND pedido-drb.nr-ato-concessorio <> "" 
                                      AND pedido-drb.log-draw-integrad NO-LOCK NO-ERROR.

                IF AVAIL pedido-drb THEN DO:
                    /*N∆o permite que sejam gerados movto-ato.dat-movto para atos concess¢rios vencidos
                      A data de movimento de baixa do ato concessorio Ç criado com "today"*/
                    IF pedido-drb.data-validade-ato < TODAY THEN NEXT. 

                    FOR FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = pedido-drb.cod-estabel: END.

                    IF NOT pedido-drb.log-draw-integrad THEN DO:

                        IF emitente.natureza > 2 
                           AND emitente.pais <> estabelec.pais THEN DO:
                            IF pedido-drb-item.qtd-sdo-item <= 0 THEN DO:                                
                                NEXT.
                            END.
                        END.
                        ELSE DO:
                            IF pedido-drb-item.qtd-sdo-item-nac <= 0 THEN DO:
                                NEXT.
                            END.
                        END.
                    END.

                    ELSE DO:
                        /*Se for drawback integrado tem que somar os saldos*/
                        IF (pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac ) <= 0 THEN NEXT.
                    END.
                    
                    IF c-pedido-ant = "" THEN 
                        ASSIGN  c-cod-est    = pedido-drb.cod-estabel
                                c-pedido-ant = pedido-drb.nr-pedido-drb
                                d-data-val   = pedido-drb.data-validade-ato.
                    
                    IF d-data-val > pedido-drb.data-validade-ato THEN
                        ASSIGN  c-cod-est    = pedido-drb.cod-estabel
                                c-pedido-ant = pedido-drb.nr-pedido-drb
                                d-data-val   = pedido-drb.data-validade-ato.

                    IF NOT CAN-FIND(FIRST tt-pedido-drb-aux
                                    WHERE tt-pedido-drb-aux.cod-estabel       = pedido-drb.cod-estabel        
                                      AND tt-pedido-drb-aux.nr-pedido-drb     = pedido-drb.nr-pedido-drb) THEN DO:
                        CREATE tt-pedido-drb-aux.
                        ASSIGN tt-pedido-drb-aux.cod-estabel       = pedido-drb.cod-estabel        
                               tt-pedido-drb-aux.nr-pedido-drb     = pedido-drb.nr-pedido-drb      
                               tt-pedido-drb-aux.data-validade-ato = pedido-drb.data-validade-ato. 
                    END.
                END.
            END.    
        END.

        FOR EACH tt-pedido-drb-aux 
            /*BY tt-pedido-drb-aux.data-validade-ato*/:

            IF NOT CAN-FIND(FIRST tt-item-estrut 
                            WHERE tt-item-estrut.quant-usada > 0) THEN LEAVE.

            FIND first pedido-drb 
                 WHERE pedido-drb.cod-estabel   = tt-pedido-drb-aux.cod-estabel 
                   AND pedido-drb.nr-pedido-drb = tt-pedido-drb-aux.nr-pedido-drb NO-LOCK NO-ERROR.
            
            IF AVAIL pedido-drb THEN DO:
                
                FOR EACH tt-item-estrut NO-LOCK:

                    IF tt-item-estrut.quant-usada <= 0 THEN NEXT.

                    ASSIGN de-qt-usada-total = tt-item-estrut.quant-usada
                           de-qt-aloc-total  = 0.
            
                    ASSIGN i-cont-seq = 0
                           l-controle-componentes = NO.
            
                    FOR EACH movto-ato WHERE movto-ato.cod-estabel   = pedido-drb.cod-estabel   AND
                                             movto-ato.nr-pedido-drb = pedido-drb.nr-pedido-drb AND
                                             movto-ato.it-codigo     = tt-item-estrut.it-codigo NO-LOCK:
            
                        IF movto-ato.sequencia > i-cont-seq THEN
                            ASSIGN i-cont-seq = movto-ato.sequencia.
            
                    END.
            
                    FIND first pedido-drb-item 
                         WHERE pedido-drb-item.cod-estabel   = pedido-drb.cod-estabel    
                           and pedido-drb-item.nr-pedido-drb = pedido-drb.nr-pedido-drb  
                           AND pedido-drb-item.it-codigo     = tt-item-estrut.it-codigo  
                           AND pedido-drb-item.idi-reg       = 1 exclusive-lock NO-ERROR.


                    if avail pedido-drb-item then do:
                        ASSIGN de-tot-quant-ent = 0
                               de-tot-valor-ent = 0.
            
                        FOR EACH  movto-ato
                            WHERE movto-ato.cod-estabel   = pedido-drb-item.cod-estabel
                            AND   movto-ato.nr-pedido-drb = pedido-drb-item.nr-pedido-drb
                            AND   movto-ato.it-codigo     = pedido-drb-item.it-codigo
                            AND   movto-ato.idi-tip-movto = 1 /*Entrada*/ NO-LOCK:
            
                            IF pedido-drb-item.moeda <> 0 THEN
                                RUN cdp/cd0812.p (input movto-ato.mo-codigo,
                                                  INPUT pedido-drb-item.moeda , 
                                                  INPUT movto-ato.val-movto-ato-me, 
                                                  INPUT movto-ato.dat-cotac, 
                                                  OUTPUT de-valor-conv).
                            ELSE
                                ASSIGN de-valor-conv = movto-ato.val-movto-ato-me.
            
                            ASSIGN de-tot-quant-ent = de-tot-quant-ent + movto-ato.val-quant-movto-ato
                                   de-tot-valor-ent = de-tot-valor-ent + de-valor-conv.
                        END.
            
                        FIND FIRST estabelec WHERE estabelec.cod-estabel = pedido-drb-item.cod-estabel NO-LOCK NO-ERROR.
                        
                        /*Valida Saldo*/                        
                        IF pedido-drb.log-draw-integrad THEN DO:
                            /*Quando for Drawback Integrado ent∆o soma as quantidades (Internacional + Nacinal) para verificar se tem saldo*/                                
                            IF tt-item-estrut.quant-usada > (pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac) THEN DO:
                                IF l-hab-contr-pai = NO THEN
                                    ASSIGN l-controle-cab-pai = YES
                                           l-controle-cab-comps = YES
                                           l-hab-contr-pai = YES.
                                ELSE 
                                    ASSIGN l-controle-cab-pai = NO
                                           l-controle-cab-comps = NO.
            
                                ASSIGN l-controle-componentes = YES
                                       d-qtd-baixada              = pedido-drb-item.qtd-sdo-item 
                                                                  + pedido-drb-item.qtd-sdo-item-nac
                                       d-qtd-indisp               = tt-item-estrut.quant-usada 
                                                                  - d-qtd-baixada
                                       tt-item-estrut.quant-usada = d-qtd-baixada.
                            END.
                        END.
                        ELSE DO:
                            /*Se n∆o Ç Drawback integrado quantinua validando os saldos individualmente*/
                            IF tt-item-estrut.quant-usada > pedido-drb-item.qtd-sdo-item THEN DO:
                                IF l-hab-contr-pai = NO THEN
                                    ASSIGN l-controle-cab-pai   = YES
                                           l-controle-cab-comps = YES
                                           l-hab-contr-pai      = YES.
                                ELSE 
                                    ASSIGN l-controle-cab-pai   = NO
                                           l-controle-cab-comps = NO.
                                                                          
                                ASSIGN l-controle-componentes = YES
                                       d-qtd-baixada = pedido-drb-item.qtd-sdo-item
                                       d-qtd-indisp  = tt-item-estrut.quant-usada - d-qtd-baixada
                                       tt-item-estrut.quant-usada = d-qtd-baixada.
                            END.
                        END.

                        IF l-controle-cab-pai OR l-controle-cab-comps OR l-controle-componentes then do:
                            for first tt-itens-sem-saldo
                                where tt-itens-sem-saldo.cod-registro = c-cod-registro
                                  and tt-itens-sem-saldo.item-pai     = c-it-codigo
                                  and tt-itens-sem-saldo.item-filho   = tt-item-estrut.it-codigo 
                                  and tt-itens-sem-saldo.nr-sequencia = i-nr-seq  no-lock:
                            end.
                            if not avail tt-itens-sem-saldo then do:
                                create tt-itens-sem-saldo.
                                assign tt-itens-sem-saldo.cod-registro = c-cod-registro
                                       tt-itens-sem-saldo.item-pai     = c-it-codigo    
                                       tt-itens-sem-saldo.item-filho   = tt-item-estrut.it-codigo
                                       tt-itens-sem-saldo.nr-sequencia = i-nr-seq 
                                       tt-itens-sem-saldo.nome-abrev   = emitente.nome-abrev.
                                if i-programa = 4001 then
                                    assign tt-itens-sem-saldo.nr-sequencia = it-pre-fat.nr-sequencia
                                           tt-itens-sem-saldo.nr-resumo    = it-pre-fat.nr-resumo.
                                else
                                    assign tt-itens-sem-saldo.nr-sequencia = wt-it-docto.nr-seq-ped.
                            end.
                            assign tt-itens-sem-saldo.qtd-faturada = d-qtd-item-pai
                                   tt-itens-sem-saldo.qtd-baixada  = tt-itens-sem-saldo.qtd-baixada + d-qtd-baixada
                                   tt-itens-sem-saldo.qtd-indisp   = tt-itens-sem-saldo.qtd-indisp  + d-qtd-indisp.
                        end.

                        ASSIGN dcTotal = tt-item-estrut.quant-usada.
                        IF NOT VALID-HANDLE(h-bocx332) THEN
                                RUN cxbo/bocx332.p PERSISTENT SET h-bocx332.
            
                        IF pedido-drb.log-draw-integrad THEN DO:
                            /*Quando for Drawback Integrado tem que verificar a prioridade de baixa.
                                No Drawback Integrado Ç considerado a soma dos Saldos Internacionais e Nacionais*/
            
                            /*Agora Independente do tipo de natureza tem que somar as duas quantidades para compor o saldo*/
                            IF (pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac ) <= 0 THEN NEXT.
            
                            /*Verifica se ainda tem quantidade para baixar*/
                            DO WHILE tt-item-estrut.quant-usada > 0:
                                CREATE tt-movto-ato.
                                /*Se a Prioridade for para baixar primeiro o saldo nacional*/
                                IF SUBSTRING(pedido-drb.char-1,1,1) = "3" THEN DO: /*Prioridade de Baixa Ç pelo mercado NACIONAL*/
                                    /*NACIONAL*/
                                    /*Verifica se ainda existe saldo nacional para baixar*/
                                    IF pedido-drb-item.qtd-sdo-item-nac > 0 THEN DO:
                                        ASSIGN de-qtde-tot-movto    = 0
                                               de-valor-tot-movto   = 0.
                                        /*Busca o valor total e a quantidade total do Ato para fazer um regra de 3*/
                                        RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                                                                            INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                                                                            INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                                                                            INPUT  2, /*i-tip-item-movto  */
                                                                            OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                                                                            OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
                                        /*Se ainda tem saldo nacional para baixar, verifica se a quantidade para baixa Ç maior que o saldo*/
                                        IF tt-item-estrut.quant-usada - pedido-drb-item.qtd-sdo-item-nac >= 0 THEN DO:                                        
                                            /*Se a quantidade para baixar for maior que a que o saldo nacional, ent∆o diminui o saldo da quantidade a baixar,
                                                zera o saldo nacional e o valor*/
                                            ASSIGN tt-item-estrut.quant-usada          = tt-item-estrut.quant-usada 
                                                                                       - pedido-drb-item.qtd-sdo-item-nac
                                                   tt-movto-ato.val-quant-movto-ato    = pedido-drb-item.qtd-sdo-item-nac
                                                   tt-movto-ato.val-quant-movto-ato-re = d-qtd-item-pai
                                                                                       * (((pedido-drb-item.qtd-sdo-item-nac * 100) / dcTotal) / 100)
                                                   d-novo-saldo-proporcional           = (de-valor-tot-movto * pedido-drb-item.qtd-sdo-item-nac) 
                                                                                       / de-qtde-tot-movto
                                                   pedido-drb-item.val-sdo-item-nac = 0
                                                   pedido-drb-item.qtd-sdo-item-nac = 0
                                                   tt-movto-ato.idi-tip-item-movto     = 2.
                                        END.
                                        ELSE DO:
                                            /*Se a quantidade a baixar for menor que o saldo nacional, ent∆o diminui a quantidade a baixar do saldo
                                                e faz a regra de 3 para baixar o valor.*/
                                            ASSIGN pedido-drb-item.qtd-sdo-item-nac = pedido-drb-item.qtd-sdo-item-nac 
                                                                                       - tt-item-estrut.quant-usada
                                                   tt-movto-ato.val-quant-movto-ato    = tt-item-estrut.quant-usada
                                                   tt-movto-ato.val-quant-movto-ato-re = d-qtd-item-pai
                                                                                       * (((tt-item-estrut.quant-usada * 100) / dcTotal) / 100)
                                                   d-novo-saldo-proporcional           = (de-valor-tot-movto * tt-item-estrut.quant-usada) 
                                                                                       / de-qtde-tot-movto
                                                   pedido-drb-item.val-sdo-item-nac = pedido-drb-item.val-sdo-item-nac 
                                                                                       - d-novo-saldo-proporcional
                                                   tt-item-estrut.quant-usada          = 0
                                                   tt-movto-ato.idi-tip-item-movto     = 2.
                                        END.
                                    END.
                                    ELSE DO:
                                        /*INTERNACIONAL*/
                                        ASSIGN de-qtde-tot-movto    = 0
                                               de-valor-tot-movto   = 0.
                                        RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                                                                            INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                                                                            INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                                                                            INPUT  1, /*i-tip-item-movto  */
                                                                            OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                                                                            OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
            
                                        /*Se a prioridade for nacional e j† baixou todo o saldo nacional, baixa o que resta do saldo internacional*/
                                        ASSIGN tt-movto-ato.val-quant-movto-ato    = tt-item-estrut.quant-usada
                                               pedido-drb-item.qtd-sdo-item     = pedido-drb-item.qtd-sdo-item 
                                                                                   - tt-item-estrut.quant-usada                                           
                                               tt-movto-ato.val-quant-movto-ato-re = d-qtd-item-pai
                                                                                   * (((tt-item-estrut.quant-usada * 100) / dcTotal) / 100)
                                               d-novo-saldo-proporcional           = (de-valor-tot-movto * tt-item-estrut.quant-usada) 
                                                                                   / de-qtde-tot-movto
                                               pedido-drb-item.val-sdo-item     = pedido-drb-item.val-sdo-item 
                                                                                   - d-novo-saldo-proporcional
                                               tt-item-estrut.quant-usada          = 0                                           
                                               tt-movto-ato.idi-tip-item-movto     = 1.
                                    END.
                                END.


                                ELSE DO: /*Prioridade de Baixa Ç pelo mercado INTERNACIONAL OU AMBOS*/

                                    IF pedido-drb-item.qtd-sdo-item > 0 THEN DO:
                                        /*Quando a prioridade for por baixa Internacional ou Ambos, segue a mesma regra da baixa com prioridade nacional,
                                            mas primeiro baixa do Saldo Internacional, e se sobrar quantidade para baixar ent∆o baixa do saldo nacional.
                                        */
                                        /*INTERNACIONAL*/

                                        ASSIGN de-qtde-tot-movto    = 0
                                               de-valor-tot-movto   = 0.

                                        RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                                                                            INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                                                                            INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                                                                            INPUT  1, /*i-tip-item-movto  */
                                                                            OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                                                                            OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
            
            
                                        IF tt-item-estrut.quant-usada - pedido-drb-item.qtd-sdo-item >= 0 THEN
                                            ASSIGN tt-item-estrut.quant-usada          = tt-item-estrut.quant-usada 
                                                                                       - pedido-drb-item.qtd-sdo-item
                                                   tt-movto-ato.val-quant-movto-ato    = pedido-drb-item.qtd-sdo-item
                                                   tt-movto-ato.val-quant-movto-ato-re = d-qtd-item-pai
                                                                                       * (((pedido-drb-item.qtd-sdo-item * 100) / dcTotal) / 100)
                                                   d-novo-saldo-proporcional           = (de-valor-tot-movto * pedido-drb-item.qtd-sdo-item) 
                                                                                       / de-qtde-tot-movto
                                                   pedido-drb-item.val-sdo-item     = 0
                                                   pedido-drb-item.qtd-sdo-item     = 0
                                                   tt-movto-ato.idi-tip-item-movto     = 1.
                                        ELSE
                                            ASSIGN pedido-drb-item.qtd-sdo-item     = pedido-drb-item.qtd-sdo-item 
                                                                                       - tt-item-estrut.quant-usada
                                                   tt-movto-ato.val-quant-movto-ato    = tt-item-estrut.quant-usada
                                                   tt-movto-ato.val-quant-movto-ato-re = d-qtd-item-pai
                                                                                       * (((tt-item-estrut.quant-usada * 100) / dcTotal) / 100)
                                                   d-novo-saldo-proporcional           = (de-valor-tot-movto * tt-item-estrut.quant-usada) 
                                                                                       / de-qtde-tot-movto
                                                   pedido-drb-item.val-sdo-item     = pedido-drb-item.val-sdo-item 
                                                                                       - d-novo-saldo-proporcional
                                                   tt-item-estrut.quant-usada          = 0
                                                   tt-movto-ato.idi-tip-item-movto     = 1.
                                    END.
                                    ELSE DO:

                                        /*NACIONAL*/
                                         ASSIGN de-qtde-tot-movto    = 0
                                                de-valor-tot-movto   = 0.
                                         RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                                                                             INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                                                                             INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                                                                            INPUT  2, /*i-tip-item-movto  */
                                                                            OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                                                                            OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
            
                                        ASSIGN tt-movto-ato.val-quant-movto-ato    = tt-item-estrut.quant-usada
                                               pedido-drb-item.qtd-sdo-item-nac = pedido-drb-item.qtd-sdo-item-nac - tt-item-estrut.quant-usada                                           
                                               tt-movto-ato.val-quant-movto-ato-re = d-qtd-item-pai * (((tt-item-estrut.quant-usada * 100) / dcTotal) / 100)
                                               d-novo-saldo-proporcional           = (de-valor-tot-movto * tt-item-estrut.quant-usada) / de-qtde-tot-movto
                                               pedido-drb-item.val-sdo-item-nac = pedido-drb-item.val-sdo-item-nac - d-novo-saldo-proporcional
                                               tt-item-estrut.quant-usada          = 0                                           
                                               tt-movto-ato.idi-tip-item-movto     = 2.
                                    END.
                                END.

                                ASSIGN i-cont-seq               = i-cont-seq + 1
                                       tt-movto-ato.dat-movto   = today
                                       tt-movto-ato.sequencia   = i-cont-seq.  
                                       de-qt-aloc-total         = de-qt-aloc-total 
                                                                + tt-movto-ato.val-quant-movto-ato.
                                delete tt-movto-ato.
                            END.
                        END.
                        ELSE DO:
                            /* Essa validaá‰es s∆o apenas para quando n∆o for o Drawback integrado*/
            
                            IF pedido-drb-item.qtd-sdo-item <= 0 THEN NEXT.
            
                            FIND FIRST estabelec WHERE estabelec.cod-estabel = pedido-drb-item.cod-estabel NO-LOCK NO-ERROR.
                            
                            IF NOT VALID-HANDLE(h-bocx332) THEN
                                RUN cxbo/bocx332.p PERSISTENT SET h-bocx332.
                            
                            ASSIGN i-tip-item-movto = 1. /* internacional */
            
                            RUN calculo-saldo-itens IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                                                                 INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                                                                 INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                                                                 INPUT  i-tip-item-movto, /*i-tip-item-movto  */
                                                                 OUTPUT d-qtd-saldo-aux, /*de-quant-saldo    */
                                                                 OUTPUT d-val-saldo-aux, /*de-valor-saldo    */
                                                                 OUTPUT d-tot-qtd-ent-aux, /*de-tot-quant-ent  */
                                                                 OUTPUT d-tot-qtd-sai-aux). /*de-tot-quant-baixa*/
            
                            RUN FormaValoresTotais IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                                                                INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                                                                INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                                                                INPUT  i-tip-item-movto, /*i-tip-item-movto  */
                                                                OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                                                                OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
                            
                            ASSIGN d-novo-saldo-proporcional = 0.
            
                            IF pedido-drb-item.val-sdo-item = ? THEN
                                ASSIGN pedido-drb-item.val-sdo-item = 0.
            
                            ASSIGN de-valor-baixa  = (tt-item-estrut.quant-usada * de-tot-valor-ent) / de-tot-quant-ent
                                d-novo-saldo-proporcional = (de-valor-tot-movto * tt-item-estrut.quant-usada) / de-qtde-tot-movto
                                pedido-drb-item.qtd-sdo-item = pedido-drb-item.qtd-sdo-item - tt-item-estrut.quant-usada
                                pedido-drb-item.val-sdo-item = pedido-drb-item.val-sdo-item - d-novo-saldo-proporcional.
            
                            IF d-novo-saldo-proporcional = ? THEN d-novo-saldo-proporcional = 0.    					 
            
                            ASSIGN i-moeda-aux = pedido-drb-item.moeda.
            
                            IF i-moeda-aux <> ped-venda.mo-codigo THEN DO:	
                               RUN cdp/cd0812.p (input pedido-drb-item.moeda,
                                                 INPUT i-moeda-aux, 
                                                 INPUT d-novo-saldo-proporcional, 
                                                 INPUT d-data-emis-nf, 
                                                 OUTPUT d-novo-saldo-proporcional-conv).												                                                
                            END.
                            ELSE
                                ASSIGN d-novo-saldo-proporcional-conv = d-novo-saldo-proporcional.
                           
            
                            ASSIGN de-qt-aloc-total = de-qt-aloc-total + tt-item-estrut.quant-usada.

                        END.
                        IF VALID-HANDLE(h-bocx332) THEN DO:
                            DELETE PROCEDURE h-bocx332.
                            ASSIGN h-bocx332 = ?.
                        END.

                        ASSIGN tt-item-estrut.quant-usada = de-qt-usada-total - de-qt-aloc-total.
                    END.
                END.
            END.
        END.
    END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaPrograma DBOProgram 
PROCEDURE piSetaPrograma : 
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter pi-programa as integer no-undo.

    assign i-programa = pi-programa.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaUltimaSeq DBOProgram 
PROCEDURE piSetaUltimaSeq : 
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter pl-ult-seq-nota as logical no-undo.

    assign l-ult-seq-nota = pl-ult-seq-nota.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

    
