/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0001RP 2.00.00.013 } /*** "010013" ***/
/******************************************************************************************
** Copyright DATASUL S.A. (1998)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************************/
{utp/ut-glob.i}
{include/i-rpvar.i}
{afp/af0001.i1}    /* Defini‡Æo da temp-table tt-param e tt-digita */

/*******Defini‡Æo de Parƒmetros *******/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF VAR i-seq                AS INT     NO-UNDO.
DEF VAR i-item               AS INT     NO-UNDO.
DEF VAR i-familia            AS INT     NO-UNDO.
DEF VAR i-item-estab         AS INT     NO-UNDO.
DEF VAR h-acomp              AS HANDLE  NO-UNDO.
DEF VAR l-tem-relacionamento AS LOG     NO-UNDO.
DEF VAR c-lbl-liter-emitente AS CHAR    NO-UNDO.
DEF VAR c-lbl-liter-item     AS CHAR    NO-UNDO.
DEF VAR de-demerito          AS DECIMAL NO-UNDO.
DEF VAR i-nr-dia-max         AS INTEGER NO-UNDO. 
DEF VAR i-nr-dia-min         AS INTEGER NO-UNDO. 
DEF VAR lg-qtd-receb         AS LOGICAL NO-UNDO. 
DEF VAR lg-val-receb         AS LOGICAL NO-UNDO. 
DEF VAR de-pct-qtd-min       AS DECIMAL NO-UNDO. 
DEF VAR de-pct-qtd-max       AS DECIMAL NO-UNDO. 
DEF VAR de-pct-val-min       AS DECIMAL NO-UNDO. 
DEF VAR de-pct-val-max       AS DECIMAL NO-UNDO. 
DEF VAR i-dias-cotacao       AS INTEGER NO-UNDO.

DEF TEMP-TABLE tt-controle NO-UNDO LIKE af-controle 
    FIELD percentual AS DECIMAL
    INDEX ep-codigo  ep-codigo nr-controle.

DEF TEMP-TABLE tt-item-fornec-verificados NO-UNDO
    FIELD cod-emitente LIKE emitente.cod-emitente
    FIELD it-codigo LIKE ITEM.it-codigo.

create tt-param.
raw-transfer raw-param to tt-param no-error.
for each tt-raw-digita:
   create tt-digita.
   raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

{include/i-rpcab.i}
{include/i-rpout.i}

FIND FIRST param-global NO-LOCK NO-ERROR.

ASSIGN c-programa 	  = "AF0001RP"
       c-versao	      = "2.00"
	   c-revisao	  = ".00.000"
	   c-empresa 	  = param-global.grupo
	   c-sistema	  = "MAF"
	   c-titulo-relat = "Gera‡Æo Parƒmetros Avalia‡Æo Fornecedor".   

{utp/ut-liter.i "Emitente" *}
ASSIGN c-lbl-liter-emitente = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Item" *}
ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).

view frame f-cabec.
view frame f-rodape.

FIND FIRST tt-param NO-LOCK NO-ERROR.

ASSIGN i-familia = 0
       i-item    = 0
       i-item-estab = 0.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Criando relacionamentos ...").

RUN pi-cria-parametros.

ASSIGN i-dias-cotacao = tt-param.da-oc-fin - tt-param.da-oc-ini.

