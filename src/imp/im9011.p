/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9011 2.00.00.023 } /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9011 MIM}
&ENDIF

/*****************************************************************************
**
** IM9011 - Integra‡Æo entre Importa‡Æo e Recebimento (EMS)
**
** Objetivo: Substituir o t¡tulo j  contabilizado do material em trƒnsito 
**           por um t¡tulo com os valores ajustados.
**
******************************************************************************/

{cdp/cdcfgmat.i} /* Pre-processador para execucao magnus */
{include/i-epc200.i IM9011} /* definicao referente a UPC */
&if defined(bf-mat-comex) &then
&else
{app/ap0504.i} /**** Defini‡Æo das temp-tables tt-duplicata e tt-digita-escolhe */ 

{cdp/cd0666.i} /**** Defini‡Æo da temp-table tt-erro ****/
{utp/ut-glob.i} /* Defini‡Æo Vari veis Globais */

DEF TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erro.
DEF VAR i-sequen-aux AS INTEGER NO-UNDO.
{app/ap9100.i}
{app/ap9100.i1}

{app/apapi034a.i1} /* Definicao tt-impto-tit-pend-ap */
{cdp/cd4300.i3} /* vari veis utilizadas pelo cd4300.i4 */

/* procedure pi-busca-portador-modalidade */
{cdp/cd9900.i5}

DEF INPUT        PARAMETER rw-docto     AS ROWID NO-UNDO.
DEF OUTPUT       PARAMETER l-subst-tit  AS LOGICAL NO-UNDO.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
DEF OUTPUT       PARAMETER l-erro-imp   AS LOGICAL NO-UNDO.

def var de-vl-nota-infdo like tit-ap.valor-saldo    no-undo.
def var i-cod-historico  like mov-ap.hp-codigo      no-undo.
def var c-desc-historico like mov-ap.historico      no-undo.
def var c-referencia     like mov-ap.referencia     no-undo.
def var da-dt-transacao  like mov-ap.dt-transacao   no-undo.
def var fi-cotacao-dia   like mov-ap.cotacao-dia    no-undo.
def var fi-mo-codigo     like mov-ap.moeda          no-undo.
/*def var c-seg-usuario    like mov-ap.usuario        no-undo.*/
def var c-conta-contab   like mov-ap.conta-contabil no-undo. 
def var c-ct-conta       like mov-ap.ct-conta       no-undo.
def var c-sc-conta       like mov-ap.sc-conta       no-undo.
def var i-tipo-subst     as   integer               no-undo.
def var i-cod-emitente   as   integer               no-undo.
def var da-ini-validac   as   date                  no-undo.
def var da-fim-validac   as   date                  no-undo.

/*variavel epc c-esp-tit-tranist*/
DEF VAR c-esp-tit-transit LIKE param-imp.esp-tit-transit NO-UNDO.

DEF BUFFER b-tit-ap FOR tit-ap.

def new global shared var v-row-tit-ap as rowid no-undo.

find first param-global no-lock no-error.

find first empresa  
     where empresa.ep-codigo  = param-global.empresa-prin no-lock no-error.

find first param-ap 
     where param-ap.ep-codigo = param-global.empresa-prin no-lock no-error.

find first docum-est 
        where rowid(docum-est) = rw-docto no-lock no-error.
    
{rep/re1001a.i50} /* vari veis e informa‡äes utilizadas pelo re1001a.i51 */

{cdp/cd4300.i4  "yes" docum-est.char-1} 

{rep/re1001a.i51 "yes"}


find first param-imp 
    where param-imp.cod-estabel = docum-est.cod-estabel no-lock no-error. 
    
find embarque-imp 
    where embarque-imp.cod-estabel = docum-est.cod-estabel 
      and embarque-imp.embarque    = c-embarque no-lock no-error.

{rep/re1001c.i50} /* vari veis e informa‡äes utilizadas pelo re1001c.i51 */

ASSIGN l-erro-imp = NO.

