/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0502RP 2.00.00.010 } /*** "010010" 03/03/2025 09:10:31  ***/
/*****************************************************************************
**       PROGRAMA: AF0502
**       DATA....: Mar‡o de 2004    
**       OBJETIVO: Relat½rio de Notas
**       VERSAO..: 2.00.00.000 - Alan Koerbel
******************************************************************************/
{utp/ut-glob.i}
{afp/af0502.i} 
{afbo/boaf008.i1}
{include/i-epc200.i af0502rp} /* UPC */

def temp-table tt-raw-digita
    field raw-digita      as raw.

DEF INPUT PARAMETER raw-param AS raw no-undo.
DEF INPUT PARAMETER table FOR tt-raw-digita.

DEF NEW GLOBAL SHARED VAR i-num-ped-exec-rpw  AS INTEGER NO-UNDO.

DEFINE VAR i-plan-i4    AS INTEGER     NO-UNDO.

CREATE tt-param.
raw-transfer raw-param TO tt-param.

{include/i-rpvar.i}

FUNCTION fnUtLiter RETURNS CHARACTER
    (pLiteral AS CHARACTER) :
/*------------------------------------------------------------------------------
    Notes: Tradu‡Æo de label.  
------------------------------------------------------------------------------*/
   RUN utp/ut-liter.p (INPUT pLiteral, "*", "").

   RETURN RETURN-VALUE.
END FUNCTION.                 

FORM SKIP (2)
    "SELE€ÇO"                     AT  3 SKIP(1)
    tt-param.c-est-ini            COLON 24 "|<  >|" AT 53 tt-param.c-est-fim        NO-LABEL SKIP
    tt-param.i-emi-ini            COLON 24 "|<  >|" AT 53 tt-param.i-emi-fim        NO-LABEL SKIP
    tt-param.c-it-ini             COLON 24 "|<  >|" AT 53 tt-param.c-it-fim         NO-LABEL SKIP
    tt-param.i-nr-ini             COLON 24 "|<  >|" AT 53 tt-param.i-nr-fim         NO-LABEL SKIP
    tt-param.i-ano-ini            COLON 24 LABEL "Per¡odo"
    tt-param.c-des-per-ini        NO-LABEL "|<  >|" AT 53 tt-param.i-ano-fim NO-LABEL
    tt-param.c-des-per-fim        NO-LABEL SKIP
    tt-param.i-cod-gr-forn-ini    COLON 24 "|<  >|" AT 53 tt-param.i-cod-gr-forn-fim NO-LABEL SKIP
    tt-param.c-fm-codigo-ini      COLON 24 "|<  >|" AT 53 tt-param.c-fm-codigo-fim NO-LABEL SKIP
    tt-param.i-ge-codigo-ini      COLON 24 "|<  >|" AT 53 tt-param.i-ge-codigo-fim NO-LABEL SKIP
    tt-param.c-cod-grp-aval-ini   COLON 24 "|<  >|" AT 53 tt-param.c-cod-grp-aval-fim NO-LABEL SKIP
    tt-param.c-cod-grp-resp-ini   COLON 24 "|<  >|" AT 53 tt-param.c-cod-grp-resp-fim NO-LABEL SKIP
    skip(2)
    "PAR¶METROS"               AT  3  SKIP(1)
    tt-param.l-detalha-controle-fornecedor  COLON  48
    tt-param.l-detalha-itens                COLON  48
    tt-param.l-detalha-controle-item        COLON  48
    tt-param.l-salta-pagina-per-est         COLON  48
    tt-param.l-salta-pagina-forn            COLON  48
    tt-param.l-gera-arquivo-excel           COLON  48 
    tt-param.l-gera-arquivo-texto           COLON  48 SKIP(1)
    TT-PARAM.c-filtro                       COLON  48 
    tt-param.i-melhor-pior                  colon  48
    skip(2)
    "CLASSIFICA€ÇO"           AT  3  SKIP(1)
    tt-param.desc-classifica colon 24
    
    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).

DEF VAR h-acomp          AS HANDLE     NO-UNDO.
def var h-boaf008        as handle     no-undo.
def var da-dt-ini        as date       no-undo.
def var da-dt-fim        as date       no-undo.
def var c-desc-item      as char       no-undo.
def var c-dt-indice-ini  as char format "99/9999" no-undo.
def var c-dt-indice-fim  as char format "99/9999" no-undo.
def var c-arquivo        as char format "x(20)" no-undo.
def buffer b-tt-notas  for tt-notas.
def buffer b1-tt-notas for tt-notas.
def buffer b-af-contr-indice-mov for af-contr-indice-mov.

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format 'x(132)':U
    index editor-id is primary unique 
          linha.

{utp/utapi013.i}



{include/pi-edit.i} 

FORM tt-editor.conteudo AT 20 FORMAT "x(90)"
     WITH NO-BOX WIDTH 132 CENTERED NO-LABEL DOWN FRAME f-narrativa STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-narrativa:HANDLE).


run afbo/boaf008.p persistent set h-boaf008.

form "----------" tt-notas.ano-avaliacao label "Per¡odo"
     tt-notas.des-periodo-aval NO-LABEL
     c-dt-indice-ini NO-LABEL " A "
     c-dt-indice-fim NO-LABEL
     space(3) tt-notas.cod-estabel label "Estab"
     estabelec.nome  NO-LABEL " ---------------"
     with stream-io down width 132 no-box side-labels frame f-est-per.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-est-per:HANDLE).


form space(5) tt-notas.cod-emitente " - " tt-notas.nome-emit no-label
     tt-notas.nota label "Nota"with stream-io down width 132 no-box side-labels frame f-forn.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-forn:HANDLE).


form space(14) tt-notas.nr-controle
      tt-notas.descricao
      tt-notas.cod-grp-resp
      tt-notas.usuar-alter COLUMN-LABEL "Usu rio"
      tt-notas.indice label "Öndice"
      tt-notas.percentual label "%"
      tt-notas.nota label "Nota"
     with stream-io down width 132 no-box frame f-forn-contr.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-forn-contr:HANDLE).


form space(14) tt-notas.it-codigo
     tt-notas.desc-item
     tt-notas.nota label "Nota"
     with stream-io down width 132 no-box frame f-forn-item.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-forn-item:HANDLE).


form space(27) tt-notas.nr-controle
     tt-notas.descricao
     tt-notas.cod-grp-resp
     tt-notas.usuar-alter COLUMN-LABEL "Usu rio"
     tt-notas.indice label "Öndice"
     tt-notas.percentual label "%"
     tt-notas.nota label "Nota"
     with stream-io down width 132 no-box frame f-detalhe.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-detalhe:HANDLE).