IF tt-param.lapenasordemcompra AND tt-param.cIniEstab = tt-param.cEndEstab THEN DO:
    /* Se o per¡odo de cota‡äes for de at‚ 3 meses, a leitura ser  feita com base nas cota‡äes, 
       para que seja mais perform tica do que ler primeiro item / fornecedor */
    IF i-dias-cotacao <= 90 THEN DO:
        RUN pi-leitura-criacao-por-cotacao IN THIS-PROCEDURE.
    END.
    ELSE DO:
        block-item-estab:
        FOR EACH item-estab FIELDS (cod-estabel it-codigo) 
            WHERE item-estab.cod-estabel = tt-param.cIniEstab 
              AND item-estab.it-codigo  >= tt-param.cIniitem
              AND item-estab.it-codigo  <= tt-param.cEnditem NO-LOCK:
    
            IF NOT CAN-FIND (FIRST cotacao-item
                             WHERE cotacao-item.it-codigo     = item-estab.it-codigo
                               AND cotacao-item.data-cotacao >= tt-param.da-oc-ini 
                               AND cotacao-item.data-cotacao <= tt-param.da-oc-fin
                               AND cotacao-item.cot-aprovada) THEN NEXT.
               
            IF tt-param.lapenasItemFornec THEN
                IF NOT CAN-FIND (FIRST item-fornec NO-LOCK
                                 WHERE item-fornec.it-codigo    = item-estab.it-codigo 
                                   AND item-fornec.cod-emitente >= tt-param.cIniFornec
                                   AND item-fornec.cod-emitente <= tt-param.cEndFornec) THEN NEXT.
    
            FOR FIRST ITEM FIELDS (it-codigo fm-codigo cod-obsoleto) 
                WHERE ITEM.it-codigo = item-estab.it-codigo
                 AND  ITEM.fm-codigo >= tt-param.cIniFamilia
                 AND  ITEM.fm-codigo <= tt-param.cEndFamilia
                 AND  item.ge-codigo >= tt-param.i-ge-codigo-ini
                 AND  item.ge-codigo <= tt-param.i-ge-codigo-fim 
                 AND  ITEM.data-implant >= tt-param.dtIniImplantItem
                 AND  ITEM.data-implant <= tt-param.dtEndImplantItem NO-LOCK: 
                IF tt-param.l-item-ativo AND ITEM.cod-obsoleto <> 1 THEN NEXT block-item-estab.
             END.
            IF NOT AVAIL ITEM THEN NEXT.
    
            IF tt-param.lapenasItemFornec THEN DO:
            
                block-item-fornec:
                FOR EACH item-fornec FIELDS (cod-emitente it-codigo) WHERE
                         item-fornec.it-codigo = item-estab.it-codigo    AND 
                         item-fornec.cod-emitente >= tt-param.cIniFornec AND 
                         item-fornec.cod-emitente <= tt-param.cEndFornec NO-LOCK:
        
                    FOR FIRST emitente FIELDS (cod-emitente identific)
                        WHERE emitente.cod-emitente  = item-fornec.cod-emitente
                          AND emitente.cod-gr-forn  >= tt-param.i-cod-gr-forn-ini
                          AND emitente.cod-gr-forn  <= tt-param.i-cod-gr-forn-fim 
                          AND emitente.data-implant >= tt-param.dtIniImplantForn
                          AND emitente.data-implant  <= tt-param.dtEndImplantForn
                          AND emitente.identific >= 2 NO-LOCK:
                        IF tt-param.l-fornecedor-ativo THEN DO:
                            FOR FIRST dist-emitente FIELDS (idi-sit-fornec)
                                WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK: 
                                IF dist-emitente.idi-sit-fornec <> 1 THEN DO: 
                                    NEXT block-item-fornec.
                                END.
                            END.
                            IF NOT AVAIL dist-emitente THEN DO: 
                                NEXT block-item-fornec.
                            END.
                        END.
                    END.
                    IF NOT AVAIL emitente THEN NEXT.
    
                    IF NOT CAN-FIND (FIRST cotacao-item USE-INDEX ITEM   /*mesmo testando a cota‡Æo acima, ainda ‚ preciso garantir que vai gerar o relacionamento somente pro emitente da cota‡Æo */
                             WHERE cotacao-item.it-codigo    = item-fornec.it-codigo
                               AND cotacao-item.cod-emitente = item-fornec.cod-emitente
                               AND cotacao-item.data-cotacao >= tt-param.da-oc-ini 
                               AND cotacao-item.data-cotacao <= tt-param.da-oc-fin
                               AND cotacao-item.cot-aprovada) THEN NEXT.
                    /* Inicio -- Projeto Internacional */
                    RUN pi-acompanhar IN h-acomp (INPUT c-lbl-liter-emitente + ": " + STRING(emitente.cod-emitente) + " " + c-lbl-liter-item + ": " + ITEM.it-codigo).
            
                    IF tt-param.lFamilia THEN
                        RUN pi-cria-relac-familia.
            
                    IF tt-param.lItem THEN
                       RUN pi-cria-relac-item.
            
                    IF tt-param.lItemEstab THEN
                        RUN pi-cria-relac-item-estab.
                    
                END.
            END.
            ELSE DO:
    
                block-emitente:
                FOR EACH emitente FIELDS (cod-emitente identific)
                   WHERE emitente.cod-emitente >= tt-param.cIniFornec
                     AND emitente.cod-emitente <= tt-param.cEndFornec
                     AND emitente.cod-gr-forn  >= tt-param.i-cod-gr-forn-ini
                     AND emitente.cod-gr-forn  <= tt-param.i-cod-gr-forn-fim
                     AND emitente.data-implant >= tt-param.dtIniImplantForn
                     AND emitente.data-implant  <= tt-param.dtEndImplantForn
                     AND emitente.identific >= 2 NO-LOCK:
    
                    IF tt-param.l-fornecedor-ativo THEN DO:
                        FOR FIRST dist-emitente FIELDS (idi-sit-fornec)
                            WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK: 
                            IF dist-emitente.idi-sit-fornec <> 1 THEN DO: 
                                NEXT block-emitente.
                            END.
                        END.
                        IF NOT AVAIL dist-emitente THEN DO: 
                            NEXT block-emitente.
                        END.
                    END.
		    
		    
		    IF NOT CAN-FIND (FIRST cotacao-item USE-INDEX ITEM /*mesmo testando a cota‡Æo acima, ainda ‚ preciso garantir que vai gerar o relacionamento somente pro emitente da cota‡Æo */
                             WHERE cotacao-item.it-codigo    = ITEM.it-codigo
                               AND cotacao-item.cod-emitente = emitente.cod-emitente
                               AND cotacao-item.data-cotacao >= tt-param.da-oc-ini 
                               AND cotacao-item.data-cotacao <= tt-param.da-oc-fin
                               AND cotacao-item.cot-aprovada) THEN NEXT.
  
		    
		    
    
                    /* Inicio -- Projeto Internacional */
                    RUN pi-acompanhar IN h-acomp (INPUT c-lbl-liter-emitente + ": " + STRING(emitente.cod-emitente) + " " + c-lbl-liter-item + ": " + ITEM.it-codigo).
            
                    IF tt-param.lFamilia THEN
                        RUN pi-cria-relac-familia.
            
                    IF tt-param.lItem THEN
                       RUN pi-cria-relac-item.
            
                    IF tt-param.lItemEstab THEN
                        RUN pi-cria-relac-item-estab.
                END.
            END.
        END.
    END. /* Fim - Leitura por item-estab */