if avail embarque-imp and
   embarque-imp.contabilizado = YES AND
   CAN-FIND(FIRST dupli-apagar 
                WHERE dupli-apagar.serie-docto  = docum-est.serie-docto 
                  AND dupli-apagar.nro-docto    = docum-est.nro-docto 
                  AND dupli-apagar.cod-emitente = docum-est.cod-emitente 
                  AND dupli-apagar.nat-operacao = docum-est.nat-operacao NO-LOCK) THEN DO:
    assign l-subst-tit   = yes.
    for first ordens-embarque fields(numero-ordem)
        where ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          and ordens-embarque.embarque    = embarque-imp.embarque no-lock:
        for first ordem-compra fields(cod-emitente)
            where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock:
            assign i-cod-emitente = ordem-compra.cod-emitente.                
        end.
    end.

    ASSIGN c-esp-tit-transit = param-imp.esp-tit-transit.

    {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                         &CodParameter='"cod-estabel"'
                         &ValueParameter="embarque-imp.cod-estabel"}

    {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                         &CodParameter='"embarque"'
                         &ValueParameter="embarque-imp.embarque"}

    {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                         &CodParameter='"cod-fornec"'
                         &ValueParameter="string(i-cod-emitente)"}

    {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                         &CodParameter='"esp-tit-transit"'
                         &ValueParameter="c-esp-tit-transit"}
    /*Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "AlteraEspecieTitulo"}

    if c-nom-prog-dpc-mg97  <> "" or
       c-nom-prog-appc-mg97 <> "" or 
       c-nom-prog-upc-mg97  <> "" then do:

        find first tt-epc where 
                   tt-epc.cod-event = "AlteraEspecieTitulo" and
                   tt-epc.cod-parameter = "esp-tit-transit"
                   no-error.
        if avail tt-epc then
           assign c-esp-tit-transit = tt-epc.val-parameter.

        for each tt-epc:
            delete tt-epc.
        end.
    end.                                        

    run pi-substitui-titulo. /* T¡tulo a ser substitu¡do */    
end.
else
    assign l-subst-tit = no.      

FIND LAST tt-erro NO-LOCK NO-ERROR.
IF AVAIL tt-erro THEN
    ASSIGN i-sequen-aux = tt-erro.i-sequen.
FOR EACH tt-erro-aux NO-LOCK:
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = i-sequen-aux + 1
           tt-erro.cd-erro  = tt-erro-aux.cd-erro
           tt-erro.mensagem = tt-erro-aux.mensagem.
    ASSIGN i-sequen-aux = i-sequen-aux + 1.
END.

/* -------------------------------- PROCEDURES DO PROGRAMA ---------------------------------------- */
    