form af-contr-indice-mov.dt-movto
     af-contr-indice-mov.serie-docto
     af-contr-indice-mov.nro-docto
     af-contr-indice-mov.nat-operacao
     af-contr-indice-mov.sequencia
     af-contr-indice-mov.nr-ficha
     af-contr-indice-mov.lote FORMAT "X(10)"
     af-contr-indice-mov.demerito
     af-contr-indice-mov.num-pedido
     af-contr-indice-mov.numero-ordem 
     af-contr-indice-mov.parcela 
     af-contr-indice-mov.un SKIP
     af-contr-indice-mov.qtd-apr
     af-contr-indice-mov.qtd-con
     af-contr-indice-mov.qtd-rej
     af-contr-indice-mov.qtd-per
     af-contr-indice-mov.qtd-rec
     with stream-io down width 109 no-box frame f-documentos-qualidade-entrada.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-documentos-qualidade-entrada:HANDLE).


form af-contr-indice-mov.dt-movto
     af-contr-indice-mov.serie-docto
     af-contr-indice-mov.nro-docto
     af-contr-indice-mov.nat-operacao
     af-contr-indice-mov.sequencia
     af-contr-indice-mov.qtd-dev
     af-contr-indice-mov.qtd-dev-cq
     af-contr-indice-mov.un
     af-contr-indice-mov.nr-ficha
     af-contr-indice-mov.lote FORMAT "X(10)"
     af-contr-indice-mov.num-pedido
     with stream-io down width 132 no-box frame f-documentos-qualidade-devolucao.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-documentos-qualidade-devolucao:HANDLE).


form space(19) af-contr-indice-mov.dt-movto
     af-contr-indice-mov.num-pedido
     af-contr-indice-mov.numero-ordem 
     af-contr-indice-mov.parcela 
     af-contr-indice-mov.qtd-parcela
     af-contr-indice-mov.preco-unit-ord
     af-contr-indice-mov.un 
     af-contr-indice-mov.correto format "Sim/NÆo"
     with stream-io down width 132 no-box frame f-documentos-quantidade-parcela.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-documentos-quantidade-parcela:HANDLE).



form space(19) b-af-contr-indice-mov.dt-movto
      b-af-contr-indice-mov.serie-docto
      b-af-contr-indice-mov.nro-docto
      b-af-contr-indice-mov.nat-operacao
      b-af-contr-indice-mov.sequencia
      b-af-contr-indice-mov.qtd-rec
      b-af-contr-indice-mov.preco-unit-rec
      b-af-contr-indice-mov.un
      with stream-io down width 132 no-box frame f-documentos-quantidade-recebimento.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-documentos-quantidade-recebimento:HANDLE).



form space(19) af-contr-indice-mov.dt-movto
     af-contr-indice-mov.num-pedido
     af-contr-indice-mov.numero-ordem 
     af-contr-indice-mov.parcela 
     af-contr-indice-mov.preco-unit-ord
     af-contr-indice-mov.qtd-parcela
     af-contr-indice-mov.un 
     af-contr-indice-mov.correto format "Sim/NÆo"
     with stream-io down width 132 no-box frame f-documentos-preco-parcela.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-documentos-preco-parcela:HANDLE).



form space(19) b-af-contr-indice-mov.dt-movto
      b-af-contr-indice-mov.serie-docto
      b-af-contr-indice-mov.nro-docto
      b-af-contr-indice-mov.nat-operacao
      b-af-contr-indice-mov.sequencia
      b-af-contr-indice-mov.preco-unit-rec
      b-af-contr-indice-mov.qtd-rec
      b-af-contr-indice-mov.un
      with stream-io down width 132 no-box frame f-documentos-preco-recebimento.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-documentos-preco-recebimento:HANDLE).


form space(19) af-contr-indice-mov.dt-movto
     af-contr-indice-mov.num-pedido
     af-contr-indice-mov.numero-ordem 
     af-contr-indice-mov.parcela 
     af-contr-indice-mov.qtd-parcela
     af-contr-indice-mov.preco-unit-ord
     af-contr-indice-mov.un 
     af-contr-indice-mov.correto format "Sim/NÆo"
     with stream-io down width 132 no-box frame f-documentos-data-parcela.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-documentos-data-parcela:HANDLE).



form space(19) b-af-contr-indice-mov.dt-movto
      b-af-contr-indice-mov.serie-docto
      b-af-contr-indice-mov.nro-docto
      b-af-contr-indice-mov.nat-operacao
      b-af-contr-indice-mov.sequencia
      b-af-contr-indice-mov.qtd-rec
      b-af-contr-indice-mov.preco-unit-rec
      b-af-contr-indice-mov.un
      with stream-io down width 132 no-box frame f-documentos-data-recebimento.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-documentos-data-recebimento:HANDLE).


{include/i-rpout.i}
{include/i-rpcab.i}

ASSIGN c-programa 	  = "AF0502RP":U
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-sistema      = "AFP":U
       c-titulo-relat = "Desempenho dos Fornecedores".

FIND empresa WHERE empresa.ep-codigo   = i-ep-codigo-usuario NO-LOCK NO-ERROR.
IF AVAIL empresa THEN ASSIGN c-empresa = empresa.razao-social.

RUN utp/ut-acomp.p persistent set h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Processando ...").
/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Carregando_informa‡äes" *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + " ...").

run getNotas in h-boaf008 (input tt-param.c-est-ini,
                           input tt-param.c-est-fim,
                           input tt-param.i-emi-ini, 
                           input tt-param.i-emi-fim,
                           input tt-param.c-it-ini,  
                           input tt-param.c-it-fim,
                           input tt-param.i-nr-ini,
                           input tt-param.i-nr-fim, 
                           input tt-param.i-ano-ini,  
                           input tt-param.c-des-per-ini,  
                           INPUT tt-param.i-ano-fim,
                           INPUT tt-param.c-des-per-fim,
                           INPUT tt-param.c-cod-grp-aval-ini,
                           INPUT tt-param.c-cod-grp-aval-fim,
                           INPUT tt-param.c-cod-grp-resp-ini,
                           INPUT tt-param.c-cod-grp-resp-fim,
                           input tt-param.i-cod-gr-forn-ini, 
                           input tt-param.i-cod-gr-forn-fim,
                           input tt-param.c-fm-codigo-ini,
                           input tt-param.c-fm-codigo-fim,
                           input tt-param.i-ge-codigo-ini, 
                           input tt-param.i-ge-codigo-fim,
                           input tt-param.i-filtro,
                           input tt-param.i-melhor-pior,
                           input 1,
                           output table tt-notas). 

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Imprimindo" *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + " ...").