END.
ELSE IF tt-param.lapenasItemFornec THEN DO:
    /* Se o per¡odo de cota‡äes for de at‚ 3 meses, a leitura ser  feita com base nas cota‡äes, 
       para que seja mais perform tica do que ler primeiro item / fornecedor */
    IF tt-param.lapenasordemcompra AND i-dias-cotacao <= 90 THEN DO:
        RUN pi-leitura-criacao-por-cotacao IN THIS-PROCEDURE.
    END.
    ELSE DO:
        block-item-fornec2:
        FOR EACH item-fornec FIELDS (cod-emitente it-codigo)
           WHERE item-fornec.it-codigo    >= tt-param.cIniitem
             AND item-fornec.it-codigo    <= tt-param.cEnditem
             AND item-fornec.cod-emitente >= tt-param.cIniFornec
             AND item-fornec.cod-emitente <= tt-param.cEndFornec NO-LOCK:
            
            IF tt-param.lapenasordemcompra THEN DO:
                IF NOT CAN-FIND (FIRST cotacao-item USE-INDEX ITEM
                                 WHERE cotacao-item.it-codigo    = item-fornec.it-codigo
                                   AND cotacao-item.cod-emitente = item-fornec.cod-emitente
                                   AND cotacao-item.data-cotacao >= tt-param.da-oc-ini 
                                   AND cotacao-item.data-cotacao <= tt-param.da-oc-fin
                                   AND cotacao-item.cot-aprovada) THEN NEXT.
            END.
    
            FOR FIRST emitente FIELDS (cod-emitente identific)
                 WHERE emitente.cod-emitente = item-fornec.cod-emitente
                   AND emitente.cod-gr-forn  >= tt-param.i-cod-gr-forn-ini
                   AND emitente.cod-gr-forn  <= tt-param.i-cod-gr-forn-fim 
                   AND emitente.data-implant >= tt-param.dtIniImplantForn
                   AND emitente.data-implant <= tt-param.dtEndImplantForn
                   AND emitente.identific >= 2 NO-LOCK:
                IF tt-param.l-fornecedor-ativo THEN DO:
                    FOR FIRST dist-emitente FIELDS (idi-sit-fornec)
                        WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK: 
                        IF dist-emitente.idi-sit-fornec <> 1 THEN DO: 
                            NEXT block-item-fornec2.
                        END.
                    END.
                    IF NOT AVAIL dist-emitente THEN DO: 
                        NEXT block-item-fornec2.
                    END.
                END.
            END.
            IF NOT AVAIL emitente THEN NEXT.
            
            FOR FIRST item FIELDS (it-codigo fm-codigo cod-obsoleto)
                 WHERE item.it-codigo    = item-fornec.it-codigo
                 AND   ITEM.fm-codigo    >= tt-param.cIniFamilia
                 AND   ITEM.fm-codigo    <= tt-param.cEndFamilia
                 AND   item.ge-codigo    >= tt-param.i-ge-codigo-ini
                 AND   item.ge-codigo    <= tt-param.i-ge-codigo-fim 
                 AND   ITEM.data-implant >= tt-param.dtIniImplantItem
                 AND   ITEM.data-implant <= tt-param.dtEndImplantItem NO-LOCK: 
                    IF tt-param.l-item-ativo AND ITEM.cod-obsoleto <> 1 THEN DO:
                        NEXT block-item-fornec2.
                    END.
                END.
            IF NOT AVAIL ITEM THEN NEXT.
    
            /* Inicio -- Projeto Internacional */
            RUN pi-acompanhar IN h-acomp (INPUT c-lbl-liter-emitente + ": " + STRING(emitente.cod-emitente) + " " + c-lbl-liter-item + ": " + ITEM.it-codigo).
    
            IF tt-param.lFamilia THEN
                RUN pi-cria-relac-familia.
    
            IF tt-param.lItem THEN
                RUN pi-cria-relac-item.
    
            IF tt-param.lItemEstab THEN
                RUN pi-cria-relac-item-estab.
        END.
    END.