PROCEDURE pi-substitui-titulo.
    
    find conta-contab 
        where conta-contab.ep-codigo      = param-global.empresa-prin  
          and conta-contab.conta-contabil = docum-est.conta-transit no-lock no-error.

    assign /*c-seg-usuario  = docum-est.usuario*/
           c-conta-contab = docum-est.conta-transit
           c-ct-conta     = conta-contab.ct-codigo
           c-sc-conta     = conta-contab.sc-codigo.
    
    IF can-find (FIRST tit-ap     
        where tit-ap.ep-codigo   = param-global.empresa-prin
          and tit-ap.cod-fornec  = i-cod-emitente
          and tit-ap.cod-estabel = docum-est.cod-estabel
          and tit-ap.cod-esp     = c-esp-tit-transit
          and tit-ap.serie       = " " 
          and tit-ap.nr-docto    = embarque-imp.embarque
          AND tit-ap.valor-saldo = 0) THEN DO:
    
            create tt-erro-aux.
            
            run utp/ut-msgs.p (input "msg":U,
                               input 30176,
                               input "").
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Titulo_de_substitui‡Æo_nÆo_pode_ser_criado" *}
            assign tt-erro-aux.i-sequen = i-sequen-aux + 1
                   tt-erro-aux.cd-erro  = 30176
                   tt-erro-aux.mensagem = RETURN-VALUE + "!".
            ASSIGN l-erro-imp = YES.
            undo, leave.
    
    END.
    ELSE DO:
    
        for each tit-ap     
            where tit-ap.ep-codigo   = param-global.empresa-prin
              and tit-ap.cod-fornec  = i-cod-emitente
              and tit-ap.cod-estabel = docum-est.cod-estabel
              and tit-ap.cod-esp     = c-esp-tit-transit
              and tit-ap.serie       = " " 
              and tit-ap.nr-docto    = embarque-imp.embarque NO-LOCK:
            
            run pi-limpa-temp-tables.
            
            find dupli-apagar 
                where dupli-apagar.serie-docto  = docum-est.serie-docto 
                  and dupli-apagar.nro-docto    = docum-est.nro-docto
                  and dupli-apagar.cod-emitente = docum-est.cod-emitente
                  and dupli-apagar.nat-operacao = docum-est.nat-operacao
                  and dupli-apagar.parcela      = tit-ap.parcela no-lock no-error.
            
            if  avail dupli-apagar then do:
                
                {cdp/cd4300.i4  "yes" dupli-apagar.char-1} 
                
                {rep/re1001c.i51 "yes"}
                
                assign fi-cotacao-dia  = dupli-apagar.vl-a-pagar / de-vl-a-pagar-mo
                       c-referencia    = tit-ap.referencia 
                       da-dt-transacao = dupli-apagar.dt-trans /*tit-ap.dt-transacao */
                       fi-mo-codigo    = i-mo-codigo
                       i-tipo-subst    = 2.  /* Substitui‡Æo */
                
                IF  AVAIL empresa 
                AND AVAIL param-ap THEN DO:
                    ASSIGN da-ini-validac = IF empresa.data-inicio > param-ap.dt-ult-fec THEN empresa.data-inicio ELSE param-ap.dt-ult-fec
                           da-fim-validac = empresa.data-fim.
                END.

                IF  dupli-apagar.dt-trans < da-ini-validac
                OR  dupli-apagar.dt-trans > da-fim-validac then do:

                    CREATE tt-erro-aux.
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 5565,
                                       INPUT "":U).
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Data_de_Transa‡Æo_da_duplicata_do_material_inv lida_no_Contas_a_Pagar" *}
                    ASSIGN tt-erro-aux.i-sequen = i-sequen-aux + 1
                           tt-erro-aux.cd-erro  = 5565
                           tt-erro-aux.mensagem = RETURN-VALUE + "!".
                    ASSIGN l-erro-imp = YES.
                    UNDO, LEAVE.

                END.

                run pi-gera-tt-digita-escolhe. /* T¡tulo a ser substitu¡do */
                
                run pi-gera-tt-duplicata. /* Novo t¡tulo a ser gerado */
                
                assign v-row-tit-ap = ?.

                run app/ap0504c.p (input  table tt-duplicata, 
                                   input  table tt-digita-escolhe ,    
                                   input  table tt-impto-tit-pend-ap,
                                   output de-vl-nota-infdo,  /* Consistir tot-vl-dupli c/ tot-nota */
                                   output v-row-tit-ap,  /* tela de historico */
                                   input  c-referencia,
                                   input  da-dt-transacao,
                                   input  fi-cotacao-dia, 
                                   input  fi-mo-codigo,
                                   input  i-tipo-subst,                           
                                   input  yes,   /* Gera autoriza‡Æo */
                                   input-output table tt-erro-aux).
                
                FIND b-tit-ap WHERE
                     b-tit-ap.ep-codigo     = tit-ap.ep-codigo          AND 
                     b-tit-ap.cod-fornec    = dupli-apagar.cod-emitente AND
                     b-tit-ap.cod-estabel   = dupli-apagar.cod-estabel  AND
                     b-tit-ap.cod-esp       = dupli-apagar.cod-esp      AND 
                     b-tit-ap.serie         = dupli-apagar.serie-docto  AND
                     b-tit-ap.nr-docto      = embarque-imp.embarque     and
                     b-tit-ap.parcela       = dupli-apagar.parcela NO-LOCK NO-ERROR.
                  
                IF NOT AVAIL b-tit-ap THEN
                    ASSIGN l-erro-imp = YES.
                
                RELEASE b-tit-ap.
    
                FIND FIRST tt-erro-aux NO-ERROR.
                IF NOT AVAIL tt-erro-aux THEN
                    run pi-acerta-dif-valores (INPUT tit-ap.ep-codigo,
                                               INPUT tit-ap.cod-fornec,
                                               INPUT tit-ap.cod-estabel,
                                               INPUT tit-ap.cod-esp,
                                               INPUT tit-ap.serie,
                                               INPUT tit-ap.nr-docto,
                                               INPUT tit-ap.parcela,
                                               INPUT dupli-apagar.cod-esp,
                                               INPUT dupli-apagar.serie-docto). /* Tratar diferen‡a de valores  - fazer um AVA */                                   
            end.                   
        end. /*for each*/
    END. /*can-find*/
END PROCEDURE.