if not tt-param.l-gera-arquivo-excel AND NOT tt-param.l-gera-arquivo-texto then do:
    if tt-param.classifica = 1 then do:
       {afp/af0502.i1 "by tt-notas.cod-emitente" }
    end.
    else if tt-param.classifica = 2 then do:
       {afp/af0502.i1 "by tt-notas.nome-emit"}
    end.
    else if tt-param.classifica = 3 then do:
       {afp/af0502.i1 "by tt-notas.nota desc" "by tt-notas.cod-emitente" }
    end.
    else if tt-param.classifica = 4 then do:
       {afp/af0502.i1 "by tt-notas.nota" "by tt-notas.cod-emitente" }
    end.
end.
else do:
  IF tt-param.l-gera-arquivo-texto THEN DO:
    if tt-param.classifica = 1 then do:
       {afp/af0502.i2 "by tt-notas.cod-emitente" }
    end.
    else if tt-param.classifica = 2 then do:
       {afp/af0502.i2 "by tt-notas.nome-emit"}
    end.
    else if tt-param.classifica = 3 then do:
       {afp/af0502.i2 "by tt-notas.nota desc" "by tt-notas.cod-emitente" }
    end.
    else if tt-param.classifica = 4 then do:
       {afp/af0502.i2 "by tt-notas.nota" "by tt-notas.cod-emitente" }
    end.
  END.
  IF tt-param.l-gera-arquivo-excel THEN DO:
     RUN pi-exporta-excel.
  END.
end.

if NOT tt-param.l-gera-arquivo-texto then do:


    PAGE.
    DISPLAY tt-param.c-est-ini    
            tt-param.c-est-fim 
            tt-param.i-emi-ini 
            tt-param.i-emi-fim
            tt-param.c-it-ini    
            tt-param.c-it-fim 
            tt-param.i-nr-ini   
            tt-param.i-nr-fim 
            tt-param.i-ano-ini
            tt-param.i-ano-fim
            tt-param.c-des-per-ini
            tt-param.c-des-per-fim
            tt-param.c-cod-grp-aval-ini
            tt-param.c-cod-grp-aval-fim
            tt-param.c-cod-grp-resp-ini
            tt-param.c-cod-grp-resp-fim
            tt-param.i-cod-gr-forn-ini 
            tt-param.i-cod-gr-forn-fim
            tt-param.c-fm-codigo-ini
            tt-param.c-fm-codigo-fim
            tt-param.i-ge-codigo-ini 
            tt-param.i-ge-codigo-fim 
            tt-param.l-detalha-controle-fornecedor 
            tt-param.l-detalha-itens   
            tt-param.l-detalha-controle-item 
            tt-param.l-salta-pagina-per-est
            tt-param.l-salta-pagina-forn   
            tt-param.l-gera-arquivo-excel 
            tt-param.desc-classifica 
            tt-param.c-filtro
            tt-param.i-melhor-pior
            tt-param.l-gera-arquivo-texto
            WITH  FRAME f-param-sel.
    
    ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}
           c-arquivo = tt-param.arquivo.
    
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-impressao AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "IMPRESSÇO" *}
    ASSIGN c-lbl-liter-impressao = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-arquivo AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Arquivo" *}
    ASSIGN c-lbl-liter-arquivo = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Usu rio" *}
    ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
    PUT UNFORMATTED SKIP(2)
        c-lbl-liter-impressao  AT 3 skip(1)
        c-lbl-liter-arquivo    AT 17 ": " c-destino " - " c-arquivo
        c-lbl-liter-usuario    AT 17 ": " tt-param.usuario.
end.

