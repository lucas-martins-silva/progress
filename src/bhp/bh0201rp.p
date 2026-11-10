/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0201RP 2.00.00.033 } /*** "010033" 14/07/2026 15:13:27  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bh0201rp MBH}
&ENDIF

{include/i_fnctrad.i}
/*******************************************************************************
**
**  Programa: BH0201RP.P - Transferˆncia para Banco Hist¢rico - Distribui‡Æo
**
*******************************************************************************/

/*Defini‡Æo include pr‚-processador release */
{cdp/cdcfgdis.i} 
{include/i_dbvers.i} 
{include/i_prdvers.i} 

DEFINE TEMP-TABLE ttErrosConexao NO-UNDO
    FIELD i-sequen  AS INTEGER
    FIELD cd-erro   AS INTEGER
    FIELD mensagem  AS CHARACTER FORMAT "x(255)".

FOR FIRST param-global NO-LOCK:
END.

DEFINE TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD cod-estabel  LIKE nota-fiscal.cod-estabel
    FIELD serie        LIKE nota-fiscal.serie
    FIELD nr-nota-fis  LIKE nota-fiscal.nr-nota-fis
    FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota
    INDEX id-nota IS PRIMARY UNIQUE
          cod-estabel
          serie
          nr-nota-fis.


/* Include de padronizacao do programa de customizacao */
{include/i-epc200.i "bh0201rp"}  
/* ========================= Temp-Table Definitions ========================= */
define temp-table tt-raw-digita 
    field raw-digita as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char    format "x(35)"
    field usuario          as char    format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field da-per-corte     as date    format 99/99/9999
   /* field ano-of           as integer format 9999*/
    field l-pedfat         as logical
    field l-estat          as logical
    field l-of             as logical
    field l-cotacao        as logical.    

define temp-table tt-estat-modulo no-undo
    field i-sequencia      as integer  label "Seq"
    field c-modulo         as char     FORMAT "x(02)" label "M¢dulo"
    FIELD c-nom-tab        AS CHAR     FORMAT "x(25)" LABEL "Tabela"
    field c-tabela         as char     FORMAT "x(35)" label "Descri‡Æo"
    field i-modulo         as integer  label "Registros"
    index i-sequencia is unique i-sequencia ascending.    

/* Defini‡Æo da temp-table de erros 
   Valores poss¡veis para o campo tt-erro.i-tabela:
             1 - nota-fiscal
             2 - it-nota-fisc
             3 - it-nota-imp
             4 - nota-trans
             5 - fat-ser-lote
             6 - nar-it-nota
             7 - fat-repre
             8 - fat-duplic
             9 - nota-embal
            10 - item-embal
            11 - devol-cli
            12 - ped-venda
            13 - ped-item
            14 - ped-ent
            16 - ped-repre
            18 - cond-ped
            19 - fat-estat
            20 - doc-fiscal
            21 - it-doc-fisc
            22 - apur-imposto
            23 - imp-valor
            24 - imposto-guia
            31 - ext-doc-fiscal  
            32 - nota-fisc-social
            33 - item-nota-social 
            34 - item-nfs-st    
            35 - sit-nf-eletro 
            36 - ret-nf-eletro  */   
DEFINE TEMP-TABLE tt-erro-bh NO-UNDO
    FIELD i-tabela AS INTEGER FORMAT "9"
    FIELD r-rowid  AS ROWID
    INDEX ch-tabela IS PRIMARY
              i-tabela.


def temp-table tt-erro no-undo
    field cd-erro  as int
    field mensagem as char. 

def temp-table tt-param-bh no-undo 
    field banco                 as char
    field tp-banco              as int  /* nao utilizado */    
    field cod-versao-integracao as int.

define variable retorno as character no-undo.


/* ============================ Input Parameters ============================ */
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.


/* ========================== Variable Definitions ========================== */
define new shared variable h-acomp as handle no-undo.

define variable de-total         as integer   no-undo.
define variable i-cont           as integer   no-undo.
define variable i-cont-aux1      as integer   no-undo.
define variable i-cont-aux2      as integer   no-undo.
define variable c-acompanha      as character no-undo.
define variable c-acompanha-aux1 as character no-undo.
define variable c-acompanha-aux2 as character no-undo.
define variable c-destino        as character no-undo.
define variable c-parametros     as character no-undo.
define variable c-impressao      as character no-undo.
define variable c-pedfat         as character no-undo.
define variable c-estat          as character no-undo.
define variable c-of             as character no-undo. 
define variable c-cotacao        as character no-undo.



{include/i-rpvar.i}


/* =========================== Buffers Definitions ========================== */
define buffer b-nota-fiscal for movdis.nota-fiscal.


/* =========================== Frames Definitions =========================== */
/*form    
     tt-estat-modulo.c-modulo    format "x(03)" AT 03 
     tt-estat-modulo.c-nom-tab   FORMAT "x(25)" AT 07
     tt-estat-modulo.c-tabela    format "x(30)" AT 33
     tt-estat-modulo.i-modulo    AT 67
     with no-box width 132 frame f-modulo stream-io. */

/* {utp/ut-liter.i Seq       * C} tt-estat-modulo.i-sequencia:label in frame f-modulo = trim(return-value).
{utp/ut-liter.i M¢dulo    * C} tt-estat-modulo.c-modulo:label    in frame f-modulo = trim(return-value).
{utp/ut-liter.i Tabela    * C} tt-estat-modulo.c-tabela:label    in frame f-modulo = trim(return-value).
{utp/ut-liter.i Registros * C} tt-estat-modulo.i-modulo:label    in frame f-modulo = trim(return-value). */
                    
form skip(01)
     "Total de Registros"    AT 34
     de-total                at 70 no-label
     with no-box width 132 64 down frame f-total stream-io.

form 
                                                           skip(3)
     c-parametros            at 60 no-label format "x(20)" skip(1)
     tt-param.da-per-corte   at 49
     /*tt-param.ano-of         at 55*/
     c-pedfat                at 53
     c-estat                 at 54
     c-of                    at 57
     c-cotacao               at 52
     skip(3)
     c-impressao             at 60 no-label format "x(20)" skip(1)
     c-destino               at 52 " - "
     tt-param.arquivo              no-label format "x(40)"
     tt-param.usuario        at 54             
     with no-box width 132 64 down side-labels frame f-parametros stream-io.  

{utp/ut-liter.i Per¡odo_de_Corte          * C} tt-param.da-per-corte:label in frame f-parametros = trim(return-value).
/*{utp/ut-liter.i Importa_OF_desde_o_ano_de * C} tt-param.ano-of:label       in frame f-parametros = trim(return-value).        */
{utp/ut-liter.i Pedido/Faturamento        * C} c-pedfat:label              in frame f-parametros = trim(return-value).    
{utp/ut-liter.i Estat¡sticas              * C} c-estat:label               in frame f-parametros = trim(return-value).    
{utp/ut-liter.i Obriga‡äes_Fiscais        * C} c-of:label                  in frame f-parametros = trim(return-value).    
{utp/ut-liter.i Cota‡Æo                   * C} c-cotacao:label             in frame f-parametros = trim(return-value).
{utp/ut-liter.i Destino                   * C} c-destino:label             in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu rio                   * C} tt-param.usuario:label      in frame f-parametros = trim(return-value).

{utp/ut-liter.i PAR¶METROS * C} c-parametros = trim(return-value).
{utp/ut-liter.i IMPRESSÇO  * C} c-impressao  = trim(return-value).

run utp/ut-trfrrp.p (input frame f-parametros:handle).
run utp/ut-trfrrp.p (input frame f-total:handle).
/*run utp/ut-trfrrp.p (input frame f-modulo:handle).*/
{include/i-rpcab.i}

/* =============================== Main Block =============================== */


/* ------------------------ Inicializa Acompanhamento ----------------------- */
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Bancos_Hist¢ricos *}

run pi-inicializar in h-acomp (input  Return-value ).
run pi-seta-tipo   in h-acomp (input 1).


/* ---------------- Conecta Base de Dados - Bancos Hist¢ricos --------------- */


{utp/ut-liter.i Conectando_Banco_Hist¢rico_-_Distribui‡Æo}.
run pi-acompanhar in h-acomp (input trim(return-value)).


/* Conecta Bancos Hist¢ricos */
RUN btb/btb962za.p (INPUT param-global.empresa-prin,
                    INPUT param-global.empresa-prin,
                    INPUT 3,  /* 1-Login, 2-Consultar, 3-Transferir */
                    INPUT 1,  /* Se a op‡Æo for Transferir, ‚ poss¡vel: 1-Conectar ou 2-Desconectar */
                    INPUT "",
                    OUTPUT TABLE ttErrosConexao).
    
IF CAN-FIND(FIRST ttErrosConexao) THEN DO:

    {include/i-rpout.i}

    FOR EACH ttErrosConexao:
        disp ttErrosConexao.mensagem format "x(60)" no-label with stream-io.
    END.

    {include/i-rpclo.i}

    run pi-finalizar in h-acomp.
    return "NOK".
END.

/* ------------------ Exporta Dados do MovDis para o HisDis ----------------- */
run Pi-Gera-tt-estat-modulo.

if  tt-param.l-pedfat then
    run Pi-Exporta-Pedidos-Faturamento.

if  tt-param.l-estat then
    run Pi-Exporta-Estatistica.

if  tt-param.l-of then
    run Pi-Exporta-OF.

if  tt-param.l-cotacao then
    run Pi-Exporta-Cotacao.

/* --------------- Desconecta Base de Dados - Bancos Hist¢ricos ------------- */
{utp/ut-liter.i Desconectando_Banco_Hist¢rico_-_Distribui‡Æo}.
run pi-acompanhar in h-acomp (input trim(return-value)).

&IF "{&bf_dis_versao_ems}" < "2.08" &THEN

    run bhp/bh9810.p (input "hisdis").
    
    if tt-param.l-pedfat then
        run bhp/bh9810.p (input "hisadm").
&ELSE

    RUN btb/btb962za.p (INPUT param-global.empresa-prin,
                        INPUT param-global.empresa-prin,
                        INPUT 3,  /* 1-Login, 2-Consultar, 3-Transferir */
                        INPUT 2,  /* Se a op‡Æo for Transferir, ‚ poss¡vel: 1-Conectar ou 2-Desconectar */
                        INPUT "",
                        OUTPUT TABLE ttErrosConexao).
&ENDIF

/* UPC para desconexÆo da base hist¢rica espec¡fica */
for each tt-epc where tt-epc.cod-event = "conecta_his":
    delete tt-epc.
end.

create tt-epc.
assign tt-epc.cod-event     = "conecta_his" 
       tt-epc.cod-parameter = "desconecta_his"
       tt-epc.val-parameter = " ".

{include/i-epc201.i "conecta_his"}  
/*Fim UPC*/

/* ------------------------ Relat¢rio de Estat¡stica ------------------------ */