PROCEDURE pi-gera-tt-digita-escolhe. 
    /*
    ** T¡tulo Material em Trƒnsito a ser substitu¡do
    */

    create tt-digita-escolhe.
    assign tt-digita-escolhe.tt-ep-codigo     = tit-ap.ep-codigo
           tt-digita-escolhe.tt-cod-estabel   = tit-ap.cod-estabel
           tt-digita-escolhe.tt-cod-esp       = tit-ap.cod-esp
           tt-digita-escolhe.tt-serie         = tit-ap.serie
           tt-digita-escolhe.tt-nr-docto      = tit-ap.nr-docto
           tt-digita-escolhe.tt-parcela       = tit-ap.parcela
           tt-digita-escolhe.tt-cod-fornec    = tit-ap.cod-fornec
           tt-digita-escolhe.tt-nome-abrev    = tit-ap.nome-abrev
           tt-digita-escolhe.tt-cod-port      = tit-ap.portador
           tt-digita-escolhe.tt-dt-emissao    = tit-ap.dt-emissao
           tt-digita-escolhe.tt-dt-vencimen   = dupli-apagar.dt-vencim
           tt-digita-escolhe.tt-dt-desconto   = dupli-apagar.dt-venc-desc
           tt-digita-escolhe.tt-vl-desconto   = de-vl-descto-mo
           tt-digita-escolhe.tt-vl-saldo      = de-vl-a-pagar-mo
           tt-digita-escolhe.tt-selecionado   = yes
           tt-digita-escolhe.tt-row-id-tit-ap = rowid(tit-ap).
           
END PROCEDURE.


PROCEDURE pi-gera-tt-duplicata:
    /*
    ** Gera‡Æo do t¡tulo definitivo
    */

    create tt-duplicata.
    assign tt-duplicata.tt-dup-ep-codigo      = tit-ap.ep-codigo
           tt-duplicata.tt-dup-cod-estabel    = tit-ap.cod-estabel
           tt-duplicata.tt-dup-cod-esp        = dupli-apagar.cod-esp
           tt-duplicata.tt-dup-serie          = docum-est.serie-docto
           tt-duplicata.tt-dup-nr-docto       = tit-ap.nr-docto
           tt-duplicata.tt-dup-parcela        = tit-ap.parcela
           tt-duplicata.tt-dup-cod-fornec     = docum-est.cod-emitente.
           
    find first emitente no-lock
        where emitente.cod-emitente = docum-est.cod-emitente
          and emitente.identific   <> 1 no-error.
   
    if  avail emitente then do:
        assign tt-duplicata.tt-dup-nome-abrev = emitente.nome-abrev.
        run pi-busca-portador-modalidade (buffer emitente,
                                          output i-portador-emit,
                                          output i-modalidade-emit).
    end.
    
    find hist-padrao 
        where hist-padrao.hp-codigo = param-imp.hp-codigo no-lock no-error.
    if  avail hist-padrao then 
        assign i-cod-historico  = param-imp.hp-codigo
               c-desc-historico = hist-padrao.descricao.
    else
        assign i-cod-historico  = 0
               c-desc-historico = "".        

    assign tt-duplicata.tt-dup-dt-emissao     = dupli-apagar.dt-emissao /*tit-ap.dt-emissao*/
           tt-duplicata.tt-dup-dt-vencimen    = dupli-apagar.dt-vencim 
           tt-duplicata.tt-dup-vl-original    = de-vl-a-pagar-mo
           tt-duplicata.tt-dup-dt-desconto    = dupli-apagar.dt-venc-desc
           tt-duplicata.tt-dup-vl-desconto    = de-vl-descto-mo
           tt-duplicata.tt-dup-cod-port       = i-portador-emit
           tt-duplicata.tt-dup-tp-codigo      = dupli-apagar.tp-despesa
           tt-duplicata.tt-dup-modalidade     = i-modalidade-emit
           tt-duplicata.tt-dup-i-hist-padrao  = i-cod-historico
           tt-duplicata.tt-dup-desc-historico = c-desc-historico.

END PROCEDURE.