{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.

delete procedure h-boaf008.

RETURN "OK":U.



PROCEDURE pi-detalha-documentos:


                        FOR FIRST af-controle FIELDS(padrao descricao nr-controle)
                            WHERE af-controle.ep-codigo = i-ep-codigo-usuario
                            AND   af-controle.nr-controle = b1-tt-notas.nr-controle
                            NO-LOCK: END.
                        if af-controle.descricao = "Qualidade" AND af-controle.padrao then do:
                           put skip(1).
                           /* Inicio -- Projeto Internacional */
                           DEFINE VARIABLE c-lbl-liter-narrativa-indice AS CHARACTER FORMAT "X(92)" NO-UNDO.
                           {utp/ut-liter.i "Narrativa_Öndice" *}
                           ASSIGN c-lbl-liter-narrativa-indice = TRIM(RETURN-VALUE).
                           PUT space(19) "------------------------------------ " + c-lbl-liter-narrativa-indice + " ------------------------------------" skip.
                           RUN pi-print-editor (INPUT b1-tt-notas.narrativa, INPUT 90).   
                           FOR EACH tt-editor:
                              DISP tt-editor.conteudo WITH FRAME f-narrativa.
                              DOWN WITH FRAME f-narrativa.
                           END.

                           IF CAN-FIND (FIRST af-contr-indice-mov 
                              where af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                and af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                and af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                and af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                and af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                AND af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                AND af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim
                                and af-contr-indice-mov.tipo-trans = 1 no-lock) THEN DO:
                                put skip(1).
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-notas-fiscais-de-entrada AS CHARACTER FORMAT "X(109)" NO-UNDO.
                                {utp/ut-liter.i "Notas_Fiscais_de_Entrada" *}
                                ASSIGN c-lbl-liter-notas-fiscais-de-entrada = TRIM(RETURN-VALUE).
                                put "---------------------------------------- " + c-lbl-liter-notas-fiscais-de-entrada + " -----------------------------------------" skip.
                           END.
                           for each af-contr-indice-mov 
                              where af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                and af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                and af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                and af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                and af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                and af-contr-indice-mov.tipo-trans = 1 
                                AND af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                AND af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim no-lock:
                                disp af-contr-indice-mov.dt-movto
                                     af-contr-indice-mov.serie-docto
                                     af-contr-indice-mov.nro-docto
                                     af-contr-indice-mov.nat-operacao
                                     af-contr-indice-mov.sequencia
                                     af-contr-indice-mov.nr-ficha
                                     af-contr-indice-mov.qtd-apr
                                     af-contr-indice-mov.qtd-con
                                     af-contr-indice-mov.qtd-rej
                                     af-contr-indice-mov.qtd-per
                                     af-contr-indice-mov.qtd-rec
                                     af-contr-indice-mov.un
                                     af-contr-indice-mov.lote
                                     af-contr-indice-mov.demerito
                                     af-contr-indice-mov.num-pedido
                                     af-contr-indice-mov.numero-ordem 
                                     af-contr-indice-mov.parcela  
                                     with frame f-documentos-qualidade-entrada.
                                     down with frame f-documentos-qualidade-entrada.
                           end.
                           IF CAN-FIND (FIRST af-contr-indice-mov 
                              where af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                and af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                and af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                and af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                and af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                and af-contr-indice-mov.tipo-trans = 2 
                                AND af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                AND af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim) THEN  DO:
                                put skip(1).
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-notas-fiscais-de-devolucao AS CHARACTER FORMAT "X(124)" NO-UNDO.
                                {utp/ut-liter.i "Notas_Fiscais_de_Devolu‡Æo" *}
                                ASSIGN c-lbl-liter-notas-fiscais-de-devolucao = TRIM(RETURN-VALUE).
                                put "----------------------------------------------- " + c-lbl-liter-notas-fiscais-de-devolucao + " -----------------------------------------------" skip.
                           END.
                           for each af-contr-indice-mov 
                              where af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                and af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                and af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                and af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                and af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                and af-contr-indice-mov.tipo-trans = 2 
                                AND af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                AND af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim no-lock:
                                disp af-contr-indice-mov.dt-movto
                                     af-contr-indice-mov.serie-docto
                                     af-contr-indice-mov.nro-docto
                                     af-contr-indice-mov.nat-operacao
                                     af-contr-indice-mov.sequencia
                                     af-contr-indice-mov.qtd-dev
                                     af-contr-indice-mov.qtd-dev-cq
                                     af-contr-indice-mov.un
                                     af-contr-indice-mov.nr-ficha
                                     af-contr-indice-mov.lote
                                     af-contr-indice-mov.num-pedido
                                     with frame f-documentos-qualidade-devolucao.
                                     down with frame f-documentos-qualidade-devolucao.
                           end.
                           put skip(2).
                       end.
                       else if af-controle.descricao = "Quantidade" AND af-controle.padrao then do:
                           put skip(1).
                           /* Inicio -- Projeto Internacional */
                           DEFINE VARIABLE c-lbl-liter-narrativa-indice-2 AS CHARACTER FORMAT "X(92)" NO-UNDO.
                           {utp/ut-liter.i "Narrativa_Öndice" *}
                           ASSIGN c-lbl-liter-narrativa-indice-2 = TRIM(RETURN-VALUE).
                           PUT space(19) "------------------------------------ " + c-lbl-liter-narrativa-indice-2 + " ------------------------------------" skip.
                           RUN pi-print-editor (INPUT b1-tt-notas.narrativa, INPUT 90).   
                           FOR EACH tt-editor:
                              DISP tt-editor.conteudo WITH FRAME f-narrativa.
                              DOWN WITH FRAME f-narrativa.
                           END.
   
                           for each af-contr-indice-mov 
                              where af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                and af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                and af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                and af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                and af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                and af-contr-indice-mov.tipo-trans = 1 
                                AND af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                AND af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim no-lock:
                                put skip(1).
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-parcela AS CHARACTER FORMAT "X(80)" NO-UNDO.
                                {utp/ut-liter.i "Parcela" *}
                                ASSIGN c-lbl-liter-parcela = TRIM(RETURN-VALUE).
                                put SPACE(19) "---------------------------------- " + c-lbl-liter-parcela + " -----------------------------------" skip.
                                disp af-contr-indice-mov.dt-movto
                                     af-contr-indice-mov.num-pedido
                                     af-contr-indice-mov.numero-ordem 
                                     af-contr-indice-mov.parcela 
                                     af-contr-indice-mov.qtd-parcela
                                     af-contr-indice-mov.preco-unit-ord
                                     af-contr-indice-mov.un 
                                     af-contr-indice-mov.correto
                                     with frame f-documentos-quantidade-parcela.
                                     down with frame f-documentos-quantidade-parcela.
                                     
                                IF CAN-FIND (FIRST b-af-contr-indice-mov 
                                   where b-af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                     and b-af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                     and b-af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                     and b-af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                     and b-af-contr-indice-mov.nr-controle = af-controle.nr-controle
                                     and b-af-contr-indice-mov.tipo-trans = 2
                                     and b-af-contr-indice-mov.numero-ordem = af-contr-indice-mov.numero-ordem 
                                     and b-af-contr-indice-mov.parcela = af-contr-indice-mov.parcela 
                                     AND b-af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                     AND b-af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim NO-LOCK) THEN DO:
                                     PUT skip(1).
                                     /* Inicio -- Projeto Internacional */
                                     DEFINE VARIABLE c-lbl-liter-recebimentos AS CHARACTER FORMAT "X(91)" NO-UNDO.
                                     {utp/ut-liter.i "Recebimentos" *}
                                     ASSIGN c-lbl-liter-recebimentos = TRIM(RETURN-VALUE).
                                     PUT SPACE(19) "------------------------------------- " + c-lbl-liter-recebimentos + " --------------------------------------" skip.
                                END.
                                for each b-af-contr-indice-mov 
                                   where b-af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                     and b-af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                     and b-af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                     and b-af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                     and b-af-contr-indice-mov.nr-controle = af-controle.nr-controle
                                     and b-af-contr-indice-mov.tipo-trans = 2
                                     and b-af-contr-indice-mov.numero-ordem = af-contr-indice-mov.numero-ordem 
                                     and b-af-contr-indice-mov.parcela = af-contr-indice-mov.parcela 
                                     AND b-af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                     AND b-af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim no-lock:
                                     disp b-af-contr-indice-mov.dt-movto
                                          b-af-contr-indice-mov.serie-docto
                                          b-af-contr-indice-mov.nro-docto
                                          b-af-contr-indice-mov.nat-operacao
                                          b-af-contr-indice-mov.sequencia
                                          b-af-contr-indice-mov.qtd-rec
                                          b-af-contr-indice-mov.preco-unit-rec
                                          b-af-contr-indice-mov.un
                                          with frame f-documentos-quantidade-recebimento.
                                          down with frame f-documentos-quantidade-recebimento.
                                end.
                           end.
                           
                           put skip(2).
                       end.
                       else if af-controle.descricao = "Pre‡o" AND af-controle.padrao then do:
                           put skip(1).
                           /* Inicio -- Projeto Internacional */
                           DEFINE VARIABLE c-lbl-liter-narrativa-indice-3 AS CHARACTER FORMAT "X(92)" NO-UNDO.
                           {utp/ut-liter.i "Narrativa_Öndice" *}
                           ASSIGN c-lbl-liter-narrativa-indice-3 = TRIM(RETURN-VALUE).
                           PUT space(19) "------------------------------------ " + c-lbl-liter-narrativa-indice-3 + " ------------------------------------" skip.
                           RUN pi-print-editor (INPUT b1-tt-notas.narrativa, INPUT 90).   
                           FOR EACH tt-editor:
                              DISP tt-editor.conteudo WITH FRAME f-narrativa.
                              DOWN WITH FRAME f-narrativa.
                           END.
   
                           for each af-contr-indice-mov 
                              where af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                and af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                and af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                and af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                and af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                and af-contr-indice-mov.tipo-trans = 1 
                                AND af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                AND af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim no-lock:
                                put skip(1).
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-parcela-2 AS CHARACTER FORMAT "X(80)" NO-UNDO.
                                {utp/ut-liter.i "Parcela" *}
                                ASSIGN c-lbl-liter-parcela-2 = TRIM(RETURN-VALUE).
                                put space(19) "---------------------------------- " + c-lbl-liter-parcela-2 + " -----------------------------------" skip.
                                disp af-contr-indice-mov.dt-movto
                                     af-contr-indice-mov.num-pedido
                                     af-contr-indice-mov.numero-ordem 
                                     af-contr-indice-mov.parcela 
                                     af-contr-indice-mov.qtd-parcela
                                     af-contr-indice-mov.preco-unit-ord
                                     af-contr-indice-mov.un 
                                     af-contr-indice-mov.correto
                                     with frame f-documentos-preco-parcela.
                                     down with frame f-documentos-preco-parcela.
                                     
                                IF CAN-FIND (FIRST b-af-contr-indice-mov 
                                   where b-af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                     and b-af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                     and b-af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                     and b-af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                     and b-af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                     and b-af-contr-indice-mov.tipo-trans = 2
                                     and b-af-contr-indice-mov.numero-ordem = af-contr-indice-mov.numero-ordem 
                                     and b-af-contr-indice-mov.parcela = af-contr-indice-mov.parcela 
                                     AND b-af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                     AND b-af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim NO-LOCK) THEN DO:
                                     put skip(1).
                                     /* Inicio -- Projeto Internacional */
                                     DEFINE VARIABLE c-lbl-liter-recebimentos-2 AS CHARACTER FORMAT "X(91)" NO-UNDO.
                                     {utp/ut-liter.i "Recebimentos" *}
                                     ASSIGN c-lbl-liter-recebimentos-2 = TRIM(RETURN-VALUE).
                                     put SPACE(19) "------------------------------------- " + c-lbl-liter-recebimentos-2 + " --------------------------------------" skip.
                                END.
                                for each b-af-contr-indice-mov 
                                   where b-af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                     and b-af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                     and b-af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                     and b-af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                     and b-af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                     and b-af-contr-indice-mov.tipo-trans = 2
                                     and b-af-contr-indice-mov.numero-ordem = af-contr-indice-mov.numero-ordem 
                                     and b-af-contr-indice-mov.parcela = af-contr-indice-mov.parcela 
                                     AND b-af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                     AND b-af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim NO-LOCK:
                                     disp b-af-contr-indice-mov.dt-movto
                                          b-af-contr-indice-mov.serie-docto
                                          b-af-contr-indice-mov.nro-docto
                                          b-af-contr-indice-mov.nat-operacao
                                          b-af-contr-indice-mov.sequencia
                                          b-af-contr-indice-mov.qtd-rec
                                          b-af-contr-indice-mov.preco-unit-rec
                                          b-af-contr-indice-mov.un
                                          with frame f-documentos-preco-recebimento.
                                          down with frame f-documentos-preco-recebimento.
                                end.
                           end.
                           
                           put skip(2).
                       end.
                       else if af-controle.descricao = "Data Entrega" AND af-controle.padrao then do:
                           put skip(1).
                           /* Inicio -- Projeto Internacional */
                           DEFINE VARIABLE c-lbl-liter-narrativa-indice-4 AS CHARACTER FORMAT "X(92)" NO-UNDO.
                           {utp/ut-liter.i "Narrativa_Öndice" *}
                           ASSIGN c-lbl-liter-narrativa-indice-4 = TRIM(RETURN-VALUE).
                           PUT space(19) "------------------------------------ " + c-lbl-liter-narrativa-indice-4 + " ------------------------------------" skip.
                           RUN pi-print-editor (INPUT b1-tt-notas.narrativa, INPUT 90).   
                           FOR EACH tt-editor:
                              DISP tt-editor.conteudo WITH FRAME f-narrativa.
                              DOWN WITH FRAME f-narrativa.
                           END.
   
                           for each af-contr-indice-mov 
                              where af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                and af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                and af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                and af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                and af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                and af-contr-indice-mov.tipo-trans = 1 
                                AND af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                AND af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim no-lock:
                                put skip(1).
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-parcela-3 AS CHARACTER FORMAT "X(80)" NO-UNDO.
                                {utp/ut-liter.i "Parcela" *}
                                ASSIGN c-lbl-liter-parcela-3 = TRIM(RETURN-VALUE).
                                put space(19) "---------------------------------- " + c-lbl-liter-parcela-3 + " -----------------------------------" skip.
                                disp af-contr-indice-mov.dt-movto
                                     af-contr-indice-mov.num-pedido
                                     af-contr-indice-mov.numero-ordem 
                                     af-contr-indice-mov.parcela 
                                     af-contr-indice-mov.qtd-parcela
                                     af-contr-indice-mov.preco-unit-ord
                                     af-contr-indice-mov.un 
                                     af-contr-indice-mov.correto
                                     with frame f-documentos-data-parcela.
                                     down with frame f-documentos-data-parcela.
                                     
                                IF CAN-FIND (FIRST b-af-contr-indice-mov 
                                   where b-af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                     and b-af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                     and b-af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                     and b-af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                     and b-af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                     and b-af-contr-indice-mov.tipo-trans = 2
                                     and b-af-contr-indice-mov.numero-ordem = af-contr-indice-mov.numero-ordem 
                                     and b-af-contr-indice-mov.parcela = af-contr-indice-mov.parcela 
                                     AND b-af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                     AND b-af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim NO-LOCK) THEN DO:
                                     put skip(1).
                                     /* Inicio -- Projeto Internacional */
                                     DEFINE VARIABLE c-lbl-liter-recebimentos-3 AS CHARACTER FORMAT "X(91)" NO-UNDO.
                                     {utp/ut-liter.i "Recebimentos" *}
                                     ASSIGN c-lbl-liter-recebimentos-3 = TRIM(RETURN-VALUE).
                                     put space(19) "------------------------------------- " + c-lbl-liter-recebimentos-3 + " --------------------------------------" skip.
                                END.

                                for each b-af-contr-indice-mov 
                                   where b-af-contr-indice-mov.ep-codigo = i-ep-codigo-usuario
                                     and b-af-contr-indice-mov.cod-estabel = b1-tt-notas.cod-estabel
                                     and b-af-contr-indice-mov.cod-emitente = b1-tt-notas.cod-emitente
                                     and b-af-contr-indice-mov.it-codigo = b1-tt-notas.it-codigo 
                                     and b-af-contr-indice-mov.nr-controle = af-controle.nr-controle 
                                     and b-af-contr-indice-mov.tipo-trans = 2
                                     and b-af-contr-indice-mov.numero-ordem = af-contr-indice-mov.numero-ordem 
                                     and b-af-contr-indice-mov.parcela = af-contr-indice-mov.parcela 
                                     AND b-af-contr-indice-mov.dt-movto >= b1-tt-notas.dt-indice-ini
                                     AND b-af-contr-indice-mov.dt-movto <= b1-tt-notas.dt-indice-fim no-lock:
                                     disp b-af-contr-indice-mov.dt-movto
                                          b-af-contr-indice-mov.serie-docto
                                          b-af-contr-indice-mov.nro-docto
                                          b-af-contr-indice-mov.nat-operacao
                                          b-af-contr-indice-mov.sequencia
                                          b-af-contr-indice-mov.qtd-rec
                                          b-af-contr-indice-mov.preco-unit-rec
                                          b-af-contr-indice-mov.un
                                          with frame f-documentos-data-recebimento.
                                          down with frame f-documentos-data-recebimento.
                                end.
                           end.
                           
                           put skip(2).
                       end.

                        for each tt-epc where tt-epc.cod-event = "ponto-7":U: 
                          delete tt-epc.
                        end.

                        create tt-epc.
                        assign tt-epc.cod-event     = "ponto-7":U
                               tt-epc.val-parameter = STRING(b1-tt-notas.nr-controle) + ";"  +
                                                      b1-tt-notas.cod-estabel + ";" +
                                                      STRING(b1-tt-notas.cod-emitente) + ";" +
                                                      b1-tt-notas.it-codigo + ";" +
                                                      STRING(b1-tt-notas.dt-indice-ini) + ";" +
                                                      STRING(b1-tt-notas.dt-indice-fim) + ";" +
                                                      b1-tt-notas.narrativa.
                        {include/i-epc201.i "ponto-7"}
END PROCEDURE.


PROCEDURE pi-exporta-excel:
   DEFINE VAR i-coluna AS INTEGER INIT 1.
   DEFINE VAR i-linha  AS INTEGER INIT 1.
   DEFINE VAR i-linha1 AS INTEGER INIT 1.
   DEFINE VAR i-linha2 AS INTEGER INIT 1.
   DEFINE VAR i-linha3 AS INTEGER INIT 1.
   DEFINE VAR i-plan   AS INTEGER INIT 1.
   DEFINE VAR i-cont   AS INTEGER INIT 1.
   DEFINE VAR i-plan-faixa AS INTEGER     NO-UNDO.
   def var l-european-format  as   logical                   no-undo.

   if session:numeric-format = "EUROPEAN":U then
      assign l-european-format = yes.
   else
      assign l-european-format = no.
   RUN utp/utapi013.p persistent set h-utapi013.
   /*SYSTEM-DIALOG PRINTER-SETUP.*/
   OS-DELETE VALUE(SESSION:TEMP-DIRECTORY + "AF0502.XLS").
   ASSIGN i-plan = 1.

   CREATE tt-planilha2.
   ASSIGN tt-planilha2.arquivo-num             = 1
          tt-planilha2.planilha-num            = 1
          tt-planilha2.planilha-nome           = fnUtLiter("Fornecedores")
          tt-planilha2.linhas-grade            = YES
          tt-planilha2.formatar-planilha       = NO
          tt-planilha2.largura-coluna          = 12.50
          tt-planilha2.formatar-faixa          = YES.

   CREATE tt-dados.
   ASSIGN tt-dados.arquivo-num          = 1
          tt-dados.planilha-num         = i-plan
          tt-dados.celula-coluna        = 1
          tt-dados.celula-linha         = 1
          tt-dados.celula-valor         = fnUtLiter("Estabelecimento")
          tt-dados.celula-fonte-negrito = YES.
          
   CREATE tt-dados.
   ASSIGN tt-dados.arquivo-num   = 1
          tt-dados.planilha-num  = i-plan
          tt-dados.celula-coluna = 2
          tt-dados.celula-linha  = 1
          tt-dados.celula-valor  = fnUtLiter("Per¡odo")
          tt-dados.celula-fonte-negrito = YES.
          
   CREATE tt-dados.
   ASSIGN tt-dados.arquivo-num   = 1
          tt-dados.planilha-num  = i-plan
          tt-dados.celula-coluna = 3
          tt-dados.celula-linha  = 1
          tt-dados.celula-valor  = fnUtLiter("Fornecedor")
          tt-dados.celula-fonte-negrito = YES. 
          
   CREATE tt-dados.
   ASSIGN tt-dados.arquivo-num   = 1
          tt-dados.planilha-num  = i-plan
          tt-dados.celula-coluna = 4
          tt-dados.celula-linha  = 1
          tt-dados.celula-valor  = fnUtLiter("Nome")
          tt-dados.celula-fonte-negrito = YES.
          
   CREATE tt-dados.
   ASSIGN tt-dados.arquivo-num   = 1
          tt-dados.planilha-num  = i-plan
          tt-dados.celula-coluna = 5
          tt-dados.celula-linha  = 1
          tt-dados.celula-valor  = fnUtLiter("Nota")
          tt-dados.celula-fonte-negrito = YES. 

   if tt-param.l-detalha-controle-fornecedor THEN DO: 
        ASSIGN i-plan = i-plan + 1.
        CREATE tt-planilha2.
        ASSIGN tt-planilha2.arquivo-num             = 1
               tt-planilha2.planilha-num            = i-plan
               tt-planilha2.planilha-nome           = fnUtLiter("Detalhes_Fornecedores")
               tt-planilha2.linhas-grade            = YES
               tt-planilha2.largura-coluna          = 12.50
               tt-planilha2.formatar-planilha       = NO
               tt-planilha2.formatar-faixa          = YES.
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num    = 1
               tt-dados.planilha-num   = i-plan
               tt-dados.celula-coluna  = 1
               tt-dados.celula-linha   = 1
               tt-dados.celula-valor   = fnUtLiter("Estabelecimento").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 2
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Per¡odo").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 3
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Fornecedor").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 4
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Nome").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 5
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Ponto_Controle").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 6
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Öndice").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 7
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Percentual").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 8
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Nota").
   END.
   if tt-param.l-detalha-itens THEN DO: 
       ASSIGN i-plan = i-plan + 1.
       CREATE tt-planilha2.
       ASSIGN tt-planilha2.arquivo-num             = 1
              tt-planilha2.planilha-num            = i-plan
              tt-planilha2.planilha-nome           = fnUtLiter("Itens")
              tt-planilha2.linhas-grade            = YES
              tt-planilha2.largura-coluna          = 12.50
              tt-planilha2.formatar-planilha       = NO
              tt-planilha2.formatar-faixa          = YES.
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num    = 1
               tt-dados.planilha-num   = i-plan
               tt-dados.celula-coluna  = 1
               tt-dados.celula-linha   = 1
               tt-dados.celula-valor   = fnUtLiter("Estabelecimento").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 2
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Per¡odo").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 3
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Fornecedor").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 4
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Nome").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 5
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Item").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 6
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  =  fnUtLiter("Descri‡Æo").
        CREATE tt-dados.

        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 7
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Nota").
   END.
   if tt-param.l-detalha-controle-item THEN do:
       ASSIGN i-plan = i-plan + 1.
       CREATE tt-planilha2.
       ASSIGN tt-planilha2.arquivo-num             = 1
              tt-planilha2.planilha-num            = i-plan
              tt-planilha2.planilha-nome           = fnUtLiter("Detalhes_Itens")
              tt-planilha2.linhas-grade            = YES
              tt-planilha2.largura-coluna          = 12.50
              tt-planilha2.formatar-planilha       = NO
              tt-planilha2.formatar-faixa          = YES.
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num    = 1
               tt-dados.planilha-num   = i-plan
               tt-dados.celula-coluna  = 1
               tt-dados.celula-linha   = 1
               tt-dados.celula-valor   = fnUtLiter("Estabelecimento").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 2
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Per¡odo").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 3
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Fornecedor").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 4
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Nome").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 5
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Item").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 6
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Descri‡Æo").
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 7
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Ponto_Controle").
        CREATE tt-dados.

        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 8
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Öndice").
        CREATE tt-dados.

        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 9
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Percentual").
        CREATE tt-dados.

        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = i-plan
               tt-dados.celula-coluna = 10
               tt-dados.celula-linha  = 1
               tt-dados.celula-valor  = fnUtLiter("Nota").

   END.
   CREATE tt-configuracao2.
   ASSIGN tt-configuracao2.versao-integracao   = 1
          tt-configuracao2.arquivo-num         = 1
          tt-configuracao2.arquivo             = SESSION:TEMP-DIRECTORY + "AF0502-" + REPLACE(c-seg-usuario,".","-") + "-" + REPLACE(STRING(TIME,"hh:mm:ss"),":","-")  + ".XLS"
          tt-configuracao2.total-planilhas     = i-plan
          tt-configuracao2.exibir-construcao   = NO
          tt-configuracao2.abrir-excel-termino = (i-num-ped-exec-rpw = 0) /* Abre planilha apenas se nÆo for rpw */
          tt-configuracao2.imprimir            = NO
          tt-configuracao2.orientacao          = 2.


   if tt-param.classifica = 1 then do:
      {afp/af0502.i4 "by tt-notas.cod-emitente" }
   end.
   else if tt-param.classifica = 2 then do:
      {afp/af0502.i4 "by tt-notas.nome-emit"}
   end.
   else if tt-param.classifica = 3 then do:
      {afp/af0502.i4 "by tt-notas.nota desc" "by tt-notas.cod-emitente" }
   end.
   else if tt-param.classifica = 4 then do:
      {afp/af0502.i4 "by tt-notas.nota" "by tt-notas.cod-emitente" }
   end.


   CREATE tt-formatar-faixa.
   ASSIGN tt-formatar-faixa.arquivo-num                  = 1
          tt-formatar-faixa.planilha-num                 = 1
          tt-formatar-faixa.faixa-dados                  = "A1:E1"       
          tt-formatar-faixa.faixa-fonte-cor              = 2
          tt-formatar-faixa.faixa-fonte-negrito          = YES
          tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
          tt-formatar-faixa.faixa-tipo-borda-sup         = 01
          tt-formatar-faixa.faixa-tipo-borda-inf         = 01
          tt-formatar-faixa.faixa-tipo-borda-esq         = 01
          tt-formatar-faixa.faixa-tipo-borda-dir         = 01
          tt-formatar-faixa.faixa-cor-interior           = 55.
 
   CREATE tt-formatar-faixa.
   ASSIGN tt-formatar-faixa.arquivo-num                  = 1
          tt-formatar-faixa.planilha-num                 = 1
          tt-formatar-faixa.faixa-dados                  = "A2:A" + string(i-linha)
          tt-formatar-faixa.faixa-fonte-cor              = 1
          tt-formatar-faixa.faixa-fonte-negrito          = NO
          tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
          tt-formatar-faixa.faixa-tipo-borda-sup         = 01
          tt-formatar-faixa.faixa-tipo-borda-inf         = 01
          tt-formatar-faixa.faixa-tipo-borda-esq         = 01
          tt-formatar-faixa.faixa-tipo-borda-dir         = 01
          tt-formatar-faixa.faixa-cor-interior           = 2.

   CREATE tt-formatar-faixa.
   ASSIGN tt-formatar-faixa.arquivo-num                  = 1
          tt-formatar-faixa.planilha-num                 = 1
          tt-formatar-faixa.faixa-dados                  = "B2:B" + string(i-linha)
          tt-formatar-faixa.faixa-fonte-cor              = 1
          tt-formatar-faixa.faixa-fonte-negrito          = NO
          tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
          tt-formatar-faixa.faixa-tipo-borda-sup         = 01
          tt-formatar-faixa.faixa-tipo-borda-inf         = 01
          tt-formatar-faixa.faixa-tipo-borda-esq         = 01
          tt-formatar-faixa.faixa-tipo-borda-dir         = 01
          tt-formatar-faixa.faixa-cor-interior           = 2
          tt-formatar-faixa.faixa-alinhamento-horizontal = 5.
   
   CREATE tt-formatar-faixa.
   ASSIGN tt-formatar-faixa.arquivo-num                  = 1
          tt-formatar-faixa.planilha-num                 = 1
          tt-formatar-faixa.faixa-dados                  = "C2:C" + string(i-linha)
          tt-formatar-faixa.faixa-fonte-cor              = 1
          tt-formatar-faixa.faixa-fonte-negrito          = NO
          tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
          tt-formatar-faixa.faixa-tipo-borda-sup         = 01
          tt-formatar-faixa.faixa-tipo-borda-inf         = 01
          tt-formatar-faixa.faixa-tipo-borda-esq         = 01
          tt-formatar-faixa.faixa-tipo-borda-dir         = 01
          tt-formatar-faixa.faixa-cor-interior           = 2.

   CREATE tt-formatar-faixa.
   ASSIGN tt-formatar-faixa.arquivo-num                  = 1
          tt-formatar-faixa.planilha-num                 = 1
          tt-formatar-faixa.faixa-dados                  = "D2:D" + string(i-linha)
          tt-formatar-faixa.faixa-fonte-cor              = 1
          tt-formatar-faixa.faixa-fonte-negrito          = NO
          tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
          tt-formatar-faixa.faixa-tipo-borda-sup         = 01
          tt-formatar-faixa.faixa-tipo-borda-inf         = 01
          tt-formatar-faixa.faixa-tipo-borda-esq         = 01
          tt-formatar-faixa.faixa-tipo-borda-dir         = 01
          tt-formatar-faixa.faixa-cor-interior           = 2.

   CREATE tt-formatar-faixa.
   ASSIGN tt-formatar-faixa.arquivo-num                  = 1
          tt-formatar-faixa.planilha-num                 = 1
          tt-formatar-faixa.faixa-dados                  = "E2:E" + string(i-linha)
          tt-formatar-faixa.faixa-fonte-cor              = 1
          tt-formatar-faixa.faixa-fonte-negrito          = NO
          tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
          tt-formatar-faixa.faixa-tipo-borda-sup         = 01
          tt-formatar-faixa.faixa-tipo-borda-inf         = 01
          tt-formatar-faixa.faixa-tipo-borda-esq         = 01
          tt-formatar-faixa.faixa-tipo-borda-dir         = 01
          tt-formatar-faixa.faixa-cor-interior           = 2
          tt-formatar-faixa.faixa-alinhamento-horizontal = 5.


   ASSIGN i-plan-faixa = 1.
   if tt-param.l-detalha-controle-fornecedor THEN DO: 
       ASSIGN i-plan-faixa = i-plan-faixa + 1.
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "A1:H1"       
              tt-formatar-faixa.faixa-fonte-cor              = 2
              tt-formatar-faixa.faixa-fonte-negrito          = YES
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 55.
     
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "A2:A" + string(i-linha1)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "B2:B" + string(i-linha1)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2
              tt-formatar-faixa.faixa-alinhamento-horizontal = 5.
       
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "C2:C" + string(i-linha1)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "D2:D" + string(i-linha1)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "E2:E" + string(i-linha1)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "F2:F" + string(i-linha1)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2
              tt-formatar-faixa.faixa-alinhamento-horizontal = 5.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "G2:G" + string(i-linha1)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2
              tt-formatar-faixa.faixa-alinhamento-horizontal = 5.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "H2:H" + string(i-linha1)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2
              tt-formatar-faixa.faixa-alinhamento-horizontal = 5.
   END.

   if tt-param.l-detalha-itens THEN DO: 
       ASSIGN i-plan-faixa = i-plan-faixa + 1.
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "A1:G1"       
              tt-formatar-faixa.faixa-fonte-cor              = 2
              tt-formatar-faixa.faixa-fonte-negrito          = YES
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 55.
     
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "A2:A" + string(i-linha2)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "B2:B" + string(i-linha2)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2
              tt-formatar-faixa.faixa-alinhamento-horizontal = 5.
       
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "C2:C" + string(i-linha2)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "D2:D" + string(i-linha2)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "E2:E" + string(i-linha2)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "F2:F" + string(i-linha2)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "G2:G" + string(i-linha2)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2
              tt-formatar-faixa.faixa-alinhamento-horizontal = 5.
   END.

   if tt-param.l-detalha-controle-item THEN do:
       ASSIGN i-plan-faixa = i-plan-faixa + 1.
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "A1:J1"       
              tt-formatar-faixa.faixa-fonte-cor              = 2
              tt-formatar-faixa.faixa-fonte-negrito          = YES
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 55.
     
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "A2:A" + string(i-linha3)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "B2:B" + string(i-linha3)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
       
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "C2:C" + string(i-linha3)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "D2:D" + string(i-linha3)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "E2:E" + string(i-linha3)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "F2:F" + string(i-linha3)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "G2:G" + string(i-linha3)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "H2:H" + string(i-linha3)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2
              tt-formatar-faixa.faixa-alinhamento-horizontal = 5.
    
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "I2:I" + string(i-linha3)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2
              tt-formatar-faixa.faixa-alinhamento-horizontal = 5.
       CREATE tt-formatar-faixa.
       ASSIGN tt-formatar-faixa.arquivo-num                  = 1
              tt-formatar-faixa.planilha-num                 = i-plan-faixa
              tt-formatar-faixa.faixa-dados                  = "J2:J" + string(i-linha3)
              tt-formatar-faixa.faixa-fonte-cor              = 1
              tt-formatar-faixa.faixa-fonte-negrito          = NO
              tt-formatar-faixa.faixa-fonte-nome             = "Tahoma"
              tt-formatar-faixa.faixa-tipo-borda-sup         = 01
              tt-formatar-faixa.faixa-tipo-borda-inf         = 01
              tt-formatar-faixa.faixa-tipo-borda-esq         = 01
              tt-formatar-faixa.faixa-tipo-borda-dir         = 01
              tt-formatar-faixa.faixa-cor-interior           = 2
              tt-formatar-faixa.faixa-alinhamento-horizontal = 5.
   END.

   RUN pi-execute2 in h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                                  INPUT-OUTPUT TABLE tt-planilha2,
                                  INPUT-OUTPUT TABLE tt-dados,
                                  INPUT-OUTPUT TABLE tt-formatar-faixa,
                                  INPUT-OUTPUT TABLE tt-grafico2,
                                  INPUT-OUTPUT TABLE tt-erros).


   VIEW FRAME f-cabec.
   VIEW FRAME f-rodape.
   IF CAN-FIND (FIRST tt-erros) THEN DO:
       FOR EACH tt-erros:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-planilha-excel-nao-foi-gerada AS CHARACTER FORMAT "X(32)" NO-UNDO.
           {utp/ut-liter.i "Planilha_nÆo_foi_gerada" *}
           ASSIGN c-lbl-liter-planilha-excel-nao-foi-gerada = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-erro AS CHARACTER FORMAT "X(13)" NO-UNDO.
           {utp/ut-liter.i "Erro" *}
           ASSIGN c-lbl-liter-erro = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-descricao AS CHARACTER FORMAT "X(13)" NO-UNDO.
           {utp/ut-liter.i "Descri‡Æo" *}
           ASSIGN c-lbl-liter-descricao = TRIM(RETURN-VALUE).
           PUT SKIP(1)
               c-lbl-liter-planilha-excel-nao-foi-gerada + "!" SKIP
               c-lbl-liter-erro + ".....: " tt-erros.cod-erro SKIP
               c-lbl-liter-descricao + ": " tt-erros.desc-error FORMAT "x(100)" SKIP(1).
       END.
   END.
   ELSE DO:
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-planilha-excel-gerada-com-suce AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "Planilha_gerada_com_sucesso" *}
       ASSIGN c-lbl-liter-planilha-excel-gerada-com-suce = TRIM(RETURN-VALUE).
       DEFINE VARIABLE c-lbl-liter-af0502 AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "AF0502" *}
       ASSIGN c-lbl-liter-af0502 = TRIM(RETURN-VALUE).
       PUT UNFORMATTED SKIP(1)
           c-lbl-liter-planilha-excel-gerada-com-suce + ": " + string(SESSION:TEMP-DIRECTORY + c-lbl-liter-af0502 + "-" + c-seg-usuario + "-" + REPLACE(STRING(TIME,"hh:mm:ss"),":","-")  + ".XLS") SKIP(1).

   END.
   DELETE PROCEDURE h-utapi013.


END PROCEDURE.