{include/i-rpout.i}
run Pi-Imprime-Estat¡stica.
{include/i-rpclo.i}

/* ------------------------ Finaliza Acompanhamento ------------------------- */
run pi-finalizar in h-acomp.

RETURN "OK":U.

/* ========================== Procedure Definitions ========================== */
Procedure Pi-Exporta-Pedidos-Faturamento:

    /* ----------------------------------------------------------------------- */
    /* ------------------------- Exporta Faturamento ------------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Faturamento}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.

    do trans:
        find first bh-periodos where 
                   bh-periodos.ep-codigo = param-global.empresa-prin and
                   bh-periodos.modulos   = "FT" exclusive-lock no-error.
        if  not avail bh-periodos then do:
            create bh-periodos.
            assign bh-periodos.ep-codigo = param-global.empresa-prin
                   bh-periodos.modulos   = "FT"
                   bh-periodos.area      = "D".
        end.
        assign bh-periodos.periodo = tt-param.da-per-corte.
    end.

    EMPTY TEMP-TABLE tt-nota-fiscal.
    Blk_NotaFiscal:
    for each movdis.nota-fiscal where 
             movdis.nota-fiscal.dt-emis-nota <= tt-param.da-per-corte and
             (   movdis.nota-fiscal.dt-confirma <> ?
              or movdis.nota-fiscal.dt-cancel   <> ?)                 and
             (   movdis.nota-fiscal.dt-atual-cr  <> ?  
              OR NOT param-global.modulo-cr)                          AND
              movdis.nota-fiscal.dt-at-est    <> ?                    and
             ( movdis.nota-fiscal.dt-at-ofest  <> ? 
               OR NOT param-global.modulo-of) exclusive-lock transaction:   /* Atual Estat */

             assign i-cont = i-cont + 1.
             run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

             /* ------- Exporta It-Nota-Fisc/Fat-Ser-Lote/Nar-It-Nota/It-Nota-Imp ------ */
             {utp/ut-liter.i Itens}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.
             for each movdis.it-nota-fisc of movdis.nota-fiscal exclusive-lock:

                      assign i-cont-aux1 = i-cont-aux1 + 1.
                      run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                      {utp/ut-liter.i Lotes}.
                      assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                             i-cont-aux2      = 0.

                      for each movdis.fat-ser-lote where 
                               movdis.fat-ser-lote.cod-estabel = movdis.nota-fiscal.cod-estabel and
                               movdis.fat-ser-lote.serie       = movdis.nota-fiscal.serie       and
                               movdis.fat-ser-lote.nr-nota-fis = movdis.nota-fiscal.nr-nota-fis and                               
                               movdis.fat-ser-lote.nr-seq-fat  = movdis.it-nota-fisc.nr-seq-fat exclusive-lock:

                          assign i-cont-aux2 = i-cont-aux2 + 1.
                          run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                          run bhp/bh0201a.p ("fat-ser-lote", rowid(movdis.fat-ser-lote)).

                          IF  RETURN-VALUE = "NOK":U THEN DO:
                              CREATE tt-erro-bh.
                              ASSIGN tt-erro-bh.i-tabela = 5
                                     tt-erro-bh.r-rowid  = ROWID(movdis.fat-ser-lote).
                              UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                          END.

                          /* ------------------------- Cria Tabela de Locks ------------------------- */
                          /* NÆo existe a tabela "his-fat-ser-lote" no mgdis.*/
                          /* ------------------------------------------------------------------------ */

                          on delete of movdis.fat-ser-lote override do: end.
                          delete movdis.fat-ser-lote validate(true,"").

                          find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "fat-ser-lote" NO-ERROR.
                          assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

                      end.

                      {utp/ut-liter.i Narrativas}.
                      assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                             i-cont-aux2      = 0.

                      for each movdis.nar-it-nota where 
                               movdis.nar-it-nota.cod-estabel = movdis.nota-fiscal.cod-estabel and
                               movdis.nar-it-nota.serie       = movdis.nota-fiscal.serie       and
                               movdis.nar-it-nota.nr-nota-fis = movdis.nota-fiscal.nr-nota-fis and
                               movdis.nar-it-nota.nr-sequencia = movdis.it-nota-fisc.nr-seq-fat exclusive-lock:

                          assign i-cont-aux2 = i-cont-aux2 + 1.
                          run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                          run bhp/bh0201a.p ("nar-it-nota", rowid(movdis.nar-it-nota)).

                          IF  RETURN-VALUE = "NOK":U THEN DO:
                              CREATE tt-erro-bh.
                              ASSIGN tt-erro-bh.i-tabela = 6
                                     tt-erro-bh.r-rowid  = ROWID(movdis.nar-it-nota).
                              UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                          END.

                          /* ------------------------- Cria Tabela de Locks ------------------------- */
                          /* NÆo existe a tabela "his-nar-it-nota" no mgdis.*/
                          /* ------------------------------------------------------------------------ */

                          on delete of movdis.nar-it-nota override do: end.
                          delete movdis.nar-it-nota validate (true, "").

                          find first tt-estat-modulo WHERE tt-estat-modulo.c-nom-tab = "nar-it-nota" NO-ERROR.
                          assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                      end.

                      {utp/ut-liter.i Imposto}.
                      assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                             i-cont-aux2      = 0.

                      for each movdis.it-nota-imp of movdis.it-nota-fisc exclusive-lock:

                          assign i-cont-aux2 = i-cont-aux2 + 1.
                          run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                          run bhp/bh0201a.p ("it-nota-imp", rowid(movdis.it-nota-imp)).

                          IF  RETURN-VALUE = "NOK":U THEN DO:
                              CREATE tt-erro-bh.
                              ASSIGN tt-erro-bh.i-tabela = 3
                                     tt-erro-bh.r-rowid  = ROWID(movdis.it-nota-imp).
                              UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                          END.

                          /* ------------------------- Cria Tabela de Locks ------------------------- */
                          /* NÆo existe a tabela "his-it-nota-imp" no mgdis.*/
                          /* ------------------------------------------------------------------------ */

                          on delete of movdis.it-nota-imp override do: end.
                          delete movdis.it-nota-imp validate (true, "").

                          find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "it-nota-imp" NO-ERROR.
                          assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                      end.                      

                      run bhp/bh0201a.p ("it-nota-fisc", rowid(movdis.it-nota-fisc)).

                      IF  RETURN-VALUE = "NOK":U THEN DO:
                          CREATE tt-erro-bh.
                          ASSIGN tt-erro-bh.i-tabela = 2
                                 tt-erro-bh.r-rowid  = ROWID(movdis.it-nota-fisc).
                          UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                      END.

                      /* ------------------------- Cria Tabela de Locks ------------------------- */
                      /* NÆo existe a tabela "his-it-nota-fisc" no mgdis.*/
                      /* ------------------------------------------------------------------------ */

                    /*Ini UPC Tratamento Tabelas Espec¡ficas*/
            
                    for each tt-epc 
                        where tt-epc.cod-event = "bh-it-nota-fisc":U:
                        delete tt-epc.
                    end.
                    create tt-epc.
                    assign tt-epc.cod-event     = "bh-it-nota-fisc":U
                           tt-epc.cod-parameter = "it-nota-fisc rowid":U
                           tt-epc.val-parameter = string(ROWID(movdis.it-nota-fisc)).
            
                    {include/i-epc201.i "bh-it-nota-fisc"}
            
                    /*Fim  UPC Tratamento Tabelas Espec¡ficas*/

                      on delete of movdis.it-nota-fisc override do: end.                      
                      delete movdis.it-nota-fisc validate(true, "").

                      find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "it-nota-fisc" NO-ERROR.
                      assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             find first b-nota-fiscal where 
                        b-nota-fiscal.cod-estabel = movdis.nota-fiscal.cod-estabel  and
                        b-nota-fiscal.serie       = movdis.nota-fiscal.serie        and
                        b-nota-fiscal.nr-fatura   = movdis.nota-fiscal.nr-fatura    and
                        rowid(b-nota-fiscal)     <> rowid(movdis.nota-fiscal) no-lock no-error.
             if  not avail b-nota-fiscal then do:

                 /* -------------------------- Exporta Fat-Repre --------------------------- */
                 {utp/ut-liter.i Representantes}.
                 assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": "
                        i-cont-aux1      = 0.

                 for each movdis.fat-repre where 
                          movdis.fat-repre.cod-estabel = movdis.nota-fiscal.cod-estabel and
                          movdis.fat-repre.serie       = movdis.nota-fiscal.serie       and
                          movdis.fat-repre.nr-fatura   = movdis.nota-fiscal.nr-fatura exclusive-lock:

                     assign i-cont-aux1 = i-cont-aux1 + 1.
                     run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                     run bhp/bh0201a.p ("fat-repre", rowid(movdis.fat-repre)).

                     IF  RETURN-VALUE = "NOK":U THEN DO:
                         CREATE tt-erro-bh.
                         ASSIGN tt-erro-bh.i-tabela = 7
                                tt-erro-bh.r-rowid  = ROWID(movdis.fat-repre).
                         UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                     END.

                     /* ------------------------- Cria Tabela de Locks ------------------------- */
                     /* NÆo existe a tabela "his-fat-repre" no mgdis.*/
                     /* ------------------------------------------------------------------------ */

                     on delete of movdis.fat-repre override do: end.
                     delete movdis.fat-repre validate(true, "").

                     find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "fat-repre" NO-ERROR.
                     assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                 end.

                 /* -------------------------- Exporta Fat-Duplic -------------------------- */
                 {utp/ut-liter.i Faturas}.
                 assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                        i-cont-aux1      = 0.

                 for each movdis.fat-duplic where 
                          movdis.fat-duplic.cod-estabel = movdis.nota-fiscal.cod-estabel and
                          movdis.fat-duplic.serie       = movdis.nota-fiscal.serie       and
                          movdis.fat-duplic.nr-fatura   = movdis.nota-fiscal.nr-fatura exclusive-lock:

                     assign i-cont-aux1 = i-cont-aux1 + 1.
                     run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                     run bhp/bh0201a.p ("fat-duplic", rowid(movdis.fat-duplic)).

                     IF  RETURN-VALUE = "NOK":U THEN DO:
                         CREATE tt-erro-bh.
                         ASSIGN tt-erro-bh.i-tabela = 8
                                tt-erro-bh.r-rowid  = ROWID(movdis.fat-duplic).
                         UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                     END.

                     /* ------------------------- Cria Tabela de Locks ------------------------- */
                     create his-fat-duplic.
                     assign his-fat-duplic.cod-estabel  = movdis.fat-duplic.cod-estabel
                            his-fat-duplic.serie        = movdis.fat-duplic.serie
                            his-fat-duplic.nr-fatura    = movdis.fat-duplic.nr-fatura
                            his-fat-duplic.ind-fat-nota = movdis.fat-duplic.ind-fat-nota
                            his-fat-duplic.flag-atualiz = movdis.fat-duplic.flag-atualiz
                            his-fat-duplic.parcela      = movdis.fat-duplic.parcela.
                     /* ------------------------------------------------------------------------ */

                     on delete of movdis.fat-duplic override do: end.
                     delete movdis.fat-duplic validate(true, "").

                     find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "fat-duplic" NO-ERROR.
                     assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.                      
                 end.
             end.                      

             /* --------------------- Exporta Nota-Embal/Item-Embal -------------------- */
             {utp/ut-liter.i Embalagens}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.

             for each movdis.nota-embal of movdis.nota-fiscal exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).             

                 {utp/ut-liter.i Itens_Embal}.
                 assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                        i-cont-aux2      = 0.

                 for each movdis.item-embal where 
                          movdis.item-embal.sigla-emb   = movdis.nota-embal.sigla-emb   and
                          movdis.item-embal.cod-estabel = movdis.nota-embal.cod-estabel and
                          movdis.item-embal.serie       = movdis.nota-embal.serie       and
                          movdis.item-embal.nr-nota-fis = movdis.nota-embal.nr-nota-fis exclusive-lock:

                     assign i-cont-aux2 = i-cont-aux2 + 1.
                     run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).                                                                      

                     run bhp/bh0201a.p ("item-embal", rowid(movdis.item-embal)).

                     IF  RETURN-VALUE = "NOK":U THEN DO:
                         CREATE tt-erro-bh.
                         ASSIGN tt-erro-bh.i-tabela = 10
                                tt-erro-bh.r-rowid  = ROWID(movdis.item-embal).
                         UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                     END.

                     /* ------------------------- Cria Tabela de Locks ------------------------- */
                     /* NÆo existe a tabela "his-item-embal" no mgdis.*/
                     /* ------------------------------------------------------------------------ */

                     on delete of movdis.item-embal override do: end.
                     delete movdis.item-embal validate (true, "").

                     find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "item-embal" NO-ERROR.
                     assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                 end.

                 run bhp/bh0201a.p ("nota-embal", rowid(movdis.nota-embal)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 9
                            tt-erro-bh.r-rowid  = ROWID(movdis.nota-embal).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                 /* NÆo existe a tabela "his-nota-embal" no mgdis.*/
                 /* ------------------------------------------------------------------------ */

                 on delete of movdis.nota-embal override do: end.
                 delete movdis.nota-embal validate (true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "nota-embal" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.


             /* --------------------------- Exporta Devol-Cli -------------------------- */
             {utp/ut-liter.i Devolu‡äes}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.                                        

             for each movdis.devol-cli of movdis.nota-fiscal exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0201a.p ("devol-cli", rowid(movdis.devol-cli)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 11
                            tt-erro-bh.r-rowid  = ROWID(movdis.devol-cli).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                 /* NÆo existe a tabela "his-devol-cli" no mgdis.*/
                 /* ------------------------------------------------------------------------ */

                 IF  MONTH(movdis.nota-fiscal.dt-emis-nota) = MONTH(movdis.devol-cli.dt-devol)
                 AND YEAR(movdis.nota-fiscal.dt-emis-nota)  = YEAR(movdis.devol-cli.dt-devol) THEN DO:
                     on delete of movdis.devol-cli override do: end.
                     delete movdis.devol-cli validate (true, "").
                 end.            

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "devol-cli" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

             end.  
             
             /* -------------------------- Exporta Nota-Trans -------------------------- */
             {utp/ut-liter.i Transp_Aut}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.                                        

             for each movdis.nota-trans of movdis.nota-fiscal exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0201a.p ("nota-trans", rowid(movdis.nota-trans)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 4
                            tt-erro-bh.r-rowid  = ROWID(movdis.nota-trans).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                 /* NÆo existe a tabela "his-nota-trans" no mgdis.*/
                 /* ------------------------------------------------------------------------ */

                 on delete of movdis.nota-trans override do: end.
                 delete movdis.nota-trans validate (true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "nota-trans" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.                      

/*****************************************************************************************************************************/
              /* --------------------------- Exporta Item-nfs-st -------------------------- */
             {utp/ut-liter.i ST_Antecip}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.                                        

             for each movdis.item-nfs-st 
                WHERE movdis.item-nfs-st.cod-docto-nfs = movdis.nota-fiscal.nr-nota-fis
                  AND movdis.item-nfs-st.cod-estab-nfs = movdis.nota-fiscal.cod-estabel
                  AND movdis.item-nfs-st.cod-ser-nfs   = movdis.nota-fiscal.serie exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0201a.p ("item-nfs-st", rowid(movdis.item-nfs-st)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 34
                            tt-erro-bh.r-rowid  = ROWID(movdis.item-nfs-st).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                 /* NÆo existe a tabela "his-devol-cli" no mgdis.*/
                 /* ------------------------------------------------------------------------ */

                 on delete of movdis.item-nfs-st override do: end.
                 delete movdis.item-nfs-st validate (true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "item-nfs-st" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.            

/******************************************************************************************************************************/

            /* -------------------------- Exporta sit-nf-eletro --------------------------- */
                 {utp/ut-liter.i Situa‡Æo_Notas_Fiscais_Eletronicas}.
                 assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": "
                        i-cont-aux1      = 0.

                 for each movdis.sit-nf-eletro where 
                          movdis.sit-nf-eletro.cod-estabel   = movdis.nota-fiscal.cod-estabel and
                          movdis.sit-nf-eletro.cod-serie     = movdis.nota-fiscal.serie       and
                          movdis.sit-nf-eletro.cod-nota-fisc = movdis.nota-fiscal.nr-nota-fis exclusive-lock:

                     assign i-cont-aux1 = i-cont-aux1 + 1.
                     run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                     run bhp/bh0201a.p ("sit-nf-eletro", rowid(movdis.sit-nf-eletro)).

                     IF  RETURN-VALUE = "NOK":U THEN DO:
                         CREATE tt-erro-bh.
                         ASSIGN tt-erro-bh.i-tabela = 35
                                tt-erro-bh.r-rowid  = ROWID(movdis.sit-nf-eletro).
                         UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                     END.

                     /* ------------------------- Cria Tabela de Locks ------------------------- */
                     /* NÆo existe a tabela "sit-nf-eletro" no mgdis.*/
                     /* ------------------------------------------------------------------------ */

                     on delete of movdis.sit-nf-eletro override do: end.
                     delete movdis.sit-nf-eletro validate(true, "").

                     find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "sit-nf-eletro" NO-ERROR.
                     assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                 end.
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

                 /* -------------------------- Exporta ret-nf-eletro --------------------------- */
                 {utp/ut-liter.i Retorno_Notas_Fiscais_Eletronicas}.
                 assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": "
                        i-cont-aux1      = 0.

                 for each movdis.ret-nf-eletro where 
                          movdis.ret-nf-eletro.cod-estabel = movdis.nota-fiscal.cod-estabel and
                          movdis.ret-nf-eletro.cod-serie   = movdis.nota-fiscal.serie       and
                          movdis.ret-nf-eletro.nr-nota-fis = movdis.nota-fiscal.nr-nota-fis exclusive-lock:

                     assign i-cont-aux1 = i-cont-aux1 + 1.
                     run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                     run bhp/bh0201a.p ("ret-nf-eletro", rowid(movdis.ret-nf-eletro)).

                     IF  RETURN-VALUE = "NOK":U THEN DO:
                         CREATE tt-erro-bh.
                         ASSIGN tt-erro-bh.i-tabela = 36
                                tt-erro-bh.r-rowid  = ROWID(movdis.ret-nf-eletro).
                         UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                     END.

                     /* ------------------------- Cria Tabela de Locks ------------------------- */
                     /* NÆo existe a tabela "ret-nf-eletro" no mgdis.*/
                     /* ------------------------------------------------------------------------ */

                     on delete of movdis.ret-nf-eletro override do: end.
                     delete movdis.ret-nf-eletro validate(true, "").

                     find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "ret-nf-eletro" NO-ERROR.
                     assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                 end.

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*
                 /* -------------------------- Exporta  --------------------------- */
                 {utp/ut-liter.i Representantes}.
                 assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": "
                        i-cont-aux1      = 0.

                 for each movdis.fat-repre where 
                          movdis.fat-repre.cod-estabel = movdis.nota-fiscal.cod-estabel and
                          movdis.fat-repre.serie       = movdis.nota-fiscal.serie       and
                          movdis.fat-repre.nr-fatura   = movdis.nota-fiscal.nr-fatura exclusive-lock:

                     assign i-cont-aux1 = i-cont-aux1 + 1.
                     run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                     run bhp/bh0201a.p ("fat-repre", rowid(movdis.fat-repre)).

                     IF  RETURN-VALUE = "NOK":U THEN DO:
                         CREATE tt-erro-bh.
                         ASSIGN tt-erro-bh.i-tabela = 7
                                tt-erro-bh.r-rowid  = ROWID(movdis.fat-repre).
                         UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                     END.

                     /* ------------------------- Cria Tabela de Locks ------------------------- */
                     /* NÆo existe a tabela "his-fat-repre" no mgdis.*/
                     /* ------------------------------------------------------------------------ */

                     on delete of movdis.fat-repre override do: end.
                     delete movdis.fat-repre validate(true, "").

                     find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "fat-repre" NO-ERROR.
                     assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                 end.
*/
/*****************************************************************************************************************************/
                                       
                /* ----------------------------------------------------------------------- */
                /* ---------------------------------- eSocial ---------------------------- */
                /* ----------------------------------------------------------------------- */

                {utp/ut-liter.i eSocial}
                assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": "
                       i-cont-aux1      = 0.
            
                for each movadm.nota-fisc-social where 
                         movadm.nota-fisc-social.cod-estabel   = movdis.nota-fiscal.cod-estabel and
                         movadm.nota-fisc-social.cod-serie     = movdis.nota-fiscal.serie       and
                         movadm.nota-fisc-social.cod-nota-fisc = movdis.nota-fiscal.nr-nota-fis exclusive-lock :
                    
                         assign i-cont-aux1 = i-cont-aux1 + 1.
                         run pi-acompanhar in h-acomp (input c-acompanha-aux1 + ": " + string(i-cont) + "/" + string(i-cont-aux1)).
            
                         /*----- Exporta item-nota-social -----*/
                         {utp/ut-liter.i eSocial}
                         assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value).

                         {utp/ut-liter.i Itens}
                         ASSIGN c-acompanha-aux2 = c-acompanha-aux1 + "/" + TRIM(RETURN-VALUE) + ": ".
                                i-cont-aux2      = 0.
            
                         for each movadm.item-nota-social of movadm.nota-fisc-social exclusive-lock:

                             assign i-cont-aux2 = i-cont-aux2 + 1.
                             run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux1) + "/" + string(i-cont-aux2)).
            
                             run bhp/bh0201a.p ("item-nota-social", rowid(movadm.item-nota-social)).
            
                              IF  RETURN-VALUE = "NOK":U THEN DO:
                                  CREATE tt-erro-bh.
                                  ASSIGN tt-erro-bh.i-tabela = 33
                                         tt-erro-bh.r-rowid  = ROWID(movadm.item-nota-social).
                                  UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                              END.
            
                              /* ------------------------- Cria Tabela de Locks ------------------------- */
                              /* NÆo existe a tabela "his-item-nota-social" no movadm.*/
                              /* ------------------------------------------------------------------------ */
            
                              on delete of movadm.item-nota-social override do: end.                      
                              delete movadm.item-nota-social validate(true, "").
            
                              find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "item-nota-social" NO-ERROR.
                              assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                         end.
            
                         run bhp/bh0201a.p ("nota-fisc-social", rowid(movadm.nota-fisc-social)).
            
                         IF  RETURN-VALUE = "NOK":U THEN DO:
                             CREATE tt-erro-bh.
                             ASSIGN tt-erro-bh.i-tabela = 32
                                    tt-erro-bh.r-rowid  = ROWID(movadm.nota-fisc-social).
                             UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                         END.
            
                         /* ------------------------- Cria Tabela de Locks ------------------------- */
                         /* NÆo existe a tabela "his-nota-fisc-social" no movadm.                  */
                         /* ------------------------------------------------------------------------ */
            
                         on delete of movadm.nota-fisc-social override do: end.
                         delete movadm.nota-fisc-social validate(true,"").
            
                         find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "nota-fisc-social" NO-ERROR.
                         assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                end.

/*****************************************************************************************************************************/

             run bhp/bh0201a.p ("nota-fiscal", rowid(movdis.nota-fiscal)).

             IF  RETURN-VALUE = "NOK":U THEN DO:
                 CREATE tt-erro-bh.
                 ASSIGN tt-erro-bh.i-tabela = 1
                        tt-erro-bh.r-rowid  = ROWID(movdis.nota-fiscal).
                 UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
             END.

             /* ------------------------- Cria Tabela de Locks ------------------------- */
                create his-nota-fiscal.
                assign his-nota-fiscal.cod-estabel = movdis.nota-fiscal.cod-estabel
                       his-nota-fiscal.serie       = movdis.nota-fiscal.serie
                       his-nota-fiscal.nr-nota-fis = movdis.nota-fiscal.nr-nota-fis.
             /* ------------------------------------------------------------------------ */

            /*Ini UPC Tratamento Tabelas Espec¡ficas*/
    
            for each tt-epc 
                where tt-epc.cod-event = "bh-nota-fiscal":U:
                delete tt-epc.
            end.
            create tt-epc.
            assign tt-epc.cod-event     = "bh-nota-fiscal":U
                   tt-epc.cod-parameter = "nota-fiscal rowid":U
                   tt-epc.val-parameter = string(ROWID(movdis.nota-fiscal)).
    
            {include/i-epc201.i "bh-nota-fiscal"}
    
            /*Fim  UPC Tratamento Tabelas Espec¡ficas*/
            CREATE tt-nota-fiscal.
            ASSIGN tt-nota-fiscal.cod-estabel  = movdis.nota-fiscal.cod-estabel
                   tt-nota-fiscal.serie        = movdis.nota-fiscal.serie
                   tt-nota-fiscal.nr-nota-fis  = movdis.nota-fiscal.nr-nota-fis
                   tt-nota-fiscal.dt-emis-nota = movdis.nota-fiscal.dt-emis-nota.

             on delete of movdis.nota-fiscal override do: end.
             delete movdis.nota-fiscal validate (true, "").

             find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "nota-fiscal" NO-ERROR.
             assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
    end.

    
    FOR EACH  movdis.devol-cli
        WHERE movdis.devol-cli.dt-devol <= da-per-corte EXCLUSIVE-LOCK:

        IF  CAN-FIND(FIRST movdis.nota-fiscal OF movdis.devol-cli) THEN
            NEXT.

        FOR FIRST tt-nota-fiscal
            WHERE tt-nota-fiscal.cod-estabel  = nota-fiscal.cod-estabel
            AND   tt-nota-fiscal.serie        = nota-fiscal.serie      
            AND   tt-nota-fiscal.nr-nota-fis  = nota-fiscal.nr-nota-fis:
        END.

        IF  AVAIL tt-nota-fiscal
        AND MONTH(tt-nota-fiscal.dt-emis-nota) = MONTH(movdis.devol-cli.dt-devol)
        AND YEAR(tt-nota-fiscal.dt-emis-nota)  = YEAR(movdis.devol-cli.dt-devol) THEN 
            NEXT.

        assign i-cont-aux1 = i-cont-aux1 + 1.
        run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

        run bhp/bh0201a.p ("devol-cli", rowid(movdis.devol-cli)).

        on delete of movdis.devol-cli override do: end.
        delete movdis.devol-cli validate (true, "").

        find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "devol-cli" NO-ERROR.
        assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

    END.

    /* ----------------------------------------------------------------------- */
    /* --------------------------- Exporta Pedidos --------------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Pedidos}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.

    do trans:
        find first bh-periodos where 
                   bh-periodos.ep-codigo = param-global.empresa-prin and
                   bh-periodos.modulos   = "PD" exclusive-lock no-error.
        if  not avail bh-periodos then do:
            create bh-periodos.
            assign bh-periodos.ep-codigo = param-global.empresa-prin
                   bh-periodos.modulos   = "PD"
                   bh-periodos.area      = "D".
        end.
        assign bh-periodos.periodo = tt-param.da-per-corte.
    end.    

    Blk_PedVenda:
    for each movdis.ped-venda where 
             movdis.ped-venda.dt-entrega <= tt-param.da-per-corte and
            (movdis.ped-venda.cod-sit-ped = 3 or                              /* Atendido Total */
             movdis.ped-venda.cod-sit-ped = 6) exclusive-lock transaction:    /* Cancelado      */          

             find first movdis.it-nota-fisc where
                        movdis.it-nota-fisc.nome-ab-cli = movdis.ped-venda.nome-abrev and
                        movdis.it-nota-fisc.nr-pedcli   = movdis.ped-venda.nr-pedcli no-lock no-error.
             if  avail movdis.it-nota-fisc then next.   /* NÆo exporta pedidos cujas notas nÆo tenham sido exportadas */

             find first pre-fat where 
                        pre-fat.nome-abrev = movdis.ped-venda.nome-abrev and 
                        pre-fat.nr-pedcli  = movdis.ped-venda.nr-pedcli no-lock no-error.
             if  avail pre-fat then next.               /* NÆo exporta pedidos que tenham Embarques */

             assign i-cont = i-cont + 1.
             run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

             /* ----------------- Exporta Ped-Item/Ped-Ent/His-Ped-Ent ----------------- */
             {utp/ut-liter.i Itens}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.

             for each movdis.ped-item of movdis.ped-venda exclusive-lock:

                      assign i-cont-aux1 = i-cont-aux1 + 1.
                      run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                      {utp/ut-liter.i Entregas}.
                      assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                             i-cont-aux2      = 0.

                      for each movdis.ped-ent of movdis.ped-item exclusive-lock:

                          assign i-cont-aux2 = i-cont-aux2 + 1.
                          run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                          run bhp/bh0201a.p ("ped-ent", rowid(movdis.ped-ent)).

                          IF  RETURN-VALUE = "NOK":U THEN DO:
                              CREATE tt-erro-bh.
                              ASSIGN tt-erro-bh.i-tabela = 14
                                     tt-erro-bh.r-rowid  = ROWID(movdis.ped-ent).
                              UNDO Blk_PedVenda, NEXT Blk_PedVenda.
                          END.

                          /* ------------------------- Cria Tabela de Locks ------------------------- */
                          /* A tabela his-ped-ent existe no MOVDIS, mas nÆo tem rela‡Æo com o BH. */
                          /* ------------------------------------------------------------------------ */

                          on delete of movdis.ped-ent override do: end.
                          delete movdis.ped-ent validate(true,"").

                          find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "ped-ent" NO-ERROR.
                          assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                      end.

                      run bhp/bh0201a.p ("ped-item", rowid(movdis.ped-item)).

                      IF  RETURN-VALUE = "NOK":U THEN DO:
                          CREATE tt-erro-bh.
                          ASSIGN tt-erro-bh.i-tabela = 13
                                 tt-erro-bh.r-rowid  = ROWID(movdis.ped-item).
                          UNDO Blk_PedVenda, NEXT Blk_PedVenda.
                      END.

                      /* ------------------------- Cria Tabela de Locks ------------------------- */
                      /* NÆo existe a tabela "his-ped-item" no mgdis.*/
                      /* ------------------------------------------------------------------------ */

                      /*Ini UPC Tratamento Tabelas Espec¡ficas*/
                       
                      for each tt-epc 
                          where tt-epc.cod-event = "bh-ped-item":U:
                         delete tt-epc.
                      end.
                      create tt-epc.
                      assign tt-epc.cod-event     = "bh-ped-item":U
                             tt-epc.cod-parameter = "ped-item rowid":U
                             tt-epc.val-parameter = string(ROWID(movdis.ped-item )).
                      
                      {include/i-epc201.i "bh-ped-item"}
                      
                      /*Fim  UPC Tratamento Tabelas Espec¡ficas*/                      

                      on delete of movdis.ped-item override do: end.
                      delete movdis.ped-item validate(true,"").

                      find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "ped-item" NO-ERROR.
                      assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             /* -------------------------- Exporta Ped-Repre --------------------------- */
             {utp/ut-liter.i Representantes}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.

             for each movdis.ped-repre where movdis.ped-repre.nr-pedido = movdis.ped-venda.nr-pedido exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0201a.p ("ped-repre", rowid(movdis.ped-repre)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 16
                            tt-erro-bh.r-rowid  = ROWID(movdis.ped-repre).
                     UNDO Blk_PedVenda, NEXT Blk_PedVenda.
                 END.

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                 /* NÆo existe a tabela "his-ped-repre" no mgdis.*/
                 /* ------------------------------------------------------------------------ */

                 on delete of movdis.ped-repre override do: end.
                 delete movdis.ped-repre validate(true,"").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "ped-repre" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             /* --------------------------- Exporta Cond-Ped --------------------------- */
             {utp/ut-liter.i Cond_Pagto_Esp}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.

             for each movdis.cond-ped where movdis.cond-ped.nr-pedido = movdis.ped-venda.nr-pedido exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).                          

                 run bhp/bh0201a.p ("cond-ped", rowid(movdis.cond-ped)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 18
                            tt-erro-bh.r-rowid  = ROWID(movdis.cond-ped).
                     UNDO Blk_PedVenda, NEXT Blk_PedVenda.
                 END.

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                 /* NÆo existe a tabela "his-cond-ped" no mgdis.*/
                 /* ------------------------------------------------------------------------ */

                 on delete of movdis.cond-ped override do: end.
                 delete movdis.cond-ped validate(true,"").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "cond-ped" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             run bhp/bh0201a.p ("ped-venda", rowid(movdis.ped-venda)).

             IF  RETURN-VALUE = "NOK":U THEN DO:
                 CREATE tt-erro-bh.
                 ASSIGN tt-erro-bh.i-tabela = 12
                        tt-erro-bh.r-rowid  = ROWID(movdis.ped-venda).
                 UNDO Blk_PedVenda, NEXT Blk_PedVenda.
             END.

             /* ------------------------- Cria Tabela de Locks ------------------------- */
                create his-ped-venda.
                assign his-ped-venda.nr-pedido  = movdis.ped-venda.nr-pedido
                       his-ped-venda.nr-pedcli  = movdis.ped-venda.nr-pedcli
                       his-ped-venda.nome-abrev = movdis.ped-venda.nome-abrev.
             /* ------------------------------------------------------------------------ */ 

            /*Ini UPC Tratamento Tabelas Espec¡ficas*/

            for each tt-epc 
                where tt-epc.cod-event = "bh-ped-venda":U:
                delete tt-epc.
            end.
            create tt-epc.
            assign tt-epc.cod-event     = "bh-ped-venda":U
                   tt-epc.cod-parameter = "ped-venda rowid":U
                   tt-epc.val-parameter = string(ROWID(movdis.ped-venda )).

            {include/i-epc201.i "bh-ped-venda"}

            /*Fim  UPC Tratamento Tabelas Espec¡ficas*/

             on delete of movdis.ped-venda override do: end.
             delete movdis.ped-venda validate(true,"").

             find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "ped-venda" NO-ERROR.
             assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
    end.    

End Procedure.


Procedure Pi-Exporta-Estatistica:


    /* ----------------------------------------------------------------------- */
    /* ------------------------- Exporta Estat¡stica ------------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Estat¡sticas}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.

    do trans:
        find first bh-periodos where 
                   bh-periodos.ep-codigo = param-global.empresa-prin and
                   bh-periodos.modulos   = "FT" exclusive-lock no-error.
        if  not avail bh-periodos then do:
            create bh-periodos.
            assign bh-periodos.ep-codigo = param-global.empresa-prin
                   bh-periodos.modulos   = "FT"
                   bh-periodos.area      = "D".
        end.
        assign bh-periodos.periodo = tt-param.da-per-corte.
    end.    

    Blk_FatEstat:
    for each movdis.fat-estat where 
             movdis.fat-estat.data-estat <= tt-param.da-per-corte exclusive-lock transaction:

             assign i-cont = i-cont + 1.
             run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

             run bhp/bh0201a.p ("fat-estat", rowid(movdis.fat-estat)).

             IF  RETURN-VALUE = "NOK":U THEN DO:
                 CREATE tt-erro-bh.
                 ASSIGN tt-erro-bh.i-tabela = 19
                        tt-erro-bh.r-rowid  = ROWID(movdis.fat-estat).
                 UNDO Blk_FatEstat, NEXT Blk_FatEstat.
             END.

             /* ------------------------- Cria Tabela de Locks ------------------------- */
             /* NÆo existe a tabela "his-fat-estat" no mgdis.*/
             /* ------------------------------------------------------------------------ */

             on delete of movdis.fat-estat override do: end.
             delete movdis.fat-estat validate(true,"").

             find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "fat-estat" NO-ERROR.
             assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
    end.

End Procedure.


Procedure Pi-Exporta-OF:


    /* ----------------------------------------------------------------------- */
    /* --------------------- Exporta Obriga‡äes Fiscais ---------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Obriga‡äes_Fiscais}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.

    do trans:
        find first bh-periodos where 
                   bh-periodos.ep-codigo = param-global.empresa-prin and
                   bh-periodos.modulos   = "OF" exclusive-lock no-error.
        if  not avail bh-periodos then do:
            create bh-periodos.
            assign bh-periodos.ep-codigo = param-global.empresa-prin
                   bh-periodos.modulos   = "OF"
                   bh-periodos.area      = "D".
        end.
        assign bh-periodos.periodo = tt-param.da-per-corte.
    end.    

    Blk_DocFiscal:
    for each  movdis.doc-fiscal 
        WHERE movdis.doc-fiscal.dt-docto <= tt-param.da-per-corte exclusive-lock transaction:
        /*WHERE year(movdis.doc-fiscal.dt-docto) <= tt-param.ano-of exclusive-lock transaction:*/

             assign i-cont = i-cont + 1.
             run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

             /* ------------------------- Exporta It-Doc-Fisc -------------------------- */
             {utp/ut-liter.i Itens}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.  

             for each movdis.it-doc-fisc of movdis.doc-fiscal exclusive-lock:
                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).                          

                 run bhp/bh0201a.p ("it-doc-fisc", rowid(movdis.it-doc-fisc)).

                 IF  return-value = "NOK":U  THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 21
                            tt-erro-bh.r-rowid  = ROWID(movdis.it-doc-fisc).
                     UNDO Blk_DocFiscal, NEXT Blk_DocFiscal.
                 END.

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                 /* NÆo existe a tabela "his-it-doc-fisc" no mgdis.*/
                 /* ------------------------------------------------------------------------ */

                 on delete of movdis.it-doc-fisc override do: end.
                 delete movdis.it-doc-fisc validate(true,"").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "it-doc-fisc" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             /* Convenio 15 */
             for first movdis.ext-doc-fiscal exclusive-lock
                 where movdis.ext-doc-fiscal.cod-estabel  = movdis.doc-fiscal.cod-estabel
                 and   movdis.ext-doc-fiscal.serie        = movdis.doc-fiscal.serie
                 and   movdis.ext-doc-fiscal.nr-doc-fis   = movdis.doc-fiscal.nr-doc-fis
                 and   movdis.ext-doc-fiscal.cod-emitente = movdis.doc-fiscal.cod-emitente
                 and   movdis.ext-doc-fiscal.nat-operacao = movdis.doc-fiscal.nat-operacao:
                 
                 run bhp/bh0201a.p ("ext-doc-fiscal", rowid(movdis.ext-doc-fiscal)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 31
                            tt-erro-bh.r-rowid  = ROWID(movdis.ext-doc-fiscal).
                     UNDO Blk_DocFiscal, NEXT Blk_DocFiscal.
                 END.

                 on delete of movdis.ext-doc-fiscal override do: end.
                 delete movdis.ext-doc-fiscal validate(true,"").

                 find first tt-estat-modulo 
                     where  tt-estat-modulo.c-nom-tab = "ext-doc-fiscal" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             run bhp/bh0201a.p ("doc-fiscal", rowid(movdis.doc-fiscal)).

             IF  RETURN-VALUE = "NOK":U THEN DO:
                 CREATE tt-erro-bh.
                 ASSIGN tt-erro-bh.i-tabela = 20
                        tt-erro-bh.r-rowid  = ROWID(movdis.doc-fiscal).
                 UNDO Blk_DocFiscal, NEXT Blk_DocFiscal.
             END.

             /* ------------------------- Cria Tabela de Locks ------------------------- */
                create his-doc-fiscal.
                assign his-doc-fiscal.cod-estabel  = movdis.doc-fiscal.cod-estabel
                       his-doc-fiscal.serie        = movdis.doc-fiscal.serie
                       his-doc-fiscal.nr-doc-fis   = movdis.doc-fiscal.nr-doc-fis
                       his-doc-fiscal.cod-emitente = movdis.doc-fiscal.cod-emitente
                       his-doc-fiscal.nat-operacao = movdis.doc-fiscal.nat-operacao.
             /* ------------------------------------------------------------------------ */ 

             on delete of movdis.doc-fiscal override do: end.
             delete movdis.doc-fiscal.

             find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "doc-fiscal" NO-ERROR.
             assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
    end.                          

    /* ----------------------------------------------------------------------- */
    /* ---------------------- Exporta Apura‡Æo Imposto ----------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Apura‡Æo_Imposto}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.    

    Blk_ApurImposto:
    for each  movdis.apur-imposto 
        WHERE movdis.apur-imposto.dt-apur-fim <= tt-param.da-per-corte exclusive-lock transaction:

             assign i-cont = i-cont + 1.
             run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

             /* -------------------------- Exporta Imp-Valor --------------------------- */
             {utp/ut-liter.i Imposto}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.      

             for each movdis.imp-valor of movdis.apur-imposto exclusive-lock:
                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0201a.p ("imp-valor", rowid(movdis.imp-valor)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 23
                            tt-erro-bh.r-rowid  = ROWID(movdis.imp-valor).
                     UNDO Blk_ApurImposto, NEXT Blk_ApurImposto.
                 END.

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                 /* NÆo existe a tabela "his-imp-valor" no mgdis.*/
                 /* ------------------------------------------------------------------------ */

                 on delete of movdis.imp-valor override do: end.
                 delete movdis.imp-valor validate(true,"").

                 find first tt-estat-modulo 
                     where  tt-estat-modulo.c-nom-tab = "imp-valor" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             /* ------------------------- Exporta Imposto-Guia ------------------------- */
             {utp/ut-liter.i Guia}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.        

             for each movdis.imposto-guia of movdis.apur-imposto exclusive-lock:
                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0201a.p ("imposto-guia", rowid(movdis.imposto-guia)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 24
                            tt-erro-bh.r-rowid  = ROWID(movdis.imposto-guia).
                     UNDO Blk_ApurImposto, NEXT Blk_ApurImposto.
                 END.

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                 /* NÆo existe a tabela "his-imposto-guia" no mgdis.*/
                 /* ------------------------------------------------------------------------ */

                 on delete of movdis.imposto-guia override do: end.
                 delete movdis.imposto-guia validate(true,"").

                 find first tt-estat-modulo 
                     WHERE  tt-estat-modulo.c-nom-tab = "imposto-guia" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             run bhp/bh0201a.p ("apur-imposto", rowid(movdis.apur-imposto)).

             IF  RETURN-VALUE = "NOK":U THEN DO:
                 CREATE tt-erro-bh.
                 ASSIGN tt-erro-bh.i-tabela = 22
                        tt-erro-bh.r-rowid  = ROWID(movdis.apur-imposto).
                 UNDO Blk_ApurImposto, NEXT Blk_ApurImposto.
             END.

             &IF '{&bf_dis_versao_ems}' >= "2.04" &THEN

             /* ------------------------- Cria Tabela de Locks ------------------------- */
                FIND FIRST his-apur-imposto 
                    WHERE  his-apur-imposto.cod-estabel  = movdis.apur-imposto.cod-estabel 
                    AND    his-apur-imposto.tp-imposto   = movdis.apur-imposto.tp-imposto  
                    AND    his-apur-imposto.dt-apur-ini  = movdis.apur-imposto.dt-apur-ini 
                    AND    his-apur-imposto.dt-apur-fim  = movdis.apur-imposto.dt-apur-fim NO-LOCK NO-ERROR.
                IF NOT AVAIL his-apur-impos THEN DO:
                    create his-apur-imposto.
                    assign his-apur-imposto.cod-estabel  = movdis.apur-imposto.cod-estabel
                           his-apur-imposto.tp-imposto   = movdis.apur-imposto.tp-imposto
                           his-apur-imposto.dt-apur-ini  = movdis.apur-imposto.dt-apur-ini
                           his-apur-imposto.dt-apur-fim  = movdis.apur-imposto.dt-apur-fim.
                END.
             /* ------------------------------------------------------------------------ */ 
             &ENDIF

             on delete of movdis.apur-imposto override do: end.
             delete movdis.apur-imposto.

             find first tt-estat-modulo 
                 where  tt-estat-modulo.c-nom-tab = "apur-imposto" NO-ERROR.
             assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
    end.         
End Procedure.

Procedure Pi-Exporta-Cotacao:


    /* ----------------------------------------------------------------------- */
    /* --------------------------- Exporta Cota‡äes -------------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Cota‡äes}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.

    do trans:
        find first bh-periodos where 
                   bh-periodos.ep-codigo = param-global.empresa-prin and
                   bh-periodos.modulos   = "QO" exclusive-lock no-error.
        if  not avail bh-periodos then do:
            create bh-periodos.
            assign bh-periodos.ep-codigo = param-global.empresa-prin
                   bh-periodos.modulos   = "QO"
                   bh-periodos.area      = "D".
        end.
        assign bh-periodos.periodo = tt-param.da-per-corte.
    end.    
    &IF '{&bf_dis_versao_ems}' < "2.04" &THEN    
        for each movdis.cot-ped-v where
                 movdis.cot-ped-v.dt-implant  <= tt-param.da-per-corte and
                 movdis.cot-ped-v.ind-situacao = 3 exclusive-lock transaction: /* Liberado Total */

                 assign i-cont = i-cont + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

                 /* ---------- Exporta Cot-Ped-I/Cot-Nar-It/Cot-Ent/Cot-Desconto ----------- */
                 {utp/ut-liter.i Itens}.
                 assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                        i-cont-aux1      = 0.                    
                 for each movdis.cot-ped-i of movdis.cot-ped-v exclusive-lock:

                     assign i-cont-aux1 = i-cont-aux1 + 1.
                     run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                     {utp/ut-liter.i Narrativa}
                     assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                            i-cont-aux2      = 0.

                     for each movdis.cot-nar-it of movdis.cot-ped-i exclusive-lock:

                         assign i-cont-aux2 = i-cont-aux2 + 1.
                         run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                         run bhp/bh0201b.p ("cot-nar-it", rowid(movdis.cot-nar-it)).
                         on delete of movdis.cot-nar-it override do: end.
                         delete movdis.cot-nar-it validate(true,"").

                         find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "cot-nar-it" NO-ERROR.
                         assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                     end.                        

                     run bhp/bh0201b.p ("cot-ped-i", rowid(movdis.cot-ped-i)).
                     on delete of movdis.cot-ped-i override do: end.
                     delete movdis.cot-ped-i validate(true,"").
                     
                     find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "cot-ped-i" NO-ERROR.
                     assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                 end.

                 run bhp/bh0201b.p ("cot-ped-v", rowid(movdis.cot-ped-v)).

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                    create his-cot-ped-v.
                    assign his-cot-ped-v.nr-pedido  = movdis.cot-ped-v.nr-pedido.
                 /* ------------------------------------------------------------------------ */ 

                 on delete of movdis.cot-ped-v override do: end.
                 delete movdis.cot-ped-v.
                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "cot-ped-v" NO-ERROR.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

        end.                      
    &ENDIF

End Procedure.


Procedure Pi-Imprime-Estat¡stica:


    assign c-programa = "BH0201"
           c-versao   = "2.00.00"
           c-revisao  = "000"
           c-empresa  = param-global.grupo.

    {utp/ut-liter.i Bancos_Hist¢ricos * C}                                c-sistema      = trim(return-value).
    {utp/ut-liter.i Estat¡sticas_Export.p/Banco_Hist¢rico_Distribui‡Æo * C} c-titulo-relat = trim(return-value).

    view frame f-cabec.
    view frame f-rodape.

    {utp/ut-liter.i Imprimindo_Erros}.    
    run pi-acompanhar in h-acomp (input trim(return-value)).    
    /* ---------------------- Imprime Relat¢rio de Erros ---------------------- */
    IF  CAN-FIND (FIRST tt-erro-bh) THEN DO:
        {utp/ut-liter.i REGISTROS_QUE_APRESENTARAM_PROBLEMAS_NA_EXPORTA€ÇO_PARA_OS_BANCOS_HISTàRICOS}
        PUT UNFORMATTED FILL("-",(132 - (INT((132 - LENGTH(TRIM(RETURN-VALUE))) / 2)) - LENGTH(TRIM(RETURN-VALUE))))
                    TRIM(RETURN-VALUE)  FILL("-",(INT((132 - LENGTH(TRIM(RETURN-VALUE))) / 2))) SKIP(1).                        

        /* 1 - nota-fiscal */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 1) THEN DO:

            {utp/ut-liter.i Notas_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 1,
                FIRST nota-fiscal FIELDS(cod-estabel serie nr-nota-fis)
                WHERE ROWID(nota-fiscal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP nota-fiscal.cod-estabel  
                     nota-fiscal.serie        
                     nota-fiscal.nr-nota-fis WITH FRAME f-nota-fiscal DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 2 - it-nota-fisc */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 2) THEN DO:

            {utp/ut-liter.i Itens_Notas_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 2,
                FIRST it-nota-fisc FIELDS(cod-estabel serie nr-nota-fis nr-seq-fat it-codigo)
                WHERE ROWID(it-nota-fisc) = tt-erro-bh.r-rowid NO-LOCK:
                DISP it-nota-fisc.cod-estabel  
                     it-nota-fisc.serie        
                     it-nota-fisc.nr-nota-fis 
                     it-nota-fisc.nr-seq-fat
                     it-nota-fisc.it-codigo
                     WITH FRAME f-it-nota-fisc DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 3 - it-nota-imp */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 3) THEN DO:

            {utp/ut-liter.i Impostos_Itens}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 3,
                FIRST it-nota-imp FIELDS(cod-estabel serie nr-nota-fis nr-seq-fat it-codigo nr-seq-imp)
                WHERE ROWID(it-nota-imp) = tt-erro-bh.r-rowid NO-LOCK:
                DISP it-nota-imp.cod-estabel  
                     it-nota-imp.serie        
                     it-nota-imp.nr-nota-fis 
                     it-nota-imp.nr-seq-fat
                     it-nota-imp.it-codigo
                     it-nota-imp.nr-seq-imp
                     WITH FRAME f-it-nota-imp DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 4 - nota-trans */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 4) THEN DO:

            {utp/ut-liter.i Notas_Transportes}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 4,
                FIRST nota-trans FIELDS(cod-estabel serie nr-nota-fis)
                WHERE ROWID(nota-trans) = tt-erro-bh.r-rowid NO-LOCK:
                DISP nota-trans.cod-estabel  
                     nota-trans.serie        
                     nota-trans.nr-nota-fis 
                     WITH FRAME f-nota-trans DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 5 - fat-ser-lote */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 5) THEN DO:

            {utp/ut-liter.i Aloca‡Æo_Itens_Notas_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 5,
                FIRST fat-ser-lote FIELDS(cod-estabel serie nr-nota-fis nr-seq-fat cod-depos 
                                          cod-localiz nr-serlote it-codigo 
                                          &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                                          cod-refer
                                          &endif )
                WHERE ROWID(fat-ser-lote) = tt-erro-bh.r-rowid NO-LOCK:
                DISP fat-ser-lote.cod-estabel  
                     fat-ser-lote.serie        
                     fat-ser-lote.nr-nota-fis 
                     fat-ser-lote.nr-seq-fat
                     fat-ser-lote.cod-depos
                     fat-ser-lote.cod-localiz
                     fat-ser-lote.nr-serlote
                     fat-ser-lote.it-codigo
                     &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                     fat-ser-lote.cod-refer
                     &ENDIF
                     WITH FRAME f-fat-ser-lote DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 6 - nar-it-nota */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 6) THEN DO:

            {utp/ut-liter.i Narrativa_Itens_Notas_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 6,
                FIRST nar-it-nota FIELDS(cod-estabel serie nr-nota-fis nr-sequencia)
                WHERE ROWID(nar-it-nota) = tt-erro-bh.r-rowid NO-LOCK:
                DISP nar-it-nota.cod-estabel  
                     nar-it-nota.serie        
                     nar-it-nota.nr-nota-fis 
                     nar-it-nota.nr-sequencia
                     WITH FRAME f-nar-it-nota DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 7 - fat-repre */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 7) THEN DO:

            {utp/ut-liter.i Representante_Fatura}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 7,
                FIRST fat-repre FIELDS(cod-estabel serie nr-fatura nome-ab-rep &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN cod-classificador &endif )
                WHERE ROWID(fat-repre) = tt-erro-bh.r-rowid NO-LOCK:
                DISP fat-repre.cod-estabel  
                     fat-repre.serie        
                     fat-repre.nr-fatura
                     fat-repre.nome-ab-rep
                     &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                     fat-repre.cod-classificador
                     &ENDIF
                     WITH FRAME f-fat-repre DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 8 - fat-duplic */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 8) THEN DO:

            {utp/ut-liter.i Faturas_Nota_Fiscal}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 8,
                FIRST fat-duplic FIELDS(cod-estabel serie nr-fatura parcela)
                WHERE ROWID(fat-duplic) = tt-erro-bh.r-rowid NO-LOCK:
                DISP fat-duplic.cod-estabel  
                     fat-duplic.serie        
                     fat-duplic.nr-fatura
                     fat-duplic.parcela
                     WITH FRAME f-fat-duplic DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 9 - nota-embal */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 9) THEN DO:

            {utp/ut-liter.i Embalagens_Nota_Fiscal}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 9,
                FIRST nota-embal FIELDS(cod-estabel serie nr-nota-fis sigla-emb)
                WHERE ROWID(nota-embal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP nota-embal.cod-estabel  
                     nota-embal.serie        
                     nota-embal.nr-nota-fis 
                     nota-embal.sigla-emb
                     WITH FRAME f-nota-embal DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 10 - item-embal */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 10) THEN DO:

            {utp/ut-liter.i Embalagens_Itens_Notas_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 10,
                FIRST item-embal FIELDS(cod-estabel serie nr-nota-fis nr-seq-fat it-codigo sigla-emb)
                WHERE ROWID(item-embal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP item-embal.cod-estabel  
                     item-embal.serie        
                     item-embal.nr-nota-fis 
                     item-embal.nr-seq-fat
                     item-embal.it-codigo
                     item-embal.sigla-emb
                     WITH FRAME f-item-embal DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 11 - devol-cli */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 11) THEN DO:

            {utp/ut-liter.i Devolu‡Æo_Clientes}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 11,
                FIRST devol-cli FIELDS(dt-devol nome-ab-emi it-codigo cod-estabel)
                WHERE ROWID(devol-cli) = tt-erro-bh.r-rowid NO-LOCK:
                DISP devol-cli.dt-devol
                     devol-cli.nome-ab-emi
                     devol-cli.it-codigo
                     devol-cli.cod-estabel
                     WITH FRAME f-devol-cli DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 12 - ped-venda */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 12) THEN DO:

            {utp/ut-liter.i Pedidos_Vendas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 12,
                FIRST ped-venda FIELDS(nome-abrev nr-pedcli)
                WHERE ROWID(ped-venda) = tt-erro-bh.r-rowid NO-LOCK:
                DISP ped-venda.nome-abrev
                     ped-venda.nr-pedcli
                     WITH FRAME f-ped-venda DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 13 - ped-item */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 13) THEN DO:

            {utp/ut-liter.i Itens_Pedidos_Vendas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 13,
                FIRST ped-item FIELDS(nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer)
                WHERE ROWID(ped-item) = tt-erro-bh.r-rowid NO-LOCK:
                DISP ped-item.nome-abrev
                     ped-item.nr-pedcli
                     ped-item.nr-sequencia
                     ped-item.it-codigo
                     ped-item.cod-refer
                     WITH FRAME f-ped-item DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 14 - ped-ent */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 14) THEN DO:

            {utp/ut-liter.i Entregas_Itens_Pedidos_Vendas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 14,
                FIRST ped-ent FIELDS(nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer nr-entrega)
                WHERE ROWID(ped-ent) = tt-erro-bh.r-rowid NO-LOCK:
                DISP ped-ent.nome-abrev
                     ped-ent.nr-pedcli
                     ped-ent.nr-sequencia
                     ped-ent.it-codigo
                     ped-ent.cod-refer
                     ped-ent.nr-entrega
                     WITH FRAME f-ped-ent DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 16 - ped-repre */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 16) THEN DO:

            {utp/ut-liter.i Representantes_Pedidos_Vendas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 16,
                FIRST ped-repre FIELDS(nr-pedido nome-ab-rep &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN cod-classificador &endif )
                WHERE ROWID(ped-repre) = tt-erro-bh.r-rowid NO-LOCK:
                DISP ped-repre.nr-pedido
                     ped-repre.nome-ab-rep
                     &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                     ped-repre.cod-classificador
                     &ENDIF
                     WITH FRAME f-ped-repre DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 18 - cond-ped */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 18) THEN DO:

            {utp/ut-liter.i Condi‡äes_Pagtos_Especiais_Pedidos_Vendas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 18,
                FIRST cond-ped FIELDS(nr-pedido nr-sequencia)
                WHERE ROWID(cond-ped) = tt-erro-bh.r-rowid NO-LOCK:
                DISP cond-ped.nr-pedido
                     cond-ped.nr-sequencia
                     WITH FRAME f-cond-ped DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 19 - fat-estat */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 19) THEN DO:

            {utp/ut-liter.i Estat¡sticas_Faturamento}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 19,
                FIRST fat-estat FIELDS(data-estat cod-estabel nome-ab-cli)
                WHERE ROWID(fat-estat) = tt-erro-bh.r-rowid NO-LOCK:
                DISP fat-estat.data-estat
                     fat-estat.cod-estabel
                     fat-estat.nome-ab-cli
                     WITH FRAME f-fat-estat DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 20 - doc-fiscal */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 20) THEN DO:

            {utp/ut-liter.i Documentos_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 20,
                FIRST doc-fiscal FIELDS(cod-estabel serie nr-doc-fis cod-emitente nat-operacao)
                WHERE ROWID(doc-fiscal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP doc-fiscal.cod-estabel  
                     doc-fiscal.serie        
                     doc-fiscal.nr-doc-fis   
                     doc-fiscal.cod-emitente 
                     doc-fiscal.nat-operacao 
                     WITH FRAME f-doc-fiscal DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 21 - it-doc-fisc */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 21) THEN DO:

            {utp/ut-liter.i Itens_do_Documento_Fiscal}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).       

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 21,
                FIRST it-doc-fisc FIELDS(cod-estabel serie nr-doc-fis cod-emitente nat-operacao nr-seq-doc it-codigo)
                WHERE ROWID(it-doc-fisc) = tt-erro-bh.r-rowid NO-LOCK:
                DISP it-doc-fisc.cod-estabel  
                     it-doc-fisc.serie        
                     it-doc-fisc.nr-doc-fis   
                     it-doc-fisc.cod-emitente 
                     it-doc-fisc.nat-operacao 
                     it-doc-fisc.nr-seq-doc   
                     it-doc-fisc.it-codigo 
                     WITH FRAME f-it-doc-fisc DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 22 - apur-imposto */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 22) THEN DO:

            {utp/ut-liter.i Apura‡Æo_Impostos}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).       

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 22,
                FIRST apur-imposto FIELDS(cod-estabel tp-imposto dt-apur-ini dt-apur-fim)
                WHERE ROWID(apur-imposto) = tt-erro-bh.r-rowid NO-LOCK:
                DISP apur-imposto.cod-estabel
                     {diinc/i01di220.i 04 apur-imposto.tp-imposto} 
                     apur-imposto.dt-apur-ini
                     apur-imposto.dt-apur-fim
                     WITH FRAME f-apur-imposto DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 23 - imp-valor */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 23) THEN DO:

            {utp/ut-liter.i Valor_Impostos}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).       

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 23,
                FIRST imp-valor FIELDS(cod-estabel tp-imposto dt-apur-ini dt-apur-fim cod-lanc nr-sequencia)
                WHERE ROWID(imp-valor) = tt-erro-bh.r-rowid NO-LOCK:
                DISP imp-valor.cod-estabel
                     {diinc/i01di220.i 04 imp-valor.tp-imposto} 
                     imp-valor.dt-apur-ini
                     imp-valor.dt-apur-fim
                     imp-valor.cod-lanc
                     imp-valor.nr-sequencia
                     WITH FRAME f-imp-valor DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 24 - imposto-guia */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 24) THEN DO:

            {utp/ut-liter.i Guia_Impostos}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).       

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 24,
                FIRST imposto-guia FIELDS(cod-estabel tp-imposto dt-apur-ini dt-apur-fim nr-guia nr-sequencia)
                WHERE ROWID(imposto-guia) = tt-erro-bh.r-rowid NO-LOCK:
                DISP imposto-guia.cod-estabel
                     {diinc/i01di220.i 04 imposto-guia.tp-imposto} 
                     imposto-guia.dt-apur-ini
                     imposto-guia.dt-apur-fim
                     imposto-guia.nr-guia
                     imposto-guia.nr-sequencia
                     WITH FRAME f-imposto-guia DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 25 - ext-doc-fiscal */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 31) THEN DO:

            {utp/ut-liter.i ExtensÆo_Documentos_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).
      
            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 31,
                FIRST ext-doc-fiscal FIELDS(cod-estabel serie nr-doc-fis cod-emitente nat-operacao)
                WHERE ROWID(ext-doc-fiscal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP ext-doc-fiscal.cod-estabel  
                     ext-doc-fiscal.serie        
                     ext-doc-fiscal.nr-doc-fis   
                     ext-doc-fiscal.cod-emitente 
                     ext-doc-fiscal.nat-operacao 
                     WITH FRAME f-ext-doc-fiscal DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).

        END.
 /*****************************************************************************************************************************************************************/       
        /* 27 - sit-nf-eletro */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 35) THEN DO:

            {utp/ut-liter.i Situa‡Æo_Notas_Fiscais_Eletronicas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).
      
            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 35,
                FIRST sit-nf-eletro FIELDS(cod-nota-fisc cod-serie idi-sit-nf-eletro dt-emis-nota cod-estabel)
                WHERE ROWID(sit-nf-eletro) = tt-erro-bh.r-rowid NO-LOCK:
                DISP sit-nf-eletro.cod-nota-fisc    
                     sit-nf-eletro.cod-serie
                     sit-nf-eletro.idi-sit-nf-eletro
                     sit-nf-eletro.dt-emis-nota
                     sit-nf-eletro.cod-estabel
                     WITH FRAME f-sit-nf-eletro DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).

        END.

        /* 28 - ret-nf-eletro */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 36) THEN DO:

            {utp/ut-liter.i Retorno_Notas_Fiscais_Eletronicas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).
      
            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 36,
                FIRST ret-nf-eletro FIELDS(cod-estabel cod-serie nr-nota-fis cod-msg dat-ret hra-ret)
                WHERE ROWID(ret-nf-eletro) = tt-erro-bh.r-rowid NO-LOCK:
                DISP ret-nf-eletro.cod-estabel
                     ret-nf-eletro.cod-serie
                     ret-nf-eletro.nr-nota-fis
                     ret-nf-eletro.cod-msg
                     ret-nf-eletro.dat-ret
                     ret-nf-eletro.hra-ret
                     WITH FRAME f-ret-nf-eletro DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).

        END.

        /* 29 - nota-fisc-social */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 32) THEN DO:

            {utp/ut-liter.i eSocial}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 32,
                FIRST nota-fisc-social FIELDS(cod-estabel cod-serie cod-nota-fisc)
                WHERE ROWID(nota-fisc-social) = tt-erro-bh.r-rowid NO-LOCK:
                DISP nota-fisc-social.cod-estabel  
                     nota-fisc-social.cod-serie        
                     nota-fisc-social.cod-nota-fis WITH FRAME f-nota-fisc-social DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 30 - item-nota-social */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 33) THEN DO:

            {utp/ut-liter.i Itens_eSocial}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 33,
                FIRST item-nota-social FIELDS(cod-estabel cod-serie cod-nota-fisc cdn-serv-inss)
                WHERE ROWID(item-nota-social) = tt-erro-bh.r-rowid NO-LOCK:
                DISP item-nota-social.cod-estabel  
                     item-nota-social.cod-serie        
                     item-nota-social.cod-nota-fis 
                     item-nota-social.cdn-serv-inss
                     WITH FRAME f-item-nota-social DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

       
      /*  /* 29 - msg-ret-nf-e */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 29) THEN DO:

            {utp/ut-liter.i Mensagens_Retorno_Notas_Fiscais_Eletronicas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).
      
            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 29,
                FIRST msg-ret-nf-e FIELDS()
                WHERE ROWID(ext-doc-fiscal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP 
                     WITH FRAME f-msg-ret-nf-e DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).

        END.*/