END.
ELSE DO:
    /* Se o per¡odo de cota‡äes for de at‚ 3 meses, a leitura ser  feita com base nas cota‡äes, 
       para que seja mais perform tica do que ler primeiro item / fornecedor */
    IF tt-param.lapenasordemcompra AND i-dias-cotacao <= 90 THEN DO:
        RUN pi-leitura-criacao-por-cotacao IN THIS-PROCEDURE.
    END.
    ELSE DO:
       block-emitente2:
       FOR EACH emitente FIELDS (cod-emitente identific)
           WHERE emitente.cod-emitente >= tt-param.cIniFornec
             AND emitente.cod-emitente <= tt-param.cEndFornec
             AND emitente.cod-gr-forn  >= tt-param.i-cod-gr-forn-ini
             AND emitente.cod-gr-forn  <= tt-param.i-cod-gr-forn-fim 
             AND emitente.data-implant >= tt-param.dtIniImplantForn
             AND emitente.data-implant <= tt-param.dtEndImplantForn
             AND emitente.identific >= 2 NO-LOCK:
    
            IF tt-param.l-fornecedor-ativo THEN DO:
                FOR FIRST dist-emitente FIELDS (idi-sit-fornec)
                    WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK: 
                    IF dist-emitente.idi-sit-fornec <> 1 THEN DO: 
                        NEXT block-emitente2.
                    END.
                END.
                IF NOT AVAIL dist-emitente THEN DO: 
                    NEXT block-emitente2.
                END.
            END.
    
           FOR EACH item FIELDS (it-codigo fm-codigo cod-obsoleto)
               WHERE item.it-codigo    >= tt-param.cIniitem
               AND   item.it-codigo    <= tt-param.cEnditem
               AND   ITEM.fm-codigo    >= tt-param.cIniFamilia
               AND   ITEM.fm-codigo    <= tt-param.cEndFamilia
               AND   item.ge-codigo    >= tt-param.i-ge-codigo-ini
               AND   item.ge-codigo    <= tt-param.i-ge-codigo-fim 
               AND   ITEM.data-implant >= tt-param.dtIniImplantItem
               AND   ITEM.data-implant <= tt-param.dtEndImplantItem NO-LOCK:
    
               IF tt-param.l-item-ativo AND ITEM.cod-obsoleto <> 1 THEN NEXT.
    
               IF tt-param.lapenasordemcompra THEN DO:
                  IF NOT CAN-FIND (FIRST cotacao-item
                                   WHERE cotacao-item.it-codigo    = ITEM.it-codigo
                                     AND cotacao-item.cod-emitente = emitente.cod-emitente
                                     AND cotacao-item.data-cotacao >= tt-param.da-oc-ini 
                                     AND cotacao-item.data-cotacao <= tt-param.da-oc-fin
                                     AND cotacao-item.cot-aprovada) THEN NEXT.
               END.
    
               /* Inicio -- Projeto Internacional */
               RUN pi-acompanhar IN h-acomp (INPUT c-lbl-liter-emitente + ": " + STRING(emitente.cod-emitente) + " " + c-lbl-liter-item + ": " + ITEM.it-codigo).
               
               IF tt-param.lFamilia THEN
                  RUN pi-cria-relac-familia.
    
               IF tt-param.lItem THEN
                  RUN pi-cria-relac-item.
    
               IF tt-param.lItemEstab THEN
                  RUN pi-cria-relac-item-estab.
               
           END.
       END.
   END.
END.

/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-lbl-liter-relacionamento-familia-x-pont AS CHARACTER FORMAT "X(65)" NO-UNDO.
{utp/ut-liter.i ">>>_Relacionamento_Fam¡lia_X_Ponto_de_Controle" *}
ASSIGN c-lbl-liter-relacionamento-familia-x-pont = TRIM(RETURN-VALUE).
PUT UNFORMATTED c-lbl-liter-relacionamento-familia-x-pont  + "...............: " i-familia SKIP.
/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-lbl-liter-relacionamento-item-x-ponto-d AS CHARACTER FORMAT "X(65)" NO-UNDO.
{utp/ut-liter.i ">>>_Relacionamento_Item_X_Ponto_de_Controle" *}
ASSIGN c-lbl-liter-relacionamento-item-x-ponto-d = TRIM(RETURN-VALUE).
PUT UNFORMATTED c-lbl-liter-relacionamento-item-x-ponto-d + "..................: " i-item    SKIP.
/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-lbl-liter-relacionamento-item-x-ponto-d-2 AS CHARACTER FORMAT "X(65)" NO-UNDO.
{utp/ut-liter.i ">>>_Relacionamento_Item_X_Ponto_de_Controle_X_Estabelecimento" *}
ASSIGN c-lbl-liter-relacionamento-item-x-ponto-d-2 = TRIM(RETURN-VALUE).
PUT UNFORMATTED c-lbl-liter-relacionamento-item-x-ponto-d-2 + ": " i-item-estab SKIP.


RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i}

RETURN "OK":U.