PROCEDURE pi-acerta-dif-valores.
    /*
    ** Acerta diferen‡a de valores que pode existir entre o novo t¡tulo implantado e o t¡tulo do material em trƒnsito
    */
    DEF INPUT PARAMETER c-ep-codigo     LIKE tit-ap.ep-codigo NO-UNDO.
    DEF INPUT PARAMETER i-cod-fornec    LIKE tit-ap.cod-fornec NO-UNDO.
    DEF INPUT PARAMETER c-cod-estabel   LIKE estabelec.cod-estabel NO-UNDO.
    DEF INPUT PARAMETER c-cod-esp       LIKE tit-ap.cod-esp NO-UNDO.
    DEF INPUT PARAMETER c-serie         LIKE tit-ap.serie NO-UNDO.
    DEF INPUT PARAMETER c-nr-docto      LIKE tit-ap.nr-docto NO-UNDO.
    DEF INPUT PARAMETER c-parcela       LIKE tit-ap.parcela NO-UNDO.
    DEF INPUT PARAMETER c-cod-esp-novo  LIKE tit-ap.cod-esp NO-UNDO.
    DEF INPUT PARAMETER c-serie-novo    LIKE tit-ap.serie NO-UNDO.

    DEF VAR i-lancto        AS   INTEGER          NO-UNDO.
    DEF VAR de-valor-mov    LIKE mov-ap.valor-mov NO-UNDO.
    DEF VAR de-valor-mov-me LIKE mov-ap.valor-mov NO-UNDO.
    DEF VAR de-ajuste       AS   DECIMAL          NO-UNDO.
    DEF VAR d-dt-transacao-mt AS DATE             NO-UNDO.
    FIND b-tit-ap 
        WHERE b-tit-ap.ep-codigo   = c-ep-codigo
          AND b-tit-ap.cod-fornec  = i-cod-fornec
          AND b-tit-ap.cod-estabel = c-cod-estabel
          AND b-tit-ap.cod-esp     = c-cod-esp-novo
          AND b-tit-ap.serie       = c-serie-novo
          AND b-tit-ap.nr-docto    = c-nr-docto
          AND b-tit-ap.parcela     = c-parcela EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL b-tit-ap THEN
        LEAVE.
    ASSIGN d-dt-transacao-mt = b-tit-ap.dt-transacao.

    FIND b-tit-ap 
        WHERE b-tit-ap.ep-codigo   = c-ep-codigo
          AND b-tit-ap.cod-fornec  = i-cod-fornec
          AND b-tit-ap.cod-estabel = c-cod-estabel
          AND b-tit-ap.cod-esp     = c-cod-esp
          AND b-tit-ap.serie       = c-serie
          AND b-tit-ap.nr-docto    = c-nr-docto
          AND b-tit-ap.parcela     = c-parcela EXCLUSIVE-LOCK NO-ERROR.
          
    IF AVAIL b-tit-ap THEN DO:

        IF b-tit-ap.valor-saldo = 0 THEN
            LEAVE.

        IF b-tit-ap.valor-saldo < 0 THEN
            ASSIGN i-lancto = 1. /* 1 - Debito  2 - Credito */
        ELSE
            ASSIGN i-lancto = 2.

        ASSIGN de-valor-mov    = b-tit-ap.valor-saldo
               de-valor-mov-me = b-tit-ap.vl-saldo-me.

        ASSIGN de-ajuste = - 1.

        IF de-valor-mov < 0 THEN
            ASSIGN de-valor-mov = de-valor-mov * de-ajuste.

        IF de-valor-mov-me < 0 THEN
            ASSIGN de-valor-mov-me = de-valor-mov-me * de-ajuste.

        FIND conta-contab 
            WHERE conta-contab.ep-codigo      = param-global.empresa-prin
              AND conta-contab.conta-contabil = param-imp.conta-transit-import NO-LOCK NO-ERROR.

        /*
        ** Cria‡Æo do AVA 
        */ 
        CREATE mov-ap.
        ASSIGN mov-ap.ep-codigo      = b-tit-ap.ep-codigo
               mov-ap.cod-estabel    = b-tit-ap.cod-estabel
               mov-ap.cod-esp        = b-tit-ap.cod-esp
               mov-ap.serie          = b-tit-ap.serie
               mov-ap.nr-docto       = b-tit-ap.nr-docto
               mov-ap.parcela        = b-tit-ap.parcela
               mov-ap.cod-fornec     = b-tit-ap.cod-fornec
               mov-ap.transacao      = 5 /* AVA */
               mov-ap.dt-today       = TODAY
               mov-ap.dt-transacao   = d-dt-transacao-mt /*b-tit-ap.dt-transacao /*TODAY*/*/
               mov-ap.dt-emissao     = b-tit-ap.dt-emissao
               mov-ap.dt-vencimen    = b-tit-ap.dt-vencimen
               mov-ap.nome-abrev     = b-tit-ap.nome-abrev
               mov-ap.portador       = b-tit-ap.portador
               mov-ap.modalidade     = b-tit-ap.modalidade
               mov-ap.referencia     = b-tit-ap.referencia
               mov-ap.contabilizou   = NO 
               mov-ap.tipo           = b-tit-ap.tipo
               mov-ap.usuario        = c-seg-usuario
               mov-ap.c-time         = STRING(TIME, "HH:MM")
               mov-ap.conta-contabil = conta-contab.conta-contabil
               mov-ap.ct-conta       = conta-contab.ct-codigo
               mov-ap.sc-conta       = conta-contab.sc-codigo
               mov-ap.vl-original    = b-tit-ap.vl-original
               mov-ap.valor-mov      = de-valor-mov
               mov-ap.impostos       = YES
               mov-ap.tp-codigo      = b-tit-ap.tp-codigo
               mov-ap.lancamento     = i-lancto.
    
        {utp/ut-liter.i Abatimento_saldo_material_trƒnsito_(diferen‡a_implanta‡Æo_T¡tulo_definitivo) * R}
        assign mov-ap.historico = trim(return-value).
                        
        /* -------------- Multi-Moeda --------------- */

        find cotacao where 
             cotacao.mo-codigo   = b-tit-ap.moeda                        and 
             cotacao.ano-periodo = string(year(d-dt-transacao-mt)) /*today*/
                                   + string(month(d-dt-transacao-mt),"99") /*today*/ and 
             cotacao.cotacao[int(day(d-dt-transacao-mt))] <> 0 no-lock no-error. /*today*/

        IF AVAIL cotacao THEN
            assign mov-ap.cotacao-dia = cotacao.cotacao[int(day(d-dt-transacao-mt))].
        ELSE
            ASSIGN mov-ap.cotacao-dia = 1.

        IF de-valor-mov-me <> 0 THEN
            ASSIGN mov-ap.moeda = b-tit-ap.moeda.
        ELSE
            ASSIGN mov-ap.moeda = 0.
        
        assign mov-ap.vl-orig-me     = b-tit-ap.vl-orig-me
               mov-ap.valor-mov-me   = de-valor-mov-me.
                        
        /*--- Lote Gerado Pelo MultiPlanta ---*/
        
        find doc-i-ap
            where doc-i-ap.ep-codigo  = tit-ap.ep-codigo
              and doc-i-ap.referencia = tit-ap.referencia no-lock no-error.
        
        if  avail doc-i-ap and doc-i-ap.log-2 = yes then do:
            assign mov-ap.flag-contab  = no 
                   mov-ap.contabiliza  = no
                   mov-ap.contabilizou = no
                   mov-ap.origem       = 3.
        end.
        
        /*-------- INTEGRA°†ES ---------*/
        {app/ap9100.i2}
        assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
               tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
               tt-integ-ap.tt-cb0201a     = yes
               tt-integ-ap.tt-ge0102b     = yes
               tt-integ-ap.tt-ge0102g     = yes
               tt-integ-ap.tt-cb1202a     = yes
               tt-integ-ap.tt-op-cb0201a  = 16
               tt-integ-ap.tt-op-ge0102b  = 16
               tt-integ-ap.tt-op-ge0102g  = 16
               tt-integ-ap.tt-op-cb1202a  = 21.
        raw-transfer tt-integ-ap to raw-integracao.

        run app/ap9100.p (Input raw-integracao,
                          input-output table tt-erro-aux).

        IF i-lancto = 2 THEN
            ASSIGN b-tit-ap.valor-saldo = b-tit-ap.valor-saldo - de-valor-mov
                   b-tit-ap.vl-saldo-me = b-tit-ap.vl-saldo-me - de-valor-mov-me.
        ELSE
            ASSIGN b-tit-ap.valor-saldo = b-tit-ap.valor-saldo + de-valor-mov
                   b-tit-ap.vl-saldo-me = b-tit-ap.vl-saldo-me + de-valor-mov-me.
    
        /* Atualiza‡Æo da data de liquida‡Æo do t¡tulo no contas a pagar */
        RUN app/ap6000a.p (INPUT ROWID(b-tit-ap)).

    END.

END PROCEDURE.


PROCEDURE pi-limpa-temp-tables.

    for each tt-duplicata:
        delete tt-duplicata.
    end.

    for each tt-digita-escolhe:
        delete tt-digita-escolhe.
    end.

END PROCEDURE.

&endif