/*****************************************************************************************************************************************************************/
    END.

    /* ------------------- Imprime Relat¢rio de Estat¡sticas ------------------ */
    {utp/ut-liter.i Imprimindo_Estat¡sticas}.    
    run pi-acompanhar in h-acomp (input trim(return-value)).    

    IF  CAN-FIND(FIRST tt-erro-bh) THEN
        PAGE.
    
    /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
    DEFINE VARIABLE c-lbl-liter-tabelas-movidas-para-bancos-hi AS CHARACTER FORMAT "X(40)" NO-UNDO.
    {utp/ut-liter.i "Tabelas_Movidas_para_Bancos_Hist¢ricos" *}
    ASSIGN c-lbl-liter-tabelas-movidas-para-bancos-hi = TRIM(RETURN-VALUE).
    DISP c-lbl-liter-tabelas-movidas-para-bancos-hi FORMAT "x(50)" SKIP(01) WITH STREAM-IO WIDTH 132 FRAME f-tab-mov.
    
    for each tt-estat-modulo WHERE 
        tt-estat-modulo.c-nom-tab <> "" break by tt-estat-modulo.c-nom-tab:
        disp tt-estat-modulo.c-modulo  
             tt-estat-modulo.c-nom-tab 
             tt-estat-modulo.c-tabela  
             tt-estat-modulo.i-modulo  SKIP WITH STREAM-IO WIDTH 132.
        down.

        assign de-total = de-total + tt-estat-modulo.i-modulo.      
    end.    

    display de-total with frame f-total.

    /* --------------------- Imprime Página de Parâmetros --------------------- */
    {utp/ut-liter.i Imprimindo_Parƒmetros}.    
    run pi-acompanhar in h-acomp (input trim(return-value)).    

    page.   

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 tt-param.destino}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  c-destino = RETURN-VALUE.
    &else
        ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.
    &endif
    {utp/ut-liter.i Sim * C}
    if  tt-param.l-pedfat  then c-pedfat  = trim(return-value).
    if  tt-param.l-estat   then c-estat   = trim(return-value).
    if  tt-param.l-of      then c-of      = trim(return-value).
    if  tt-param.l-cotacao then c-cotacao = trim(return-value).
    {utp/ut-liter.i NÆo * C}
    if  not tt-param.l-pedfat  then c-pedfat  = trim(return-value).
    if  not tt-param.l-estat   then c-estat   = trim(return-value).
    if  not tt-param.l-of      then c-of      = trim(return-value).
    if  not tt-param.l-cotacao then c-cotacao = trim(return-value).

    disp c-parametros
         tt-param.da-per-corte
         c-pedfat
         c-estat
         c-of
         c-cotacao
         c-impressao
         c-destino
         tt-param.arquivo
         tt-param.usuario
         with frame f-parametros.  

    /*if tt-param.ano-of <> 0000 then disp tt-param.ano-of with frame f-parametros.  */