PROCEDURE pi-cria-relac-familia:
         
    IF NOT CAN-FIND (FIRST af-familia-contr
                     WHERE af-familia-contr.ep-codigo        = i-ep-codigo-usuario
                       AND trim(af-familia-contr.fm-codigo)  = trim(item.fm-codigo)
                       AND af-familia-contr.cod-emitente     = emitente.cod-emitente
                       AND af-familia-contr.nr-versao        = tt-param.nr-versao) THEN DO:

        CREATE af-familia-contr.
        ASSIGN af-familia-contr.ep-codigo               = i-ep-codigo-usuario
               af-familia-contr.fm-codigo               = item.fm-codigo
               af-familia-contr.cod-emitente            = emitente.cod-emitente
               af-familia-contr.demerito                = tt-param.dDemerito      
               af-familia-contr.qualidade               = tt-param.lQualidade      
               af-familia-contr.quantidade              = tt-param.lQuantidade      
               af-familia-contr.data-entrega            = tt-param.lDataEntrega       
               af-familia-contr.preco                   = tt-param.lPreco      
               af-familia-contr.nr-dia-max              = tt-param.dVarMax      
               af-familia-contr.nr-dia-min              = tt-param.dVarMin  
               af-familia-contr.log-considera-qtd-receb = tt-param.log-considera-qtd-receb
               af-familia-contr.log-considera-val-receb = tt-param.log-considera-val-receb
               af-familia-contr.pct-qtd-min             = tt-param.pct-qtd-min
               af-familia-contr.pct-qtd-max             = tt-param.pct-qtd-max
               af-familia-contr.pct-val-min             = tt-param.pct-val-min
               af-familia-contr.pct-val-max             = tt-param.pct-val-max
               af-familia-contr.cod-grp-avaliacao       = tt-param.cod-grp-aval
               af-familia-contr.nr-versao               = tt-param.nr-versao
               af-familia-contr.nr-versao-grp-avaliacao = tt-param.nr-versao-grp-avaliacao
               af-familia-contr.dt-implantacao          = TODAY
               af-familia-contr.dt-alter                = TODAY
               af-familia-contr.hora-alter              = STRING(TIME,"HH:MM:SS")
               af-familia-contr.usuar-alter             = c-seg-usuario.
    
        IF tt-param.assume-grp-aval THEN DO:
            ASSIGN af-familia-contr.demerito                = de-demerito   
                   af-familia-contr.nr-dia-max              = i-nr-dia-max  
                   af-familia-contr.nr-dia-min              = i-nr-dia-min  
                   af-familia-contr.log-considera-qtd-receb = lg-qtd-receb  
                   af-familia-contr.log-considera-val-receb = lg-val-receb  
                   af-familia-contr.pct-qtd-min             = de-pct-qtd-min
                   af-familia-contr.pct-qtd-max             = de-pct-qtd-max
                   af-familia-contr.pct-val-min             = de-pct-val-min
                   af-familia-contr.pct-val-max             = de-pct-val-max.
        END.

        ASSIGN i-seq = 10
               i-familia = i-familia + 1.

        FOR EACH tt-controle WHERE
                 tt-controle.ep-codigo = i-ep-codigo-usuario NO-LOCK:
            CREATE af-familia-contr-form.
            ASSIGN af-familia-contr-form.ep-codigo        = i-ep-codigo-usuario
                   af-familia-contr-form.fm-codigo        = ITEM.fm-codigo
                   af-familia-contr-form.cod-emitente     = emitente.cod-emitente
                   af-familia-contr-form.seq              = i-seq
                   af-familia-contr-form.percentual       = tt-controle.percentual
                   af-familia-contr-form.nr-controle      = tt-controle.nr-controle
                   af-familia-contr-form.nr-versao        = tt-param.nr-versao
                   af-familia-contr-form.dt-implantacao   = TODAY
                   af-familia-contr-form.cod-grp-resp     = tt-controle.cod-grp-resp
                   af-familia-contr-form.log-per-variavel = tt-controle.log-per-variavel    
                   af-familia-contr-form.dt-ult-aval      = tt-controle.dt-ult-aval    
                   af-familia-contr-form.dt-prox-aval     = tt-controle.dt-prox-aval   
                   af-familia-contr-form.ind-tipo-periodo = tt-controle.ind-tipo-periodo
                   i-seq = i-seq + 10. 
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-cria-relac-item:

    IF NOT CAN-FIND (FIRST af-item-contr
                     WHERE af-item-contr.ep-codigo       = i-ep-codigo-usuario
                       AND trim(af-item-contr.it-codigo) = trim(item.it-codigo)
                       AND af-item-contr.cod-emitente    = emitente.cod-emitente
                       AND af-item-contr.nr-versao       = tt-param.nr-versao) THEN DO:

        CREATE af-item-contr.
        ASSIGN af-item-contr.ep-codigo               = i-ep-codigo-usuario
               af-item-contr.it-codigo               = item.it-codigo
               af-item-contr.cod-emitente            = emitente.cod-emitente
               af-item-contr.demerito                = tt-param.dDemerito      
               af-item-contr.qualidade               = tt-param.lQualidade      
               af-item-contr.quantidade              = tt-param.lQuantidade      
               af-item-contr.data-entrega            = tt-param.lDataEntrega       
               af-item-contr.preco                   = tt-param.lPreco      
               af-item-contr.nr-dia-max              = tt-param.dVarMax      
               af-item-contr.nr-dia-min              = tt-param.dVarMin
               af-item-contr.log-considera-qtd-receb = tt-param.log-considera-qtd-receb
               af-item-contr.log-considera-val-receb = tt-param.log-considera-val-receb
               af-item-contr.pct-qtd-min             = tt-param.pct-qtd-min
               af-item-contr.pct-qtd-max             = tt-param.pct-qtd-max
               af-item-contr.pct-val-min             = tt-param.pct-val-min
               af-item-contr.pct-val-max             = tt-param.pct-val-max
               af-item-contr.cod-grp-avaliacao       = tt-param.cod-grp-aval                      
               af-item-contr.nr-versao               = tt-param.nr-versao
               af-item-contr.nr-versao-grp-avaliacao = tt-param.nr-versao-grp-avaliacao
               af-item-contr.dt-implantacao          = TODAY
               af-item-contr.dt-alter                = TODAY
               af-item-contr.hora-alter              = STRING(TIME,"HH:MM:SS")
               af-item-contr.usuar-alter             = c-seg-usuario.

        IF tt-param.assume-grp-aval THEN DO:
            ASSIGN af-item-contr.demerito                = de-demerito     
                   af-item-contr.nr-dia-max              = i-nr-dia-max    
                   af-item-contr.nr-dia-min              = i-nr-dia-min    
                   af-item-contr.log-considera-qtd-receb = lg-qtd-receb    
                   af-item-contr.log-considera-val-receb = lg-val-receb    
                   af-item-contr.pct-qtd-min             = de-pct-qtd-min  
                   af-item-contr.pct-qtd-max             = de-pct-qtd-max  
                   af-item-contr.pct-val-min             = de-pct-val-min  
                   af-item-contr.pct-val-max             = de-pct-val-max. 
        END.

        ASSIGN i-seq = 10
               i-item = i-item + 1.
    
        FOR EACH tt-controle WHERE
                 tt-controle.ep-codigo = i-ep-codigo-usuario NO-LOCK:
            CREATE af-item-contr-form.
            ASSIGN af-item-contr-form.ep-codigo        = i-ep-codigo-usuario
                   af-item-contr-form.it-codigo        = item.it-codigo
                   af-item-contr-form.cod-emitente     = emitente.cod-emitente
                   af-item-contr-form.seq              = i-seq
                   af-item-contr-form.percentual       = tt-controle.percentual
                   af-item-contr-form.nr-controle      = tt-controle.nr-controle
                   af-item-contr-form.nr-versao        = tt-param.nr-versao
                   af-item-contr-form.dt-implantacao   = TODAY
                   af-item-contr-form.cod-grp-resp     = tt-controle.cod-grp-resp
                   af-item-contr-form.log-per-variavel = tt-controle.log-per-variavel    
                   af-item-contr-form.dt-ult-aval      = tt-controle.dt-ult-aval    
                   af-item-contr-form.dt-prox-aval     = tt-controle.dt-prox-aval   
                   af-item-contr-form.ind-tipo-periodo = tt-controle.ind-tipo-periodo
                   i-seq = i-seq + 10. 
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-cria-relac-item-estab:

    FOR EACH estabelec FIELDS (cod-estabel) 
       WHERE estabelec.cod-estabel >= tt-param.cIniEstab
         AND estabelec.cod-estabel <= tt-param.cEndEstab NO-LOCK:

        IF NOT CAN-FIND (FIRST af-item-contr-estab
                         WHERE af-item-contr-estab.ep-codigo       = i-ep-codigo-usuario
                           AND trim(af-item-contr-estab.it-codigo) = trim(item.it-codigo)
                           AND af-item-contr-estab.cod-emitente    = emitente.cod-emitente
                           AND af-item-contr-estab.cod-estabel     = estabelec.cod-estabel
                           AND af-item-contr-estab.nr-versao       = tt-param.nr-versao) THEN DO:

            CREATE af-item-contr-estab.
            ASSIGN af-item-contr-estab.ep-codigo               = i-ep-codigo-usuario
                   af-item-contr-estab.it-codigo               = item.it-codigo
                   af-item-contr-estab.cod-emitente            = emitente.cod-emitente
                   af-item-contr-estab.cod-estabel             = estabelec.cod-estabel
                   af-item-contr-estab.demerito                = tt-param.dDemerito      
                   af-item-contr-estab.qualidade               = tt-param.lQualidade      
                   af-item-contr-estab.quantidade              = tt-param.lQuantidade      
                   af-item-contr-estab.data-entrega            = tt-param.lDataEntrega       
                   af-item-contr-estab.preco                   = tt-param.lPreco      
                   af-item-contr-estab.nr-dia-max              = tt-param.dVarMax      
                   af-item-contr-estab.nr-dia-min              = tt-param.dVarMin
                   af-item-contr-estab.log-considera-qtd-receb = tt-param.log-considera-qtd-receb
                   af-item-contr-estab.log-considera-val-receb = tt-param.log-considera-val-receb
                   af-item-contr-estab.pct-qtd-min             = tt-param.pct-qtd-min
                   af-item-contr-estab.pct-qtd-max             = tt-param.pct-qtd-max
                   af-item-contr-estab.pct-val-min             = tt-param.pct-val-min
                   af-item-contr-estab.pct-val-max             = tt-param.pct-val-max
                   af-item-contr-estab.cod-grp-avaliacao       = tt-param.cod-grp-aval
                   af-item-contr-estab.nr-versao               = tt-param.nr-versao
                   af-item-contr-estab.nr-versao-grp-avaliacao = tt-param.nr-versao-grp-avaliacao
                   af-item-contr-estab.log-inf-grp-aval        = tt-param.assume-grp-aval
                   af-item-contr-estab.dt-implantacao          = TODAY
                   af-item-contr-estab.dt-alter                = TODAY
                   af-item-contr-estab.hora-alter              = STRING(TIME,"HH:MM:SS")
                   af-item-contr-estab.usuar-alter             = c-seg-usuario.
    
            IF tt-param.assume-grp-aval THEN DO:
                ASSIGN af-item-contr-estab.demerito                = de-demerito     
                       af-item-contr-estab.nr-dia-max              = i-nr-dia-max    
                       af-item-contr-estab.nr-dia-min              = i-nr-dia-min    
                       af-item-contr-estab.log-considera-qtd-receb = lg-qtd-receb    
                       af-item-contr-estab.log-considera-val-receb = lg-val-receb    
                       af-item-contr-estab.pct-qtd-min             = de-pct-qtd-min  
                       af-item-contr-estab.pct-qtd-max             = de-pct-qtd-max  
                       af-item-contr-estab.pct-val-min             = de-pct-val-min  
                       af-item-contr-estab.pct-val-max             = de-pct-val-max. 
            END.

            ASSIGN i-seq = 10
                   i-item-estab = i-item-estab + 1.

            FOR EACH tt-controle WHERE
                     tt-controle.ep-codigo = i-ep-codigo-usuario NO-LOCK:
                
                CREATE af-item-contr-estab-form.
                ASSIGN af-item-contr-estab-form.ep-codigo        = i-ep-codigo-usuario
                       af-item-contr-estab-form.it-codigo        = item.it-codigo
                       af-item-contr-estab-form.cod-emitente     = emitente.cod-emitente
                       af-item-contr-estab-form.cod-estabel      = estabelec.cod-estabel
                       af-item-contr-estab-form.seq              = i-seq
                       af-item-contr-estab-form.percentual       = tt-controle.percentual
                       af-item-contr-estab-form.nr-controle      = tt-controle.nr-controle
                       af-item-contr-estab-form.nr-versao        = tt-param.nr-versao
                       af-item-contr-estab-form.dt-implantacao   = TODAY
                       af-item-contr-estab-form.cod-grp-resp     = tt-controle.cod-grp-resp
                       af-item-contr-estab-form.log-per-variavel = tt-controle.log-per-variavel    
                       af-item-contr-estab-form.dt-ult-aval      = tt-controle.dt-ult-aval    
                       af-item-contr-estab-form.dt-prox-aval     = tt-controle.dt-prox-aval   
                       af-item-contr-estab-form.ind-tipo-periodo = tt-controle.ind-tipo-periodo
                       i-seq = i-seq + 10. 
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-cria-parametros:

    FIND FIRST af-grp-avaliacao WHERE 
               af-grp-avaliacao.cod-grp-avaliacao = tt-param.cod-grp-aval            AND 
               af-grp-avaliacao.nr-versao         = tt-param.nr-versao-grp-avaliacao NO-LOCK NO-ERROR.
    IF AVAIL af-grp-avaliacao THEN DO:
        ASSIGN de-demerito    = af-grp-avaliacao.demerito                                   
               i-nr-dia-max   = af-grp-avaliacao.nr-dia-max                                 
               i-nr-dia-min   = af-grp-avaliacao.nr-dia-min                                 
               lg-qtd-receb   = af-grp-avaliacao.log-considera-qtd-receb       
               lg-val-receb   = af-grp-avaliacao.log-considera-val-receb       
               de-pct-qtd-min = af-grp-avaliacao.pct-qtd-min                               
               de-pct-qtd-max = af-grp-avaliacao.pct-qtd-max                               
               de-pct-val-min = af-grp-avaliacao.pct-val-min                               
               de-pct-val-max = af-grp-avaliacao.pct-val-max.                              
    END.

    FOR EACH tt-digita:                                                    
        FOR FIRST af-controle WHERE 
                  af-controle.ep-codigo   = i-ep-codigo-usuario   AND
                  af-controle.nr-controle = tt-digita.nr-controle NO-LOCK: 

            CREATE tt-controle.
            BUFFER-COPY af-controle TO tt-controle.
            ASSIGN tt-controle.percentual   = tt-digita.percentual.

            IF tt-digita.cod-grp-responsavel <> "":U THEN
               ASSIGN tt-controle.cod-grp-resp = tt-digita.cod-grp-responsavel.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-leitura-criacao-por-cotacao:
/*------------------------------------------------------------------------------
Purpose: Realiza a leitura dos registros de cota‡Æo para verificar os relacionamentos
         que devem ser gerados.
Parameters: 
Notes: 
------------------------------------------------------------------------------*/
    block-cotacao:
    FOR EACH cotacao-item FIELDS (it-codigo cod-emitente)
        WHERE cotacao-item.data-cotacao >= tt-param.da-oc-ini 
          AND cotacao-item.data-cotacao <= tt-param.da-oc-fin
          AND cotacao-item.cod-emitente >= tt-param.cIniFornec  
          AND cotacao-item.cod-emitente <= tt-param.cEndFornec 
          AND cotacao-item.it-codigo    >= tt-param.cIniitem
          AND cotacao-item.it-codigo    <= tt-param.cEnditem
          AND cotacao-item.cot-aprovada NO-LOCK:

        /* Se o item e fornecedor j  foram verificados em outra cota‡Æo, nÆo h  necessidade de 
           continuar a execu‡Æo */
        IF CAN-FIND(FIRST tt-item-fornec-verificados 
                    WHERE tt-item-fornec-verificados.cod-emitente = cotacao-item.cod-emitente 
                      AND tt-item-fornec-verificados.it-codigo    = cotacao-item.it-codigo) THEN DO:
            NEXT.
        END.
        ELSE DO:
            CREATE tt-item-fornec-verificados.
            ASSIGN tt-item-fornec-verificados.cod-emitente = cotacao-item.cod-emitente
                   tt-item-fornec-verificados.it-codigo    = cotacao-item.it-codigo.
        END.

        IF tt-param.lapenasItemFornec THEN
            IF NOT CAN-FIND (FIRST item-fornec
                             WHERE item-fornec.it-codigo    = cotacao-item.it-codigo 
                               AND item-fornec.cod-emitente = cotacao-item.cod-emitente) THEN NEXT.

        FOR FIRST ITEM FIELDS (it-codigo fm-codigo cod-obsoleto) 
            WHERE ITEM.it-codigo = cotacao-item.it-codigo
             AND  ITEM.fm-codigo >= tt-param.cIniFamilia
             AND  ITEM.fm-codigo <= tt-param.cEndFamilia
             AND  item.ge-codigo >= tt-param.i-ge-codigo-ini
             AND  item.ge-codigo <= tt-param.i-ge-codigo-fim 
             AND  ITEM.data-implant >= tt-param.dtIniImplantItem
             AND  ITEM.data-implant <= tt-param.dtEndImplantItem NO-LOCK: 
            IF tt-param.l-item-ativo AND ITEM.cod-obsoleto <> 1 THEN NEXT block-cotacao.
         END.
        IF NOT AVAIL ITEM THEN NEXT.

        FOR FIRST emitente FIELDS (cod-emitente identific)
            WHERE emitente.cod-emitente  = cotacao-item.cod-emitente
              AND emitente.cod-gr-forn  >= tt-param.i-cod-gr-forn-ini
              AND emitente.cod-gr-forn  <= tt-param.i-cod-gr-forn-fim 
              AND emitente.data-implant >= tt-param.dtIniImplantForn
              AND emitente.data-implant  <= tt-param.dtEndImplantForn
              AND emitente.identific >= 2 NO-LOCK:
            IF tt-param.l-fornecedor-ativo THEN DO:
                FOR FIRST dist-emitente FIELDS (idi-sit-fornec)
                    WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK: 
                    IF dist-emitente.idi-sit-fornec <> 1 THEN DO: 
                        NEXT block-cotacao.
                    END.
                END.
                IF NOT AVAIL dist-emitente THEN DO: 
                    NEXT block-cotacao.
                END.
            END.
        END.
        IF NOT AVAIL emitente THEN NEXT.

        /* Inicio -- Projeto Internacional */
        RUN pi-acompanhar IN h-acomp (INPUT c-lbl-liter-emitente + ": " + STRING(emitente.cod-emitente) + " " + c-lbl-liter-item + ": " + ITEM.it-codigo).

        IF tt-param.lFamilia THEN
            RUN pi-cria-relac-familia.

        IF tt-param.lItem THEN
           RUN pi-cria-relac-item.

        IF tt-param.lItemEstab THEN
            RUN pi-cria-relac-item-estab.
    END.

    RETURN "OK":U.
END PROCEDURE.