End Procedure.


Procedure Pi-Gera-tt-estat-modulo:

    define variable i-nr-tab      as INTEGER            no-undo. /* Tabelas que fazem parte dos Bancos Hist¢ricos */
    define variable c-faturamento as character          no-undo.
    define variable c-pedido      as character          no-undo.
    define variable c-estatistica as character          no-undo.
    define variable c-obrigfisc   as character          no-undo.
    define variable c-cotacoes    as character          no-undo.

    ASSIGN i-nr-tab = 36.
    
    for each tt-estat-modulo: delete tt-estat-modulo. end.

    do i-cont = 1 to i-nr-tab:
       create tt-estat-modulo.
       assign tt-estat-modulo.i-sequencia = i-cont.
    end. 


    ASSIGN c-faturamento = "FT"
           c-pedido      = "PD"
           c-estatistica = "FT"
           c-obrigfisc   = "OF"
           c-cotacoes    = "QO".


/*     {utp/ut-liter.i Faturamento        * C} c-faturamento = trim(return-value). */
/*     {utp/ut-liter.i Pedidos            * C} c-pedido      = trim(return-value). */
/*     {utp/ut-liter.i Estat¡stica        * C} c-estatistica = trim(return-value). */
/*     {utp/ut-liter.i Obriga‡äes_Fiscais * C} c-obrigfisc   = trim(return-value). */
/*     {utp/ut-liter.i Cota‡äes           * C} c-cotacoes    = trim(return-value). */

    for each tt-estat-modulo:
        case tt-estat-modulo.i-sequencia:
             when 01 then do:
                 {utp/ut-table.i movdis nota-fiscal 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "nota-fiscal"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 02 then do:
                 {utp/ut-table.i movdis it-nota-fisc 1}	
                 assign tt-estat-modulo.c-tabela = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "it-nota-fisc"
                        tt-estat-modulo.c-modulo = c-faturamento.
             end.
             when 03 then do:
                 {utp/ut-table.i movdis it-nota-imp 1}	
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "it-nota-imp"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 04 then do:
                 {utp/ut-table.i movdis nota-trans 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "nota-trans"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 05 then do:
                 {utp/ut-table.i movdis fat-ser-lote 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "fat-ser-lote"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 06 then do:
                 {utp/ut-table.i movdis nar-it-nota 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "nar-it-nota"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 07 then do:
                 {utp/ut-table.i movdis fat-repre 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "fat-repre"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 08 then do:
                 {utp/ut-table.i movdis fat-duplic 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "fat-duplic"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 09 then do:
                 {utp/ut-table.i movdis nota-embal 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "nota-embal"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 10 then do:
                 {utp/ut-table.i movdis item-embal 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "item-embal"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 11 then do:
                 {utp/ut-table.i movdis devol-cli 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "devol-cli"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 12 then do:
                 {utp/ut-table.i movdis ped-venda 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "ped-venda"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 13 then do:
                 {utp/ut-table.i movdis ped-item 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "ped-item"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 14 then do:
                 {utp/ut-table.i movdis ped-ent 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "ped-ent"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 15 then do:
                 {utp/ut-table.i movdis his-ped-ent 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "his-ped-ent"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 16 then do:
                 {utp/ut-table.i movdis ped-repre 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "ped-repre"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 18 then do:
                 {utp/ut-table.i movdis cond-ped 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "cond-ped"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 19 then do:
                 {utp/ut-table.i movdis fat-estat 1}	
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "fat-estat"
                        tt-estat-modulo.c-modulo  = c-estatistica.
             end.
             WHEN 20 then do:
                 {utp/ut-table.i movdis doc-fiscal 1}	
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "doc-fiscal"
                        tt-estat-modulo.c-modulo  = c-obrigfisc.
             end.
             when 21 then do:
                 {utp/ut-table.i movdis it-doc-fisc 1}	
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "it-doc-fisc"
                        tt-estat-modulo.c-modulo  = c-obrigfisc.
             end.
             when 22 then do:
                 {utp/ut-table.i movdis apur-imposto 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "apur-imposto"
                        tt-estat-modulo.c-modulo  = c-obrigfisc.
             end.
             when 23 then do:
                 {utp/ut-table.i movdis imp-valor 1}	
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "imp-valor"
                        tt-estat-modulo.c-modulo  = c-obrigfisc.
             end.
             when 24 then do:
                 {utp/ut-table.i movdis imposto-guia 1}
                 assign tt-estat-modulo.c-tabela = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "imposto-guia"
                        tt-estat-modulo.c-modulo = c-obrigfisc.
             end.
             when 25 then do:
                &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
                    {utp/ut-table.i movdis cot-ped-v 1}	
                    assign tt-estat-modulo.c-tabela  = trim(return-value)
                           tt-estat-modulo.c-nom-tab = "cot-ped-v"
                           tt-estat-modulo.c-modulo  = c-cotacoes.
                &ENDIF           
             end.
             when 26 then do:
                &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
                    {utp/ut-table.i movdis cot-ped-i 1}	
                    assign tt-estat-modulo.c-tabela  = trim(return-value)
                           tt-estat-modulo.c-nom-tab = "cot-ped-i"
                           tt-estat-modulo.c-modulo  = c-cotacoes.
                &ENDIF                        
             end.
             when 27 then do:
                &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
                    {utp/ut-table.i movdis cot-nar-it 1}
                     assign tt-estat-modulo.c-tabela  = trim(return-value)
                            tt-estat-modulo.c-nom-tab = "cot-nar-it"
                            tt-estat-modulo.c-modulo  = c-cotacoes.
                &ENDIF            
             end.
             when 28 then do:
                 &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
                    {utp/ut-table.i movdis cot-ent	1}
                    assign tt-estat-modulo.c-tabela  = trim(return-value)
                           tt-estat-modulo.c-nom-tab = "cot-ent"
                           tt-estat-modulo.c-modulo  = c-cotacoes.
                 &ENDIF          
             end.
             when 29 then do:
                 &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
                    {utp/ut-table.i movdis cot-desconto 1}
                    assign tt-estat-modulo.c-tabela  = trim(return-value)
                           tt-estat-modulo.c-nom-tab = "cot-desconto"
                           tt-estat-modulo.c-modulo  = c-cotacoes.
                 &ENDIF          
             end.
             when 30 then do:	
                 {utp/ut-table.i movdis con-pges 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "con-pges"
                        tt-estat-modulo.c-modulo  = c-cotacoes.
             end.
             when 31 then do:	
                {utp/ut-table.i movdis ext-doc-fiscal 1}
                assign tt-estat-modulo.c-tabela  = trim(return-value)
                       tt-estat-modulo.c-nom-tab = "ext-doc-fiscal"
                       tt-estat-modulo.c-modulo  = c-obrigfisc.
            end.
            when 32 then do:	
                {utp/ut-table.i movadm nota-fisc-social 1}
                assign tt-estat-modulo.c-tabela  = trim(return-value)
                       tt-estat-modulo.c-nom-tab = "nota-fisc-social"
                       tt-estat-modulo.c-modulo  = c-faturamento.
            end.
            when 33 then do:	
                {utp/ut-table.i movadm item-nota-social 1}
                assign tt-estat-modulo.c-tabela  = trim(return-value)
                       tt-estat-modulo.c-nom-tab = "item-nota-social"
                       tt-estat-modulo.c-modulo  = c-faturamento.
            end.
            when 34 then do:	
                {utp/ut-table.i movdis item-nfs-st 1}
                assign tt-estat-modulo.c-tabela  = trim(return-value)
                       tt-estat-modulo.c-nom-tab = "item-nfs-st"
                       tt-estat-modulo.c-modulo  = c-faturamento.
            end.
            when 35 then do:	
                {utp/ut-table.i movdis sit-nf-eletro 1}
                assign tt-estat-modulo.c-tabela  = trim(return-value)
                       tt-estat-modulo.c-nom-tab = "sit-nf-eletro"
                       tt-estat-modulo.c-modulo  = c-faturamento.
            end.
            when 36 then do:	
                {utp/ut-table.i movdis ret-nf-eletro 1}
                assign tt-estat-modulo.c-tabela  = trim(return-value)
                       tt-estat-modulo.c-nom-tab = "ret-nf-eletro"
                       tt-estat-modulo.c-modulo  = c-faturamento.
            end.
        end.
    end.    
End Procedure.
