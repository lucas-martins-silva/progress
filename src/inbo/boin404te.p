/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN404TE 2.00.00.091 } /*** "010091" 17/06/2025 16:40:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin404te MUT}
&ENDIF
 
/*--------------------------------------------------------------------------
    File       : boin404te.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/


/*-------------------------------------------------------------------------------------------------------

 Valores do campo NATUR-OPER.CHAR-2:
 
 Posi‡äes  1 …  5: Indica se o IPI far  parte da base de ICMS;
 Posi‡äes  6 … 10: Indica se o frete far  parte da base de IPI;
 Posi‡äes 11 … 15: Indica se a base de c lculo de IPI sera pelo bruto ou pelo l¡quido;
 Posi‡äes 16 … 20: Indica se o IPI far  parte do total da nota;
 Posi‡äes 21 … 25: Indica se a base de c lculo de ISS sera pelo bruto ou pelo l¡quido;
 Posi‡äes 26 … 30: NÆo possu¡ defini‡Æo (NÆo utilizado);
 Posi‡äes 31 … 35: Indica se atualiza Cotas;
 Posi‡äes 36 … 40: Indica a permissÆo para alterar os valores de terceiros;
 Posi‡äes 41 … 45: Indica se emite remito (Internacional);
 Posi‡äes 46 … 50: Indica se o IPI Outras far  parte da base de substitui‡Æo tribut ria;
 Posi‡äes 51 … 55: Indica se o ICMS Outras far  parte da base de substitui‡Æo tribut ria ;
 Posi‡äes 56 … 60: Indica se gera cr‚dito para substitui‡Æo tribut ria;
 Posi‡äes 61 … 65: Indica a gera‡Æo de previsÆo para o CR (Internacional);
 Posi‡äes 66 … 70: Valor do desconta para Zona Franca de Manaus;
 Posi‡äes 71 … 75: Indica se possu¡ INSS na Fonte;
 Posi‡äes 76 … 80: Modelo do cupom;

-------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------------------------------

 Inicializa‡Æo da BO.

--------------------------------------------------------------------------------------------------------*/
{utp/ut-glob.i}  /* Definicao de vari veis globais  */
{cdp/cdcfgdis.i} /* Defini‡Æo dos pr‚-processadores */
{cdp/cdcfgman.i} /* Defini‡Æo dos pr‚-processadores */
{cdp/cdcfgmat.i} /* Defini‡Æo dos pr‚-processadores */
{cep/ce1234.i}   /* Fun‡Æo para arredondamento      */

/* Include com a defini‡Æo da temp-table */
{inbo/boin404.i1}

/* Defini‡äes referente a EPC */
{include/i-epc200.i BOIN404TE}

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName BOIN404TE
&GLOBAL-DEFINE DBOVersion 1
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName saldo-terc
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

{method/dboqry.i}

/* Include padrÆo para DBOïs */
{method/dbo.i}

/* Defini‡Æo de buffers */
DEFINE BUFFER b-componente      FOR componente.
DEFINE BUFFER b-estrutura       FOR estrutura.
DEFINE BUFFER b-natur-oper      FOR natur-oper.
DEFINE BUFFER b-fat-ser-lote    FOR fat-ser-lote.
DEFINE BUFFER bf-rat-componente FOR rat-componente.
DEFINE BUFFER bf-rat-saldo-terc FOR rat-saldo-terc.

/* Leitura de registros para inicializa‡Æo da BO */
for first param-global no-lock:
end.

for first param-estoq no-lock:
end.

for first param-re
    where param-re.usuario = c-seg-usuario no-lock:
end.

/* Defini‡Æo de vari veis */
DEFINE VARIABLE l-possui-acompanhamento AS   LOGICAL                    NO-UNDO.
DEFINE VARIABLE h-acompanhamento        AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE l-gera-saldo-terc       AS   LOGICAL                    NO-UNDO.
DEFINE VARIABLE i-tipo-sal-terc         AS   INTEGER                    NO-UNDO.
DEFINE VARIABLE c-char                  AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE rw-nota-fiscal          AS   ROWID                      NO-UNDO.
DEFINE VARIABLE rw-rat-componente       AS   ROWID                      NO-UNDO.
DEFINE VARIABLE l-nf-depos-fechado-auto AS   LOGICAL                    NO-UNDO.
DEFINE VARIABLE d-porcent               AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-qtd-saldo-total      AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-qt-total-fat         AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE c-cod-dep-ext           AS   CHARACTER                  NO-UNDO.

DEFINE VARIABLE i-seq-wt-docto          LIKE wt-docto.seq-wt-docto      NO-UNDO.
/* Include que contem a defini‡äes para tratamento de erros. */
{dibo/bodi317.i2 boin404te}

/* Include que contem a defini‡äes das tabelas tempr rias para terceiros */
{inbo/boin404te.i1}

/* Defini‡Æo de tabelas tempor rias */
def temp-table tt-item no-undo
    field it-codigo   like item-doc-est.it-codigo
    FIELD cod-refer   LIKE referencia.cod-refer
    field nr-ord-prod like item-doc-est.nr-ord-prod
    field rw-reserva  as   rowid
    field quantidade  like item-doc-est.quantidade.

DEF TEMP-TABLE tt-item-erro NO-UNDO
    FIELD it-codigo LIKE item-doc-est.it-codigo.
    
DEF TEMP-TABLE tt-baixa-estoq-item-terc-aux NO-UNDO LIKE tt-baixa-estoq-item-terc
    FIELD rw-saldo-terc AS   ROWID
    FIELD serie-docto   LIKE rat-saldo-terc.serie-docto  
    FIELD nro-docto     LIKE rat-saldo-terc.nro-docto    
    FIELD cod-emitente  LIKE rat-saldo-terc.cod-emitente 
    FIELD nat-operacao  LIKE rat-saldo-terc.nat-operacao.


{dibo/bodi317sd.i1}

/*-------------------------------------------------------------------------------------------------------

 Procedimento: inicializaAcompanhamento.

     Objetivo: Inicializa‡Æo para mostrar tela de acompanhamentos do processamento.

 Parƒmetros de Entrada/Sa¡da:
   Entrada: <Nenhum>
   Sa¡da..: p-l-procedimento-ok: Retorna que o procedimento ocorreu por completo;
                      
--------------------------------------------------------------------------------------------------------*/

PROCEDURE inicializaAcompanhamento:
    /* Defini‡Æo dos parƒmetros de Entrada/Sa¡da */
    def output param p-l-procedimento-ok as log                     no-undo.

    if  session:remote then do:
        assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
        return.
    end.

    run utp/ut-acomp.p persistent set h-acompanhamento.

    {utp/ut-liter.i Calculando_Impostos MFT L}
    run pi-inicializar        in h-acompanhamento(input trim(return-value)).
    {utp/ut-liter.i Calculando_Impostos MFT L}
    run pi-acompanhar         in h-acompanhamento(input trim(return-value)).
    run pi-desabilita-cancela in h-acompanhamento.
    assign l-possui-acompanhamento = yes.

/*  {utp/ut-liter.i Calculando_Pesos                 MFT L} assign c-texto-acomp[1]  = return-value + ".". */

    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
END PROCEDURE.    



/*-------------------------------------------------------------------------------------------------------

 Procedimento: finalizaAcompanhamento.

     Objetivo: Finaliza‡Æo da tela de acompanhamentos do processamento.

 Parƒmetros de Entrada/Sa¡da:
   Entrada: <Nenhum>
   Sa¡da..: p-l-procedimento-ok: Retorna que o procedimento ocorreu por completo;
                      
--------------------------------------------------------------------------------------------------------*/

PROCEDURE finalizaAcompanhamento:
    /* Defini‡Æo dos parƒmetros de Entrada/Sa¡da */
    def output param p-l-procedimento-ok as log no-undo.

    if  valid-handle(h-acompanhamento) then 
        run pi-finalizar in h-acompanhamento.
    assign l-possui-acompanhamento = no.

    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
END PROCEDURE.    



/*-------------------------------------------------------------------------------------------------------

 Procedimento: localizaItem.

     Objetivo: Localiza Item a partir da chave principal.

 Parƒmetros de Entrada/Sa¡da:
   Entrada: p-c-it-codigo......: C¢digo do item a ser localizado;
   Sa¡da..: p-l-procedimento-ok: Retorna que o procedimento ocorreu por completo;
                      
--------------------------------------------------------------------------------------------------------*/

PROCEDURE localizaItem:
    /* Defini‡Æo dos parƒmetros de Entrada/Sa¡da */
    def input  param p-c-it-codigo       like item.it-codigo no-undo.
    def output param p-l-procedimento-ok as log              no-undo.

    assign c-ultimo-metodo-exec = replace(program-name(1)," ":U, "~~":U).

    /* Localiza item e disponibiliza somente os campos necess rios */
    for first item
        fields (item.it-codigo)
        where item.it-codigo = p-c-it-codigo no-lock:
    end.

    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
END PROCEDURE.    



/*-------------------------------------------------------------------------------------------------------

 Procedimento: localizaNaturOper.

     Objetivo: Localiza natureza de opera‡Æo a partir da chave principal.

 Parƒmetros de Entrada/Sa¡da:
   Entrada: p-c-nat-operacao...: Natureza de opera‡Æo a ser localizada;
   Sa¡da..: p-l-procedimento-ok: Retorna que o procedimento ocorreu por completo;
                      
--------------------------------------------------------------------------------------------------------*/

PROCEDURE localizaNaturOper:
    /* Defini‡Æo dos parƒmetros de Entrada/Sa¡da */
    def input  param p-c-nat-operacao    like natur-oper.nat-operacao no-undo.
    def output param p-l-procedimento-ok as log                       no-undo.

    assign c-ultimo-metodo-exec = replace(program-name(1)," ":U, "~~":U).

    /* Localiza natureza de operacao e disponibiliza somente os campos necess rios */
    for first natur-oper
        fields (natur-oper.nat-operacao)
        where natur-oper.nat-operacao = p-c-nat-operacao no-lock:
    end.

    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
END PROCEDURE.    



/*-------------------------------------------------------------------------------------------------------

 Procedimento: geraItensPartindoDoComponente:

     Objetivo: Gera‡Æo de itens partindo do componente.
          
 Parƒmetros de Entrada/Sa¡da:
   Entrada: p-rw-componente....: Rowid da tabela componente que gerara o item (tt-item-devol);
            p-de-reajuste......: Percentual de reajuste para notas de reajuste de pre‡o;
            p-c-nat-operacao...: Natureza de opera‡Æo do Documento/Nota Fiscal;
            p-de-quantidade....: Quantidade que ir  ser alocada ou desalocada;
            p-c-tipo-oper-terc.: Tipo de opera‡äes com terceiros (Somente para recebimento F¡sico);
            p-l-recebimento....: Indica se o m¢dulo de recebimento executou o m‚todo;
            p-da-dt-trans......: Data m xima para considerar notas de reajuste (Geralmente data da transa‡Æo)
            p-i-sequencia......: N£mero da sequencia que ser  utilizada para sequˆncia do item na nota;
   Sa¡da..: p-l-procedimento-ok: Retorna que o procedimento ocorreu por completo;

 Registros que devem estar dispon¡veis antes da execu‡Æo deste procedimento: 
   <Nenhum>
         
 BOS Necess rios para executar esse m‚todo:
   <Nenhum>

--------------------------------------------------------------------------------------------------------*/

PROCEDURE geraItensPartindoDoComponente:
    /* Defini‡Æo dos parƒmetros de Entrada/Sa¡da */
    DEFINE INPUT  PARAMETER p-rw-componente     AS   ROWID                          NO-UNDO.
    DEFINE INPUT  PARAMETER p-de-reajuste       AS   DECIMAL                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-nat-operacao    LIKE natur-oper.nat-operacao        NO-UNDO.
    DEFINE INPUT  PARAMETER p-de-quantidade     LIKE componente.quantidade          NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-tipo-oper-terc  AS   CHARACTER                      NO-UNDO.
    DEFINE INPUT  PARAMETER p-l-recebimento     AS   LOGICAL FORMAT "RE/FT":U       NO-UNDO.
    DEFINE INPUT  PARAMETER p-da-dt-trans       AS   DATE                           NO-UNDO.
    DEFINE INPUT  PARAMETER p-i-sequencia       AS   INTEGER                        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-l-procedimento-ok AS   LOGICAL                        NO-UNDO.

    assign c-ultimo-metodo-exec = replace(program-name(1)," ":U, "~~":U).

    /* Definicao de variaveis locais */
    DEFINE VARIABLE l-proc-ok-aux        AS   LOGICAL                         NO-UNDO.
    DEFINE VARIABLE de-proporcao         AS   DECIMAL                         NO-UNDO.
    DEFINE VARIABLE c-tipo-nota          AS   CHARACTER                       NO-UNDO.
    DEFINE VARIABLE de-indice            AS   DECIMAL                         NO-UNDO.
    DEFINE VARIABLE de-qtd-aux-1         AS   DECIMAL                         NO-UNDO.
    DEFINE VARIABLE de-qtd-aux-2         AS   DECIMAL                         NO-UNDO.
    DEFINE VARIABLE de-qt-tot-faturada   AS   DECIMAL                         NO-UNDO.							
    DEFINE VARIABLE de-qtd-saldo-fatur   AS   DECIMAL                         NO-UNDO.
    DEFINE VARIABLE de-qtd-saldo         LIKE saldo-terc.quantidade           NO-UNDO.
    DEFINE VARIABLE de-valor-tot         LIKE componente.preco-total EXTENT 0 NO-UNDO.
    DEFINE VARIABLE de-valor-ret         LIKE componente.preco-total EXTENT 0 NO-UNDO.
    DEFINE VARIABLE de-desc-tot          LIKE componente.preco-total EXTENT 0 NO-UNDO.
    DEFINE VARIABLE de-desc-ret          LIKE componente.preco-total EXTENT 0 NO-UNDO.
    DEFINE VARIABLE de-qt-tot            LIKE saldo-terc.quantidade  EXTENT 0 NO-UNDO. 
    DEFINE VARIABLE de-qt-ret            LIKE saldo-terc.quantidade  EXTENT 0 NO-UNDO. 
    DEFINE VARIABLE lDevSimbConsig       AS   LOGICAL                         NO-UNDO.
    DEFINE VARIABLE h-boin404            AS   HANDLE                          NO-UNDO.
    DEFINE VARIABLE de-tot-aux           AS DECIMAL     NO-UNDO.

    for first componente
        where rowid(componente) = p-rw-componente no-lock:
    end.


    IF rw-rat-componente <> ? THEN     /*registro posicionado na bodi317sd - geraWtItDoctoPartindoDoTtItTercNf */
        FOR FIRST bf-rat-componente
            WHERE rowid(bf-rat-componente) = rw-rat-componente NO-LOCK:
        END.

    for first saldo-terc 
        where saldo-terc.serie-docto  = componente.serie-docto
        and   saldo-terc.nro-docto    = componente.nro-docto
        and   saldo-terc.cod-emitente = componente.cod-emitente
        and   saldo-terc.nat-operacao = componente.nat-operacao
        and   saldo-terc.it-codigo    = componente.it-codigo
        and   saldo-terc.cod-refer    = componente.cod-refer
        and   saldo-terc.sequencia    = componente.sequencia no-lock:
    end.

    if  not avail natur-oper
    or  natur-oper.nat-operacao <> p-c-nat-operacao then
        for first natur-oper
            where natur-oper.nat-operacao = p-c-nat-operacao no-lock:
        end.

    /* Industrializa‡Æo sob Encomenda - posicionar o registro da natur-oper na natureza complementar da ind encom */
    IF (AVAIL natur-oper
    AND TRIM(substr(natur-oper.char-1,172,1)) = "1":U) /* Industrializa‡Æo por encomenda */
    AND natur-oper.nat-comp <> "":U THEN
        for first natur-oper
            where natur-oper.nat-operacao = natur-oper.nat-comp no-lock:
        end.
    
    if  not avail emitente
    or  emitente.cod-emitente <> componente.cod-emitente then 
        for first emitente
            where emitente.cod-emitente = componente.cod-emitente no-lock:
        end.
    
    for first item  
        where item.it-codigo = componente.it-codigo no-lock:
    end.

    assign de-proporcao = (p-de-quantidade / componente.quantidade).

    /* Quando nÆo for de reajuste coloca igual a 100, para nÆo ocorrer problema na divisÆo */
    if  p-de-reajuste = 0 then
        assign p-de-reajuste = 100.

    if  not avail natur-oper then 
        assign c-tipo-nota = p-c-tipo-oper-terc.

    create tt-item-terc.
    assign tt-item-terc.it-codigo         = componente.it-codigo
           tt-item-terc.desconto          = componente.desconto[1]
           tt-item-terc.per-des-item      = componente.dec-1
           tt-item-terc.peso-liquido      = componente.peso-liquido
           tt-item-terc.cod-refer         = componente.cod-refer
           tt-item-terc.serie-docto       = componente.serie-docto
           tt-item-terc.nro-docto         = componente.nro-docto
           tt-item-terc.nat-operacao      = componente.nat-operacao 
           tt-item-terc.sequencia         = p-i-sequencia
           tt-item-terc.seq-comp          = componente.sequencia
           tt-item-terc.un                = item.un
           tt-item-terc.nr-ord-prod       = componente.nr-ord-produ
           tt-item-terc.ct-codigo         = componente.ct-codigo
           tt-item-terc.sc-codigo         = componente.sc-codigo
           tt-item-terc.quantidade        = p-de-quantidade
           tt-item-terc.qt-do-forn-cli    = componente.qt-do-forn  * de-proporcao
           tt-item-terc.class-fiscal      = componente.class-fiscal
           tt-item-terc.aliquota-ipi      = componente.aliquota-ipi
           tt-item-terc.aliquota-iss      = item.aliquota-iss
           tt-item-terc.narrativa         = componente.narrativa
           tt-item-terc.baixa-ce          = if (    avail natur-oper 
                                                and natur-oper.tp-oper-terc = 4) /* Consig                */
                                            or c-tipo-nota = "7":U               /* Consig - Receb F¡sico */
                                            then no
                                            else if  (    avail natur-oper 
                                                      and natur-oper.transf) 
                                                 or  c-tipo-nota = "3":U 
                                                 then yes
                                                 else if  p-l-recebimento /* Veio do recebimento */
                                                      then componente.baixa-ce
                                                      else (    item.baixa-estoq
                                                            and avail natur-oper
                                                            and natur-oper.baixa-estoq)
           
           /* Grava chave da reserva da ordem de produ‡Æo */       
           tt-item-terc.item-pai    = substr(componente.char-1,1,16)
           tt-item-terc.cod-roteiro = substr(componente.char-1,17,16) 
           tt-item-terc.op-codigo   = int(substr(componente.char-1,35,5))
           &if "{&bf_dis_versao_ems}" >= "2.062" &then
           tt-item-terc.cod-unid-negoc = componente.cod-unid-negoc
           &endif.
        

    /* a ordem de produ‡Æo nÆo foi informada na remessa, somente no retorno */
    /* a conta ser  atualizada no m‚todo AtualizaContaContabilItem */
    IF  AVAIL ord-prod
    AND tt-item-terc.nr-ord-prod <> ord-prod.nr-ord-produ THEN
        ASSIGN tt-item-terc.nr-ord-prod    = ord-prod.nr-ord-produ.
    
    /* Devolucao Consigna‡Æo - O campo componente.log-2 indica se na nota de saida o item teve susbst trib */     
    if  avail natur-oper
    and natur-oper.tipo = 1
    and natur-oper.tp-oper-terc = 5 then    
        assign tt-item-terc.ind-icm-ret = componente.log-2.
    
    /* Faturamento Consigna‡Æo e Reajuste de Pre‡o - O campo componente.log-2 indica se na nota de remessa o item teve susbst trib */     
    IF  AVAIL natur-oper
    AND       natur-oper.tipo         = 2
    AND (     natur-oper.tp-oper-terc = 2
          OR  natur-oper.tp-oper-terc = 4 
          OR  natur-oper.tp-oper-terc = 6
          OR  natur-oper.tp-oper-terc = 9
          OR  natur-oper.tp-oper-terc = 11 ) THEN    
        ASSIGN tt-item-terc.ind-icm-ret = componente.log-2.
    
    if  c-tipo-nota = "7":U  /* Faturamento consig - receb fisico */
    or  (    avail natur-oper 
         and can-do("4,6":U, string(natur-oper.tp-oper-terc))) then do:
    
        /*-----------------------------------------------------------------------------------------+
         | Zera a ordem de produ‡Æo e a conta de aplica‡Æo para notas de faturamento consigna‡Æo e |
         | reajuste pre‡o, quado o item nÆo possuir tipo de controle fisico ou debito direto.      |
         +-----------------------------------------------------------------------------------------*/
        assign tt-item-terc.nr-ord-prod = 0.
    
        /* Item com tipo de controle Total ou Consignado */
        if  can-do("2,3":U, string(item.tipo-contr)) then
            assign tt-item-terc.ct-codigo = " ":U
                   tt-item-terc.sc-codigo = " ":U.
    end.
    
    /*  C lculo do total do item da nota */
    assign de-valor-tot = componente.preco-total[1]
           de-desc-tot  = componente.desconto[1]
           de-qt-tot    = componente.quantidade
           de-valor-ret = componente.preco-total[1]
           de-desc-ret  = componente.desconto[1]
           de-qt-ret    = componente.quantidade
           lDevSimbConsig = NO.
    
    IF  NOT CAN-FIND (FIRST funcao
                      WHERE funcao.cd-funcao = "spp-vl-ret-nf-entr"    /* preço retorno conforme nota fiscal de entrada */
                      AND   funcao.ativo) 
    OR  natur-oper.tp-oper-terc <> 2   /* retorno beneficiamento */  THEN  
    for each  b-componente
        where b-componente.cod-emitente = componente.cod-emitente 
        and   b-componente.nro-comp     = componente.nro-docto    
        and   b-componente.serie-comp   = componente.serie-docto  
        and   b-componente.nat-comp     = componente.nat-operacao 
        and   b-componente.it-codigo    = componente.it-codigo    
        and   b-componente.cod-refer    = componente.cod-refer   
        and   b-componente.seq-comp     = componente.sequencia 
        and   (   b-componente.quantidade <> 0
               or b-componente.dt-retorno <= p-da-dt-trans) no-lock
        BY b-componente.dt-retorno : /* Cons NF Reajuste ate Dt da NF */ 
    
        if  b-componente.componente = 1 then 
            assign de-valor-tot = de-valor-tot + b-componente.preco-total[1]
                   de-desc-tot  = de-desc-tot  + b-componente.desconto[1]
                   de-qt-tot    = de-qt-tot    + b-componente.quantidade.
        else 
            assign de-valor-tot = de-valor-tot - b-componente.preco-total[1]
                   de-desc-tot  = de-desc-tot  - b-componente.desconto[1]
                   de-qt-tot    = de-qt-tot    - b-componente.quantidade.
    
        
        /*Quando houver mais retornos que remessa e assumido o preco total e a
          quantidade do componente, para que os valores nao fiquem negativos*/
        if  de-valor-tot < 0 then
            assign de-valor-tot = componente.preco-total[1]
                   de-desc-tot  = componente.desconto[1]
                   de-qt-tot    = componente.quantidade.
    
        if  de-desc-tot < 0 then
            assign de-desc-tot = 0.
    
        IF  NOT lDevSimbConsig THEN DO:
            FIND FIRST b-natur-oper NO-LOCK
                 WHERE b-natur-oper.nat-operacao = b-componente.nat-operacao NO-ERROR.
            ASSIGN lDevSimbConsig = {cdp/cd0066.i saldo-terc.cod-estabel b-natur-oper}.
        END.
    end.
    else 
       FOR EACH  b-componente
                where b-componente.cod-emitente = componente.cod-emitente 
                and   b-componente.nro-comp     = componente.nro-docto    
                and   b-componente.serie-comp   = componente.serie-docto  
                and   b-componente.nat-comp     = componente.nat-operacao 
                and   b-componente.it-codigo    = componente.it-codigo    
                and   b-componente.cod-refer    = componente.cod-refer   
                and   b-componente.seq-comp     = componente.sequencia 
                and   (   b-componente.quantidade <> 0
                       or b-componente.dt-retorno <= p-da-dt-trans) no-lock
                BY b-componente.dt-retorno : /* Cons NF Reajuste ate Dt da NF */ 
            
                if  b-componente.componente = 1 then 
                    assign de-valor-ret = de-valor-ret + b-componente.preco-total[1]
                           de-desc-ret  = de-desc-ret  + b-componente.desconto[1]
                           de-qt-ret    = de-qt-ret    + b-componente.quantidade.
                else 
                    assign de-valor-ret = de-valor-ret - b-componente.preco-total[1]
                           de-desc-ret  = de-desc-ret  - b-componente.desconto[1]
                           de-qt-ret    = de-qt-ret    - b-componente.quantidade.
            
                /*Quando houver mais retornos que remessa e assumido o preco total e a
                quantidade do componente, para que os valores nao fiquem negativos*/
                if  de-valor-ret < 0 then
                    assign de-valor-ret = componente.preco-total[1]
                           de-desc-ret  = componente.desconto[1]
                           de-qt-ret    = componente.quantidade.
    
                if  de-desc-tot < 0 then
                    assign de-desc-tot = 0.            
          END.
        

    
    IF  lDevSimbConsig THEN DO:
        IF  {cdp/cd0066.i2 saldo-terc.cod-estabel}
        AND (AVAIL natur-oper AND natur-oper.tp-oper-terc = 4) THEN DO:
            RUN inbo/boin404.p PERSISTENT SET h-boin404.
            RUN updateFifoDevolucaoSimbolica IN h-boin404 (YES,
                                                           YES,
                                                           ROWID(saldo-terc),
                                                           tt-item-terc.quantidade).
            DELETE PROCEDURE h-boin404.
        END.
    END.
    
    /*considera somente saldo-terc onde os itens referem-se ao dep¢sito fechado*/
    IF  l-nf-depos-fechado-auto
    AND ITEM.tipo-con-est <> 1 THEN DO:
        FIND FIRST tt-it-terc-nf2-aux
             WHERE tt-it-terc-nf2-aux.it-codigo     = saldo-terc.it-codigo                   
               AND tt-it-terc-nf2-aux.rw-saldo-terc = ROWID(saldo-terc)  NO-LOCK NO-ERROR.
        IF AVAIL tt-it-terc-nf2-aux THEN
            ASSIGN de-qtd-saldo-total = tt-it-terc-nf2-aux.de-qtd-saldo-total.
    END.
    ELSE 
        ASSIGN de-qtd-saldo-total = (saldo-terc.quantidade - saldo-terc.dec-1).

    /* Aloca‡Æo do saldo em poder de terceiros */
    IF AVAIL natur-oper
        AND ( natur-oper.tp-oper-terc = 2                          /* retorno beneficiamento */
         OR  (natur-oper.tp-oper-terc = 4 AND NOT lDevSimbConsig)  /* fatur consignacao      */
         OR   natur-oper.tp-oper-terc = 5                          /* devol consignacao      */
         OR   natur-oper.tp-oper-terc = 9                          /* retorno Dep Fechado    */
         OR   natur-oper.tp-oper-terc = 11 )                       /* retorno Armazem Geral  */
         OR c-tipo-nota = "5":U
         OR c-tipo-nota = "7":U 
         OR c-tipo-nota = "8":U  THEN DO:

        IF l-nf-depos-fechado-auto THEN DO:

            IF  ITEM.tipo-con-est <> 1
            AND AVAIL bf-rat-componente THEN DO:
                RUN atualizaQtAlocadaSaldoTerc (INPUT  YES, 
                                                INPUT  bf-rat-componente.cod-emitente,
                                                INPUT  bf-rat-componente.nro-docto,
                                                INPUT  bf-rat-componente.serie-docto,
                                                INPUT  bf-rat-componente.nat-operacao, 
                                                INPUT  bf-rat-componente.it-codigo,
                                                INPUT  bf-rat-componente.cod-refer,   
                                                INPUT  bf-rat-componente.sequencia,   
                                                INPUT  tt-item-terc.quantidade,
                                                OUTPUT l-proc-ok-aux).
                
            END.
            ELSE
                RUN atualizaQtAlocadaSaldoTerc (INPUT  YES, 
                                                INPUT  componente.cod-emitente,
                                                INPUT  componente.nro-docto,
                                                INPUT  componente.serie-docto,
                                                INPUT  componente.nat-operacao, 
                                                INPUT  componente.it-codigo,
                                                INPUT  componente.cod-refer,   
                                                INPUT  componente.sequencia,   
                                                INPUT  tt-item-terc.quantidade,
                                                OUTPUT l-proc-ok-aux).
        END.
        ELSE DO:
            RUN atualizaQtAlocadaSaldoTerc (INPUT  YES, 
                                            INPUT  componente.cod-emitente,
                                            INPUT  componente.nro-docto,
                                            INPUT  componente.serie-docto,
                                            INPUT  componente.nat-operacao, 
                                            INPUT  componente.it-codigo,
                                            INPUT  componente.cod-refer,   
                                            INPUT  componente.sequencia,   
                                            INPUT  tt-item-terc.quantidade,
                                            OUTPUT l-proc-ok-aux).
        END.
        {dibo/bodi317.i3 l-proc-ok-aux}
    END.
    

    if  not avail natur-oper 
    OR  natur-oper.tp-oper-terc <> 6 then do:

        assign tt-item-terc.vl-preori    = (de-valor-tot / de-qt-tot)
               tt-item-terc.vl-preuni    = ((de-valor-tot - de-desc-tot) / de-qt-tot)
               tt-item-terc.peso-liquido = tt-item-terc.peso-liquido / componente.quantidade * tt-item-terc.quantidade.

        /* a £ltima nota de retorno sempre entrar  aqui p/ nÆo provocar diferen‡a de valores */
        
        if   de-qt-tot = tt-item-terc.quantidade then
             assign  tt-item-terc.vl-merc-ori  = de-valor-tot
                     tt-item-terc.vl-merc-liq  = de-valor-tot - de-desc-tot 
                     tt-item-terc.desconto     = de-desc-tot.
        else do: /* quanto nÆo for a £ltima nota entra aqui p/ retorno parcial */
            
            assign tt-item-terc.vl-merc-ori  = fn_ajust_dec(round(tt-item-terc.vl-preori * tt-item-terc.quantidade,2), 0).
            assign tt-item-terc.vl-merc-liq  = fn_ajust_dec(round(tt-item-terc.vl-preuni * tt-item-terc.quantidade,2), 0).
            assign tt-item-terc.desconto     = fn_ajust_dec(de-desc-tot / saldo-terc.quantidade * tt-item-terc.quantidade, 0).
            
            IF de-qtd-saldo-total = de-qt-ret               AND      // qdo existir saldo-terc.dec-1 > 0 essas quantidades serÆo diferentes, e nÆo dever  entrar aqui    
               de-qtd-saldo-total = tt-item-terc.quantidade AND 
               (de-valor-ret - tt-item-terc.vl-merc-ori) <> 0       // nÆo pode restar saldo de valor saldo negativo                   
             THEN DO:
                ASSIGN tt-item-terc.vl-merc-ori  = de-valor-ret
                       tt-item-terc.vl-merc-liq  = de-valor-ret - de-desc-ret 
                       tt-item-terc.desconto     = de-desc-ret
                       tt-item-terc.vl-preori    = round((de-valor-ret / tt-item-terc.quantidade ),9)
                       tt-item-terc.vl-preuni    = round(((de-valor-ret - de-desc-ret) / tt-item-terc.quantidade ),9).
             
            END.
        end.

        /* Determina Preco Unitario de acordo com Fator Conversao para Recebimento */
        if  (    avail natur-oper 
             and natur-oper.tipo = 1 
             and (   natur-oper.tp-oper-terc = 4   /* Faturamento Consig       */
                  or natur-oper.tp-oper-terc = 5)) /* Devolucao Consig         */
        or  c-tipo-nota = "7":U                    /* Fat. Consig. Rec. Fisico */
        or  c-tipo-nota = "8":U then do:           /* Dev. Consig. Rec. Fisico */
            /* ConversÆo da Unidade de Medida - Recebimento */
            {cdp/cd9950.i item.un 
                          componente.un                          
                          componente.cod-emitente}
            
            if  de-indice = 0 
            or  de-indice = ? then 
                assign de-indice = 1.                      
          
            if  avail item-fornec then
                assign tt-item-terc.un = item-fornec.unid-med-for.
         
            assign tt-item-terc.qt-do-forn-cli = tt-item-terc.quantidade * de-indice
                   tt-item-terc.vl-preori      = tt-item-terc.vl-merc-ori / tt-item-terc.qt-do-forn-cli
                   tt-item-terc.vl-preuni      = tt-item-terc.vl-merc-liq / tt-item-terc.qt-do-forn-cli.

        end.    
    end.
    else do:
        assign tt-item-terc.vl-preori = (de-valor-tot / (100 / p-de-reajuste)) / 
                                        if  p-de-quantidade <> 0 
                                        then p-de-quantidade
                                        else 1
               tt-item-terc.vl-preuni = ((de-valor-tot - de-desc-tot) / (100 / p-de-reajuste)) / 
                                        if  p-de-quantidade <> 0
                                        then p-de-quantidade
                                        else 1
               tt-item-terc.baixa-ce  = no.
    
        assign tt-item-terc.desconto      = fn_ajust_dec(de-desc-tot / (100 / p-de-reajuste), 0).
        assign tt-item-terc.vl-merc-ori   = fn_ajust_dec(round(tt-item-terc.vl-preori * 
                                                         (if  p-de-quantidade <> 0
                                                          then p-de-quantidade
                                                          else 1),2), 0).
        assign tt-item-terc.vl-merc-liq   = fn_ajust_dec(round(tt-item-terc.vl-preuni * 
                                                         (if  p-de-quantidade <> 0
                                                          then p-de-quantidade
                                                          else 1),2), 0).
    end.

    /* Cri‡Æo dos registro de baixa do estoque do item da nota */

    
    assign de-qtd-saldo       = tt-item-terc.quantidade
		   de-qtd-saldo-fatur = tt-item-terc.quantidade. 

    IF tt-item-terc.baixa-ce THEN DO:
        IF saldo-terc.int-1 = 1 /* Remessa feita pelo Faturamento */
        AND (  ( AVAIL natur-oper 
                 AND (   natur-oper.tp-oper-terc = 2     /* ret benef     */
                      OR natur-oper.tp-oper-terc = 5     /* dev consig    */
                      OR natur-oper.tp-oper-terc = 9     /* ret dep fech  */
                      OR natur-oper.tp-oper-terc = 11    /* ret arm geral */
                      OR natur-oper.transf)) 
            OR c-tipo-nota = "5":u 
            OR c-tipo-nota = "8":u 
            OR c-tipo-nota = "3":u) 
        THEN
            FOR EACH fat-ser-lote
               WHERE fat-ser-lote.cod-estabel = saldo-terc.cod-estabel
                 AND fat-ser-lote.serie       = componente.serie-docto
                 AND fat-ser-lote.nr-nota-fis = componente.nro-docto
                 AND fat-ser-lote.nr-seq-fat  = componente.sequencia NO-LOCK:

                CREATE tt-baixa-estoq-item-terc.
                ASSIGN tt-baixa-estoq-item-terc.sequencia   = tt-item-terc.sequencia
                       tt-baixa-estoq-item-terc.it-codigo   = fat-ser-lote.it-codigo
                       tt-baixa-estoq-item-terc.cod-depos   = fat-ser-lote.cod-depos
                       tt-baixa-estoq-item-terc.cod-localiz = fat-ser-lote.cod-localiz
                       tt-baixa-estoq-item-terc.lote        = fat-ser-lote.nr-serlote
                       tt-baixa-estoq-item-terc.char-1      = fat-ser-lote.cod-refer.

                IF item.tipo-con-est = 3 OR item.tipo-con-est = 4 THEN
                    FOR FIRST saldo-estoq 
                        WHERE saldo-estoq.it-codigo = fat-ser-lote.it-codigo 
                          AND saldo-estoq.lote      = fat-ser-lote.nr-serlote NO-LOCK:

                        ASSIGN tt-baixa-estoq-item-terc.dt-vali-lote = saldo-estoq.dt-vali-lote.
                    END.

                IF fat-ser-lote.qt-baixada[1] > de-qtd-saldo THEN DO:
                    ASSIGN tt-baixa-estoq-item-terc.quantidade = de-qtd-saldo
                           de-qtd-saldo                  = 0.
                    LEAVE.
                END.
                ELSE
                    ASSIGN tt-baixa-estoq-item-terc.quantidade = fat-ser-lote.qt-baixada[1]
                           de-qtd-saldo                        = de-qtd-saldo - 
                                                                 tt-baixa-estoq-item-terc.quantidade.

            END.
        ELSE
            IF NOT AVAIL natur-oper 
            OR natur-oper.tp-oper-terc <> 6
            THEN DO:

                IF CAN-FIND(FIRST item NO-LOCK
                            WHERE item.it-codigo = tt-item-terc.it-codigo
                              AND item.tipo-con-est <> 1) /* Somente entrar se item não é controlado por serial */
                AND (AVAIL natur-oper 
                     AND  (natur-oper.tp-oper-terc = 5  AND natur-oper.idi-tip-devol-consig = 2) /* DEVOLUCAO CONSIGNACAO DEVOLUCAO DE MERCADORIA */ 
                     OR   (natur-oper.tp-oper-terc = 2  AND natur-oper.baixa-estoq = YES)        /* RETORNO DE BENEFICIAMENTO BAIXANDO ESTOQUE    */ 
                     OR   (natur-oper.tp-oper-terc = 9  AND natur-oper.baixa-estoq = YES)        /* RETORNO DEPOSITO FECHADO BAIXANDO ESTOQUE     */
                     OR   (natur-oper.tp-oper-terc = 11 AND natur-oper.baixa-estoq = YES)        /* RETORNO ARMAZEM GERAL BAIXANDO ESTOQUE        */
                     OR   NOT CAN-FIND(FIRST item-doc-est
                                       WHERE item-doc-est.serie-docto  = componente.serie-docto 
                                         AND item-doc-est.nro-docto    = componente.nro-docto   
                                         AND item-doc-est.cod-emitente = componente.cod-emitente
                                         AND item-doc-est.nat-operacao = componente.nat-operacao
                                         AND item-doc-est.sequencia    = componente.sequencia
                                         AND item-doc-est.it-codigo    = componente.it-codigo NO-LOCK))
                THEN DO:

                     

                    ASSIGN d-porcent = (de-qtd-saldo-fatur * 100) / de-qtd-saldo-total.
                    bloco:
                    FOR EACH rat-saldo-terc 
                       WHERE rat-saldo-terc.serie-docto  = componente.serie-docto 
                         AND rat-saldo-terc.nro-docto    = componente.nro-docto 
                         AND rat-saldo-terc.cod-emitente = componente.cod-emitente 
                         AND rat-saldo-terc.nat-operacao = componente.nat-operacao
                         AND rat-saldo-terc.sequencia    = componente.sequencia
                         AND rat-saldo-terc.it-codigo    = componente.it-codigo NO-LOCK:



                        /*Nota fiscal de retorno do dep¢sito fechado gerada autom tico quando a NF de venda ‚ autorizada */
                        IF  l-nf-depos-fechado-auto THEN DO:
                            FOR FIRST nota-fiscal
                                WHERE ROWID(nota-fiscal) = rw-nota-fiscal NO-LOCK:

                                /*Verifica se existe o registro do lote na nota de venda DP*/
                                FOR FIRST tt-rat-saldo-terc-aux
                                    WHERE tt-rat-saldo-terc-aux.serie-docto  = rat-saldo-terc.serie-docto
                                      AND tt-rat-saldo-terc-aux.nro-docto    = rat-saldo-terc.nro-docto
                                      AND tt-rat-saldo-terc-aux.cod-emitente = rat-saldo-terc.cod-emitente
                                      AND tt-rat-saldo-terc-aux.nat-operacao = rat-saldo-terc.nat-operacao
                                      AND tt-rat-saldo-terc-aux.it-codigo    = rat-saldo-terc.it-codigo
                                      AND tt-rat-saldo-terc-aux.cod-refer    = rat-saldo-terc.cod-refer
                                      AND tt-rat-saldo-terc-aux.sequencia    = rat-saldo-terc.sequencia
                                      AND tt-rat-saldo-terc-aux.lote         = rat-saldo-terc.lote           NO-LOCK:
                                END.
                                IF NOT AVAIL tt-rat-saldo-terc-aux THEN NEXT.

                                /* IF ABAIXO FOI INCLUIDO POIS A BODI317SD ja passa a posi‡Æo do registro que est  sendo lido da rat-componente 
                                    atrav‚s da procedure pi-envia-rw-rat-componente*/
                                IF AVAIL bf-rat-componente AND  
                                         bf-rat-componente.serie-docto    =     rat-saldo-terc.serie-docto      AND 
                                         bf-rat-componente.nro-docto      =     rat-saldo-terc.nro-docto        AND 
                                         bf-rat-componente.cod-emitente   =     rat-saldo-terc.cod-emitente     AND 
                                         bf-rat-componente.nat-operacao   =     rat-saldo-terc.nat-operacao     AND 
                                         bf-rat-componente.it-codigo      =     rat-saldo-terc.it-codigo        AND 
                                         bf-rat-componente.cod-refer      =     rat-saldo-terc.cod-refer        AND 
                                         bf-rat-componente.sequencia      =     rat-saldo-terc.sequencia        AND 
                                         bf-rat-componente.lote           =     rat-saldo-terc.lote      THEN. 
                                    ELSE NEXT. 
                            END.
                        END.

                        FOR FIRST tt-baixa-estoq-item-terc
                            WHERE tt-baixa-estoq-item-terc.sequencia   = tt-item-terc.sequencia      
                              AND tt-baixa-estoq-item-terc.it-codigo   = rat-saldo-terc.it-codigo    
                              AND tt-baixa-estoq-item-terc.cod-depos   = rat-saldo-terc.cod-depos    
                              AND tt-baixa-estoq-item-terc.cod-localiz = rat-saldo-terc.cod-localiz  
                              AND tt-baixa-estoq-item-terc.lote        = rat-saldo-terc.lote         
                              AND tt-baixa-estoq-item-terc.char-1      = rat-saldo-terc.cod-refer NO-LOCK:
                        END.                                             
                        IF NOT AVAIL tt-baixa-estoq-item-terc THEN DO:
                            CREATE tt-baixa-estoq-item-terc.
                            ASSIGN tt-baixa-estoq-item-terc.sequencia    = tt-item-terc.sequencia
                                   tt-baixa-estoq-item-terc.it-codigo    = rat-saldo-terc.it-codigo
                                   tt-baixa-estoq-item-terc.cod-depos    = rat-saldo-terc.cod-depos
                                   tt-baixa-estoq-item-terc.cod-localiz  = rat-saldo-terc.cod-localiz
                                   tt-baixa-estoq-item-terc.lote         = rat-saldo-terc.lote
                                   tt-baixa-estoq-item-terc.dt-vali-lote = rat-saldo-terc.dt-vali-lote
                                   tt-baixa-estoq-item-terc.char-1       = rat-saldo-terc.cod-refer.
                        END.

                        FOR FIRST saldo-estoq 
                            WHERE saldo-estoq.it-codigo = rat-saldo-terc.it-codigo  
                              AND saldo-estoq.lote      = rat-saldo-terc.lote NO-LOCK:
                            ASSIGN tt-baixa-estoq-item-terc.dt-vali-lote = saldo-estoq.dt-vali-lote.
                        END.  					

                        ASSIGN de-qtd-aux-1 = 0.

                        IF CAN-FIND(FIRST rat-componente NO-LOCK
                                    WHERE rat-componente.serie-comp     = rat-saldo-terc.serie-docto
                                      AND rat-componente.nro-comp       = rat-saldo-terc.nro-docto
                                      AND rat-componente.cod-emitente   = rat-saldo-terc.cod-emitente
                                      AND rat-componente.nat-comp       = rat-saldo-terc.nat-operacao
                                      AND rat-componente.it-codigo      = rat-saldo-terc.it-codigo
                                      AND rat-componente.cod-refer      = rat-saldo-terc.cod-refer
                                      AND rat-componente.seq-comp       = rat-saldo-terc.sequencia
                                      AND rat-componente.lote           = rat-saldo-terc.lote 
                                      AND rat-componente.componente     = 1) THEN

                            FOR EACH rat-componente NO-LOCK
                               WHERE rat-componente.serie-comp     = rat-saldo-terc.serie-docto
                                 AND rat-componente.nro-comp       = rat-saldo-terc.nro-docto
                                 AND rat-componente.cod-emitente   = rat-saldo-terc.cod-emitente
                                 AND rat-componente.nat-comp       = rat-saldo-terc.nat-operacao
                                 AND rat-componente.it-codigo      = rat-saldo-terc.it-codigo
                                 AND rat-componente.cod-refer      = rat-saldo-terc.cod-refer
                                 AND rat-componente.seq-comp       = rat-saldo-terc.sequencia
                                 AND rat-componente.lote           = rat-saldo-terc.lote 
                                 AND rat-componente.componente     = 1:
                                ASSIGN de-qtd-aux-1 = de-qtd-aux-1 + rat-componente.quantidade.
                            END.


                        ASSIGN de-qtd-aux-2 = 0.

                        IF CAN-FIND(FIRST rat-componente NO-LOCK
                                    WHERE rat-componente.serie-comp   = rat-saldo-terc.serie-docto
                                      AND rat-componente.nro-comp     = rat-saldo-terc.nro-docto
                                      AND rat-componente.nat-comp     = rat-saldo-terc.nat-operacao
                                      AND rat-componente.cod-emitente = rat-saldo-terc.cod-emitente
                                      AND rat-componente.it-codigo    = rat-saldo-terc.it-codigo
                                      AND rat-componente.cod-refer    = rat-saldo-terc.cod-refer
                                      AND rat-componente.seq-comp     = rat-saldo-terc.sequencia
                                      AND rat-componente.lote         = rat-saldo-terc.lote
                                      AND rat-componente.componente   = 2) THEN
                            FOR EACH rat-componente NO-LOCK
                               WHERE rat-componente.serie-comp   = rat-saldo-terc.serie-docto
                                 AND rat-componente.nro-comp     = rat-saldo-terc.nro-docto
                                 AND rat-componente.nat-comp     = rat-saldo-terc.nat-operacao
                                 AND rat-componente.cod-emitente = rat-saldo-terc.cod-emitente
                                 AND rat-componente.it-codigo    = rat-saldo-terc.it-codigo
                                 AND rat-componente.cod-refer    = rat-saldo-terc.cod-refer
                                 AND rat-componente.seq-comp     = rat-saldo-terc.sequencia
                                 AND rat-componente.lote         = rat-saldo-terc.lote
                                 AND rat-componente.componente   = 2:   
                                ASSIGN de-qtd-aux-2 = de-qtd-aux-2 + rat-componente.quantidade.
                            END.

                        FOR FIRST rat-componente OF rat-saldo-terc NO-LOCK: END.

                        IF  l-nf-depos-fechado-auto THEN DO:
                            FOR FIRST tt-fat-ser-lote
                               WHERE tt-fat-ser-lote.nro-docto-terc    = rat-saldo-terc.nro-docto
                                 AND tt-fat-ser-lote.serie-docto-terc  = rat-saldo-terc.serie-docto
                                 AND tt-fat-ser-lote.cod-emitente-terc = rat-saldo-terc.cod-emitente
                                 AND tt-fat-ser-lote.nat-operacao-terc = rat-saldo-terc.nat-operacao
                                 AND tt-fat-ser-lote.sequencia-terc    = rat-saldo-terc.sequencia
                                 AND tt-fat-ser-lote.it-codigo-terc    = rat-saldo-terc.it-codigo
                                 AND tt-fat-ser-lote.cod-refer-terc    = rat-saldo-terc.cod-refer 
                                 AND tt-fat-ser-lote.nr-serlote        = rat-saldo-terc.lote NO-LOCK:
                            END.
                        END.

                        /*SE FOR UM FATURAMENTO TOTAL, BUSCA O SALDO DO LOTE */
                        IF de-qtd-saldo-fatur = de-qtd-saldo-total THEN DO:
                            IF {cdp/cd0066.i2 saldo-terc.cod-estabel} 
                            OR (natur-oper.tp-oper-terc = 2  AND natur-oper.baixa-estoq = YES) 
                            OR (natur-oper.tp-oper-terc = 9  AND natur-oper.baixa-estoq = YES)
                            OR (natur-oper.tp-oper-terc = 11 AND natur-oper.baixa-estoq = YES) THEN DO:
                                /* QUANTIDADE ORIGINAL DA REMESSA RECEBIDA PELO RE1001 - TOTAL DAS DEVOLUCOES SIMBOLICAS OU DE MERCADORIAS */ 

                                IF  l-nf-depos-fechado-auto
                                AND AVAIL tt-fat-ser-lote THEN DO:
                                    IF (tt-fat-ser-lote.qt-item-terc - de-qtd-aux-2) = 0 THEN
                                        NEXT.
                                    ELSE 
                                        ASSIGN tt-baixa-estoq-item-terc.quantidade = tt-fat-ser-lote.qt-item-terc. /*- de-qtd-aux-2*/.
                                END.
                                ELSE DO:
                                    IF (rat-componente.quantidade - de-qtd-aux-2) = 0 THEN
                                        NEXT.
                                    ELSE 
                                        ASSIGN tt-baixa-estoq-item-terc.quantidade = rat-componente.quantidade - de-qtd-aux-2.
                                END.
                            END.
                            ELSE DO:
                                /* QUANTIDADE ORIGINAL DA REMESSA RECEBIDA PELO RE1001 - TOTAL DOS FATURAMENTOS OU DEVOLUCOES DE MERCADORIAS */ 
                                IF l-nf-depos-fechado-auto
                                AND AVAIL tt-fat-ser-lote THEN DO:
                                    IF (tt-fat-ser-lote.qt-item-terc - (de-qtd-aux-1 + de-qtd-aux-2)) = 0 THEN
                                       NEXT.
                                    ELSE 
                                       ASSIGN tt-baixa-estoq-item-terc.quantidade = (tt-fat-ser-lote.qt-item-terc - (de-qtd-aux-1 + de-qtd-aux-2)).
                                END.
                                ELSE DO:
                                    IF (rat-componente.quantidade - (de-qtd-aux-1 + de-qtd-aux-2)) = 0 THEN
                                       NEXT.
                                    ELSE 
                                       ASSIGN tt-baixa-estoq-item-terc.quantidade = (rat-componente.quantidade - (de-qtd-aux-1 + de-qtd-aux-2)).                                
                                END.
                            END.
                        END.
                        ELSE DO:
                            IF {cdp/cd0066.i2 saldo-terc.cod-estabel} 
                            OR (natur-oper.tp-oper-terc = 2  AND natur-oper.baixa-estoq = YES) 
                            OR (natur-oper.tp-oper-terc = 9  AND natur-oper.baixa-estoq = YES) 
                            OR (natur-oper.tp-oper-terc = 11 AND natur-oper.baixa-estoq = YES) THEN DO:
                                /* NAO FORAM REALIZADAS DEVOLUCOES SIMBOLICAS OU DE MERCADORIA */
                                IF de-qtd-aux-2 = 0 THEN DO:
                                   ASSIGN tt-baixa-estoq-item-terc.quantidade = IF   l-nf-depos-fechado-auto AND AVAIL tt-fat-ser-lote THEN tt-fat-ser-lote.qt-item-terc 
                                                                                ELSE ROUND(rat-componente.quantidade * (d-porcent / 100), IF item.fraciona THEN 4 ELSE 0).
                                END.
                                ELSE DO:	
                                    /* FAZ A PROPORSAO SE BASEANDO PELA QUANTIDADE AINDA DISPONIVEL PARA DEVOLUCAO */
                                    ASSIGN tt-baixa-estoq-item-terc.quantidade = IF   l-nf-depos-fechado-auto AND AVAIL tt-fat-ser-lote THEN tt-fat-ser-lote.qt-item-terc
                                                                                 ELSE ROUND((rat-componente.quantidade - de-qtd-aux-2) * (d-porcent / 100), IF item.fraciona THEN 4 ELSE 0).                                
                                END.
                            END.
                            ELSE DO:
                                /* NAO FORAM REALIZADAS FATURAMENTOS DESSA REMESSA */
                                IF de-qtd-aux-1 = 0 then do:
                                   ASSIGN tt-baixa-estoq-item-terc.quantidade =  IF   l-nf-depos-fechado-auto AND AVAIL tt-fat-ser-lote THEN tt-fat-ser-lote.qt-item-terc 
                                                                                 ELSE  round(rat-componente.quantidade * (d-porcent / 100), IF item.fraciona THEN 4 ELSE 0).
                                END.
                                ELSE DO:	
                                   /* FAZ A PROPOR€AO SE BASEANDO PELA QUANTIDADE AINDA DISPONIVEL PARA DEVOLUCAO */
                                   ASSIGN tt-baixa-estoq-item-terc.quantidade = IF   l-nf-depos-fechado-auto AND AVAIL tt-fat-ser-lote THEN (tt-fat-ser-lote.qt-item-terc - (de-qtd-aux-1 + de-qtd-aux-2))
                                                                                ELSE round((rat-componente.quantidade - (de-qtd-aux-1 + de-qtd-aux-2)) * (d-porcent / 100), IF item.fraciona THEN 4 ELSE 0).
                                END.
                            END.          
                        END.

                        /* SE NÃO EXISTE SALDO DISPONIVEL */
                        IF tt-baixa-estoq-item-terc.quantidade = 0 THEN
                            DELETE tt-baixa-estoq-item-terc.

                    END. /*for each rat-saldo-terc*/

                    IF CAN-FIND(FIRST tt-baixa-estoq-item-terc 
                                WHERE tt-baixa-estoq-item-terc.sequencia = tt-item-terc.sequencia) THEN DO:

                        ASSIGN de-qt-total-fat = 0.

                        /* SE A PROPOR€AO GEROU UMA DIFERENCA */					
                        FOR EACH tt-baixa-estoq-item-terc
                           WHERE tt-baixa-estoq-item-terc.sequencia = tt-item-terc.sequencia:
                            ASSIGN de-qt-total-fat = de-qt-total-fat +  tt-baixa-estoq-item-terc.quantidade.
                        END.

                        IF de-qt-total-fat <> tt-item-terc.quantidade THEN DO:
                            IF de-qt-total-fat > tt-item-terc.quantidade THEN DO:
                                FOR FIRST tt-baixa-estoq-item-terc
                                    WHERE tt-baixa-estoq-item-terc.sequencia = tt-item-terc.sequencia
                                      AND tt-baixa-estoq-item-terc.quantidade > (de-qt-total-fat - tt-item-terc.quantidade): 
                                    ASSIGN tt-baixa-estoq-item-terc.quantidade = tt-baixa-estoq-item-terc.quantidade - (de-qt-total-fat - tt-item-terc.quantidade).
                                END.
                            END.
                            ELSE DO:

                                FOR FIRST tt-baixa-estoq-item-terc
                                   WHERE tt-baixa-estoq-item-terc.sequencia = tt-item-terc.sequencia:
								   ASSIGN tt-baixa-estoq-item-terc.quantidade = tt-baixa-estoq-item-terc.quantidade + (tt-item-terc.quantidade - de-qt-total-fat).
                                END.
                            END.

                            ASSIGN de-qtd-saldo = 0.				
                        END.
                    END.
                END.
                ELSE
                    FOR EACH rat-lote 
                       WHERE rat-lote.serie-docto  = componente.serie-docto 
                         AND rat-lote.nro-docto    = componente.nro-docto 
                         AND rat-lote.cod-emitente = componente.cod-emitente 
                         AND rat-lote.nat-operacao = componente.nat-operacao
                         AND rat-lote.sequencia    = componente.sequencia
                         AND rat-lote.it-codigo    = componente.it-codigo NO-LOCK:

                        CREATE tt-baixa-estoq-item-terc.
                        ASSIGN tt-baixa-estoq-item-terc.sequencia    = tt-item-terc.sequencia
                               tt-baixa-estoq-item-terc.it-codigo    = rat-lote.it-codigo
                               tt-baixa-estoq-item-terc.cod-depos    = rat-lote.cod-depos
                               tt-baixa-estoq-item-terc.cod-localiz  = rat-lote.cod-localiz
                               tt-baixa-estoq-item-terc.lote         = rat-lote.lote
                               tt-baixa-estoq-item-terc.dt-vali-lote = rat-lote.dt-vali-lote
                               tt-baixa-estoq-item-terc.char-1       = rat-lote.cod-refer.

                        FOR FIRST saldo-estoq 
                            WHERE saldo-estoq.it-codigo = rat-lote.it-codigo 
                              AND saldo-estoq.lote      = rat-lote.lote NO-LOCK:
                            ASSIGN tt-baixa-estoq-item-terc.dt-vali-lote = saldo-estoq.dt-vali-lote.
                        END.

                        IF rat-lote.quantidade > de-qtd-saldo THEN DO:
                           ASSIGN tt-baixa-estoq-item-terc.quantidade = de-qtd-saldo
                                 de-qtd-saldo = 0.
                           LEAVE.
                        END.
                        ELSE 
                           ASSIGN tt-baixa-estoq-item-terc.quantidade = rat-lote.quantidade
                                 de-qtd-saldo = de-qtd-saldo - tt-baixa-estoq-item-terc.quantidade.
                    END.
            END.	

            IF de-qtd-saldo <> 0 THEN DO:
                IF NOT CAN-FIND(FIRST tt-baixa-estoq-item-terc NO-LOCK
                                WHERE tt-baixa-estoq-item-terc.sequencia = tt-item-terc.sequencia)
                THEN DO:
    
                    CREATE  tt-baixa-estoq-item-terc.
                    ASSIGN  tt-baixa-estoq-item-terc.sequencia    = tt-item-terc.sequencia
                            tt-baixa-estoq-item-terc.it-codigo    = componente.it-codigo
                            tt-baixa-estoq-item-terc.cod-depos    = if  saldo-terc.cod-depos   <> "":U 
                                                                    then saldo-terc.cod-depos
                                                                    else item.deposito-pad
                            tt-baixa-estoq-item-terc.cod-localiz  = if  saldo-terc.cod-localiz <> "":U 
                                                                    then saldo-terc.cod-localiz 
                                                                    else item.cod-localiz
                            tt-baixa-estoq-item-terc.lote         = saldo-terc.lote
                            tt-baixa-estoq-item-terc.dt-vali-lote = componente.dt-vali-lote
                            tt-baixa-estoq-item-terc.quantidade   = de-qtd-saldo.
                END.
            END.
    END.

    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */

END PROCEDURE.    



/*-------------------------------------------------------------------------------------------------------

 Procedimento: atualizaQtAlocadaSaldoTerc:

     Objetivo: Atualiza quantidade alocada no saldo em proder de terceiros.
          
 Parƒmetros de Entrada/Sa¡da:
   Entrada: p-l-aloca-saldo-terc: Indica se ir  alocar ou desalocar o saldo em poder de terceiros;
            p-c-cod-emitente....: C¢digo do emitente do saldo em poder de terceiros;
            p-c-nro-docto.......: N£mero do saldo em poder de terceiros;
            p-c-serie-docto.....: S‚rie do saldo em poder de terceiros;
            p-c-nat-operacao....: Natureza de opera‡Æo do saldo em poder de terceiros;
            p-c-it-codigo.......: Item do saldo em poder de terceiros;
            p-c-cod-refer.......: Referˆncia do saldo em poder de terceiros;
            p-i-sequencia.......: Sequeˆncia do saldo em poder de terceiros;
            p-de-quantidade.....: Quantidade que ir  ser alocada ou desalocada;
   Sa¡da..: p-l-procedimento-ok.: Retorna que o procedimento ocorreu por completo;

 Registros que devem estar dispon¡veis antes da execu‡Æo deste procedimento: 
   <Nenhum>
         
 BOS Necess rios para executar esse m‚todo:
   <Nenhum>

--------------------------------------------------------------------------------------------------------*/

PROCEDURE atualizaQtAlocadaSaldoTerc:
    /* Defini‡Æo dos parƒmetros de Entrada/Sa¡da */
    def input  param p-l-aloca-saldo-terc as log form "Aloca/Desaloca":U no-undo.
    def input  param p-c-cod-emitente     like saldo-terc.cod-emitente no-undo.
    def input  param p-c-nro-docto        like saldo-terc.nro-docto    no-undo.
    def input  param p-c-serie-docto      like saldo-terc.serie-docto  no-undo.
    def input  param p-c-nat-operacao     like saldo-terc.nat-operacao no-undo.
    def input  param p-c-it-codigo        like saldo-terc.it-codigo    no-undo.
    def input  param p-c-cod-refer        like saldo-terc.cod-refer    no-undo.
    def input  param p-i-sequencia        like saldo-terc.sequencia    no-undo.
    def input  param p-de-quantidade      as dec                       no-undo.
    def output param p-l-procedimento-ok  as log                       no-undo.

    assign c-ultimo-metodo-exec = replace(program-name(1)," ":U, "~~":U).

    IF NOT AVAIL ITEM
    OR (AVAIL ITEM AND ITEM.it-codigo <> p-c-it-codigo) THEN
        FOR FIRST ITEM 
            WHERE ITEM.it-codigo = p-c-it-codigo NO-LOCK:
        END.

    EMPTY TEMP-TABLE tt-baixa-estoq-item-terc-aux.

    IF l-nf-depos-fechado-auto THEN DO:
        IF  AVAIL item
        AND ITEM.tipo-con-est <> 1 THEN DO:
            
            RUN pi-rateio-quantidade.

            bloco:
            FOR EACH tt-rat-saldo-terc-aux 
               WHERE tt-rat-saldo-terc-aux.serie-docto  = p-c-serie-docto 
                 AND tt-rat-saldo-terc-aux.nro-docto    = p-c-nro-docto 
                 AND tt-rat-saldo-terc-aux.cod-emitente = p-c-cod-emitente 
                 AND tt-rat-saldo-terc-aux.nat-operacao = p-c-nat-operacao
                 AND tt-rat-saldo-terc-aux.it-codigo    = p-c-it-codigo
                 AND tt-rat-saldo-terc-aux.cod-refer    = p-c-cod-refer
                 AND tt-rat-saldo-terc-aux.sequencia    = p-i-sequencia 
                 AND tt-rat-saldo-terc-aux.lote         = bf-rat-componente.lote NO-LOCK:

                FOR FIRST tt-baixa-estoq-item-terc-aux
                    WHERE tt-baixa-estoq-item-terc-aux.serie-docto  = tt-rat-saldo-terc-aux.serie-docto 
                      AND tt-baixa-estoq-item-terc-aux.nro-docto    = tt-rat-saldo-terc-aux.nro-docto   
                      AND tt-baixa-estoq-item-terc-aux.cod-emitente = tt-rat-saldo-terc-aux.cod-emitente
                      AND tt-baixa-estoq-item-terc-aux.nat-operacao = tt-rat-saldo-terc-aux.nat-operacao
                      AND tt-baixa-estoq-item-terc-aux.it-codigo    = tt-rat-saldo-terc-aux.it-codigo   
                      AND tt-baixa-estoq-item-terc-aux.cod-depos    = tt-rat-saldo-terc-aux.cod-depos
                      AND tt-baixa-estoq-item-terc-aux.char-1       = tt-rat-saldo-terc-aux.cod-refer   
                      AND tt-baixa-estoq-item-terc-aux.cod-localiz  = tt-rat-saldo-terc-aux.cod-localiz
                      AND tt-baixa-estoq-item-terc-aux.lote         = tt-rat-saldo-terc-aux.lote:


                    ASSIGN p-de-quantidade = tt-baixa-estoq-item-terc-aux.quantidade.
                END.

                for first saldo-terc 
                    where saldo-terc.cod-emitente = tt-rat-saldo-terc-aux.cod-emitente
                    and   saldo-terc.nro-docto    = tt-rat-saldo-terc-aux.nro-docto
                    and   saldo-terc.serie-docto  = tt-rat-saldo-terc-aux.serie-docto
                    and   saldo-terc.nat-operacao = tt-rat-saldo-terc-aux.nat-operacao
                    and   saldo-terc.it-codigo    = tt-rat-saldo-terc-aux.it-codigo
                    and   saldo-terc.cod-refer    = tt-rat-saldo-terc-aux.cod-refer
                    and   saldo-terc.sequencia    = tt-rat-saldo-terc-aux.sequencia exclusive-lock:

                    if  p-l-aloca-saldo-terc  then /* Aloca    */
                        assign saldo-terc.dec-1         = saldo-terc.dec-1 + p-de-quantidade.     
                    else /* Desaloca */
                        assign saldo-terc.dec-1         = saldo-terc.dec-1 - p-de-quantidade
                               saldo-terc.dec-1         = if  saldo-terc.dec-1 < 0 
                                                          then 0 
                                                          else saldo-terc.dec-1.
                end.
            END.
        END.
        ELSE DO:
            for first saldo-terc 
                where saldo-terc.cod-emitente = p-c-cod-emitente
                and   saldo-terc.nro-docto    = p-c-nro-docto
                and   saldo-terc.serie-docto  = p-c-serie-docto
                and   saldo-terc.nat-operacao = p-c-nat-operacao
                and   saldo-terc.it-codigo    = p-c-it-codigo
                and   saldo-terc.cod-refer    = p-c-cod-refer
                and   saldo-terc.sequencia    = p-i-sequencia exclusive-lock:
        
                if  p-l-aloca-saldo-terc  then /* Aloca    */
                    assign saldo-terc.dec-1         = saldo-terc.dec-1 + p-de-quantidade.     
                else /* Desaloca */
                    assign saldo-terc.dec-1         = saldo-terc.dec-1 - p-de-quantidade
                           saldo-terc.dec-1         = if  saldo-terc.dec-1 < 0 
                                                      then 0 
                                                      else saldo-terc.dec-1.
            end.
        END.
    END.
    ELSE DO:
        for first saldo-terc 
            where saldo-terc.cod-emitente = p-c-cod-emitente
            and   saldo-terc.nro-docto    = p-c-nro-docto
            and   saldo-terc.serie-docto  = p-c-serie-docto
            and   saldo-terc.nat-operacao = p-c-nat-operacao
            and   saldo-terc.it-codigo    = p-c-it-codigo
            and   saldo-terc.cod-refer    = p-c-cod-refer
            and   saldo-terc.sequencia    = p-i-sequencia exclusive-lock:
    
            if  p-l-aloca-saldo-terc  then /* Aloca    */
                assign saldo-terc.dec-1         = saldo-terc.dec-1 + p-de-quantidade.     
            else /* Desaloca */
                assign saldo-terc.dec-1         = saldo-terc.dec-1 - p-de-quantidade
                       saldo-terc.dec-1         = if  saldo-terc.dec-1 < 0 
                                                  then 0 
                                                  else saldo-terc.dec-1.
        end.
    END.


    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
END PROCEDURE.    

/*-------------------------------------------------------------------------------------------------------

 Procedimento: buscaTempTableItemErro:

     Objetivo: Retorna os registros da tabelas tempor ria tt-item-erro.
          
 Parƒmetros de Entrada/Sa¡da:
   Entrada: <Nenhum>
   Sa¡da..: tabela tt-item-erro............: Dados de itens que nao possuem a quantidade total em terceiros;
            
 Registros que devem estar dispon¡veis antes da execu‡Æo deste procedimento: 
   <Nenhum>
         
 BOS Necess rios para executar esse m‚todo:
   <Nenhum>

--------------------------------------------------------------------------------------------------------*/

PROCEDURE buscaTempTableItemErro:
    def OUTPUT param table for tt-item-erro.
    
END PROCEDURE.


PROCEDURE SetaSeqNota:    
    /* Defini»’o dos par³metros de Entrada/Sa­da */
    DEF INPUT  PARAM p-seq-wt-docto      LIKE wt-docto.seq-wt-docto no-undo.
    
    ASSIGN i-seq-wt-docto = p-seq-wt-docto.       
    
END PROCEDURE. 
/*-------------------------------------------------------------------------------------------------------

 Procedimento: geraItensPelaEstrutura:

     Objetivo: Gera‡Æo de itens para a nota a partir da estrutura.
          
 Parƒmetros de Entrada/Sa¡da:
   Entrada: p-i-ord-prod.......: Ordem de produ‡Æo;
            p-c-item-pai.......: C¢digo do item pai (quando por estrutura) ou c¢digo do item (item a item);
            p-de-quantidade....: Quantidade do item pai (quando por estrutura) ou qt do item (item a item);
            p-de-vl-item.......: Valor total do item (recebimento) ou pre‡o unit rio do item (faturamento);
            p-da-dt-corte......: Data de corte para gera‡Æo por estutura;
            p-i-gera-est.......: Indica se ‚ por gera‡Æo por estrutura ou item (1 - Estrutura / 2 - Item);
            p-i-seq-item-um....: N£mero da primeira sequˆncia que ser  gerada;
            p-i-inc-seq........: De quanto em quanto as sequˆncias serÆo incrementadas (1 em 1, 10 em 10 etc);
            p-c-tipo-oper-terc.: Tipo de opera‡äes com terceiros quando nÆo possuir natureza;
            p-c-nat-operacao...: Natureza de opera‡Æo;
            p-c-cod-estabel....: C¢digo do estabelecimento;
            p-i-cod-emitente...: c¢digo do emitente; 
            p-l-recebimento....: Indica se o m¢dulo de recebimento executou o m‚todo;
            p-da-dt-trans......: Data m xima para considerar notas de reajuste (Geralmente data da transa‡Æo)
   Sa¡da..: p-l-procedimento-ok: Retorna que o procedimento ocorreu por completo;

 Registros que devem estar dispon¡veis antes da execu‡Æo deste procedimento: 
   <Nenhum>
         
 BOS Necess rios para executar esse m‚todo:
   <Nenhum>

--------------------------------------------------------------------------------------------------------*/

PROCEDURE geraItensPelaEstrutura:
    /* Defini‡Æo dos parƒmetros de Entrada/Sa¡da */
    def input  param p-i-ord-prod        like item-doc-est.nr-ord-prod no-undo.
    def input  param p-c-item-pai        like item-doc-est.it-codigo   no-undo.
    def input  param p-de-quantidade     like item-doc-est.quantidade  no-undo.
    def input  param p-vl-item           as dec                        no-undo.
    def input  param p-da-dt-corte       as date                       no-undo.
    def input  param p-i-gera-est        as int                        no-undo.
    def input  param p-i-seq-item-um     as int                        no-undo.
    def input  param p-i-inc-seq         as int                        no-undo.
    def input  param p-c-tipo-oper-terc  as char                       no-undo.
    def input  param p-c-nat-operacao    like natur-oper.nat-operacao  no-undo.
    def input  param p-c-cod-estabel     like estabelec.cod-estabel    no-undo.
    def input  param p-i-cod-emitente    like emitente.cod-emitente    no-undo.
    def input  param p-l-recebimento     as log form "RE/FT":U         no-undo.
    def input  param p-da-dt-trans       as date                       no-undo.
    def output param p-l-procedimento-ok as log                        no-undo.

    assign c-ultimo-metodo-exec = replace(program-name(1)," ":U, "~~":U).

    /* Definicao de variaveis locais */
    def var l-proc-ok-aux    as log                       no-undo.
    def var c-item           like item-doc-est.it-codigo  no-undo.
    def var de-qtd-saldo     like item-doc-est.quantidade no-undo.
	def var de-qtd-saldo-aux like item-doc-est.quantidade no-undo.
    DEF VAR de-quant        LIKE reservas.quant-orig     NO-UNDO.
    def var i-sequencia     like item-doc-est.sequencia  no-undo.
    def var de-disponivel   like movto-estoq.quantidade  no-undo.
    def var i-tipo-sal-terc as   int                     no-undo.
    def var l-remessa       as   log                     no-undo.
    def var l-retorno       as   log                     no-undo.
    def var i-fator         as   dec    extent 22        no-undo.
    def var i-retorno       as   int                     no-undo.
    def var rw-end-ret      as   rowid   extent 22       no-undo.
    def var de-indice       as   dec                     no-undo.
    def var c-tipo-nota     as   char                    no-undo.
    DEF VAR l-tem-upc       AS   LOGICAL                 NO-UNDO.

    &if "{&bf_dis_versao_ems}" >= "2.062" &then
        DEFINE VARIABLE h-api024         AS HANDLE     NO-UNDO.
        
        IF  not valid-handle(h-api024) then
            run cdp/cdapi024.p persistent set h-api024.
    &endif

    if c-nom-prog-dpc-mg97  <> ""
    or c-nom-prog-appc-mg97 <> ""
    or c-nom-prog-upc-mg97  <> "" then
      assign l-tem-upc = yes.  


    if  not avail natur-oper
    or  natur-oper.nat-operacao <> p-c-nat-operacao then
        for first natur-oper
            fields (natur-oper.nat-operacao
                    natur-oper.terceiros
                    natur-oper.tp-oper-terc
                    natur-oper.tipo
                    natur-oper.baixa-estoq
                    natur-oper.transf)
            where natur-oper.nat-operacao = p-c-nat-operacao no-lock:
        end.
    
    &if  defined(bf_mat_custeio_item) &then
        if  not avail estab-mat 
        or  estab-mat.cod-estabel <> p-c-cod-estabel then
            for first estab-mat
                fields (cod-estabel
                        custo-contab
                        usa-on-line)
                where estab-mat.cod-estabel = p-c-cod-estabel no-lock:
            end.    
    &else 
        if  not avail estabelec 
        or  estabelec.cod-estabel <> p-c-cod-estabel then
            for first estabelec
                fields (cod-estabel
                        custo-contab
                        usa-padrao
                        usa-on-line
                        usa-mensal)
                where estabelec.cod-estabel = p-c-cod-estabel no-lock:
            end.
    &endif
     
    if  not avail natur-oper then 
        assign c-tipo-nota = p-c-tipo-oper-terc.
    
    ASSIGN l-remessa = IF  AVAIL natur-oper 
                       THEN (    natur-oper.terceiros 
                             AND (   natur-oper.tp-oper-terc = 1 
                                  OR natur-oper.tp-oper-terc = 3
                                  OR natur-oper.tp-oper-terc = 8
                                  OR natur-oper.tp-oper-terc = 10))
                       ELSE (   c-tipo-nota = "4":U 
                             OR c-tipo-nota = "6":U)
           l-retorno = IF  AVAIL natur-oper 
                       THEN (    natur-oper.terceiros 
                             AND (   natur-oper.tp-oper-terc = 2 
                                  OR natur-oper.tp-oper-terc = 4 
                                  OR natur-oper.tp-oper-terc = 5
                                  OR natur-oper.tp-oper-terc = 9
                                  OR natur-oper.tp-oper-terc = 11))
                       ELSE (   c-tipo-nota = "5":U 
                             OR c-tipo-nota = "7":U 
                             OR c-tipo-nota = "8":U).

    if  not l-remessa 
    and not l-retorno then 
        return.

    EMPTY TEMP-TABLE tt-item-erro.
    /* Determina Tipo de Saldo-Terc - i-tipo-sal-terc */
    if  avail natur-oper then do:
        run determinaTipoSaldoTer(input  natur-oper.nat-operacao,
                                  output i-tipo-sal-terc,
                                  output l-proc-ok-aux).
        {dibo/bodi317.i3 l-proc-ok-aux}
    end.                                  
    else
        /* Notas do Recebimento F¡sico - sem natureza de opera‡Æo */
        assign i-tipo-sal-terc = if c-tipo-nota = "4":U /* Rem Benef */
                                 then 2
                                 else if c-tipo-nota = "5":U /* Ret Benef */
                                      then 1 
                                      else if  c-tipo-nota = "6":U /* Entr Consig */
                                           then 5 
                                           else if  c-tipo-nota = "7":U /* Fatur Consig */
                                                then 5
                                                else if  c-tipo-nota = "8":U /* Devol Consig */
                                                     then 4
                                                     else 0.                             


    if  p-i-ord-prod <> 0 then /* Geracao Itens pela Reserva */
        for first ord-prod
            fields (ord-prod.qt-ordem)
            where ord-prod.nr-ord-produ = p-i-ord-prod no-lock:
          
            for each reservas 
                where reservas.nr-ord-produ = p-i-ord-prod
                and   reservas.quant-orig  > 0 no-lock
		by reservas.it-codigo:
        
                assign de-qtd-saldo = reservas.quant-orig - (reservas.quant-atend + reservas.quant-terc).
        
                if  l-remessa 
                and de-qtd-saldo <= 0 then 
                    next.

                ASSIGN de-quant = reservas.quant-orig.
                /*************************** Chamada EPC ******************************/
                IF  c-nom-prog-dpc-mg97  <> "" 
                OR  c-nom-prog-appc-mg97 <> "" 
                OR  c-nom-prog-upc-mg97  <> "" THEN DO:
                    FOR EACH tt-epc:
                        DELETE tt-epc.
                    END.
                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "Utiliza_Quant_Atend"
                           tt-epc.cod-parameter = "l_retorno"
                           tt-epc.val-parameter = STRING(l-retorno) + "," + STRING(p-l-recebimento).
            
                    {include/i-epc201.i "Utiliza_Quant_Atend"}

                    FOR first tt-epc 
                         where tt-epc.cod-event     = "Utiliza_Quant_Atend" 
                         and   tt-epc.cod-parameter = "Value_Qtd_Atend" 
                         AND   tt-epc.val-parameter = "YES":
                         ASSIGN de-quant = reservas.quant-atend.
                     END.
                    for each RowErrors
                        where RowErrors.ErrorType = "INTERNAL":U:
                        delete RowErrors.
                    end.
                END.
                /******************************* Fim EPC **********************************/ 

                create tt-item.
                assign tt-item.it-codigo   = reservas.it-codigo
                       tt-item.cod-refer   = reservas.cod-refer
                       tt-item.nr-ord-prod = p-i-ord-prod
                       tt-item.rw-reserva  = rowid(reservas)
                       tt-item.quantidade  = p-de-quantidade * de-quant / ord-prod.qt-ordem.
                 
                FOR FIRST ITEM NO-LOCK
                    WHERE ITEM.it-codigo = reservas.it-codigo:
                END.

                if  l-remessa 
                and tt-item.quantidade > de-qtd-saldo then 
                    assign tt-item.quantidade = de-qtd-saldo.

                if  AVAIL item
                AND not item.fraciona 
                and ROUND(tt-item.quantidade, 0) <> tt-item.quantidade then
                    ASSIGN tt-item.quantidade = ROUND(tt-item.quantidade, 0).
            end.
        end.
    else 
        if  p-i-gera-est = 1 then do: /* Gera‡Æo por estrutura */
            assign i-fator[1] = p-de-quantidade
                   i-retorno  = 1
                   c-item     = p-c-item-pai.
        
            comeco:
            repeat:
                for first estrutura 
                    fields (estrutura.es-codigo
                            estrutura.qtd-compon
                            estrutura.qtd-item   
                            estrutura.proporcao
                            estrutura.quant-usada
                            estrutura.fantasma
                            estrutura.it-codigo
                            estrutura.sequencia
                            estrutura.cod-refer
                            estrutura.log-quant-fix)
                    where estrutura.it-codigo    = c-item 
                    and   estrutura.data-inicio <= p-da-dt-corte
                    and   estrutura.data-termino > p-da-dt-corte
                    and   estrutura.quant-usada  > 0 no-lock:
                end.
        
                if  not available estrutura 
                and i-retorno < 3 then
                    leave.
                
                if  i-retorno = 1 then
                    assign i-retorno             = i-retorno + 1
                           rw-end-ret[i-retorno] = rowid(estrutura).
        
                repeat:
                    if  available estrutura then do:
                        for first item 
                            fields (item.it-codigo
                                    item.tipo-contr)
                            where item.it-codigo = estrutura.es-codigo no-lock:
                        end.
                        
                        &IF DEFINED (bf_man_sfc_lc) &THEN
                            /* D_MAN002 - Quantidade fixa para componentes de engenharia */
                            assign i-fator[i-retorno] = if estrutura.log-quant-fix then estrutura.qtd-compon
                                                        else i-fator[i-retorno - 1] * estrutura.qtd-compon / estrutura.qtd-item     * estrutura.proporcao  / 100.
                        &ELSE
                            assign i-fator[i-retorno] = i-fator[i-retorno - 1] * estrutura.quant-usada *
                                                        estrutura.proporcao    / 100.                
                        &ENDIF
                        

                        /*--------- INICIO EPC ---------*/
                        IF l-tem-upc THEN
                            RUN pi-epc (INPUT i-fator[i-retorno],
                                        INPUT estrutura.es-codigo,
                                        INPUT p-da-dt-corte,
                                        INPUT STRING(TEMP-TABLE tt-item:HANDLE)).
                        /*--------- FIM EPC ---------*/


                        if  estrutura.fantasma then do:
                            for first b-estrutura 
                                fields ()
                                where b-estrutura.it-codigo    = estrutura.es-codigo  
                                and   b-estrutura.data-inicio <= p-da-dt-corte 
                                and   b-estrutura.data-termino > p-da-dt-corte no-lock:
                            end.
                            
                            if  not avail b-estrutura 
                            and item.it-codigo  <> "":U 
                            and item.tipo-contr <> 4 then do: /* Debito Direto */
                                find first tt-item 
                                     where tt-item.it-codigo = item.it-codigo no-error.

                                if  not avail tt-item then do:
                                    create tt-item.
                                    assign tt-item.it-codigo = item.it-codigo
                                           tt-item.cod-refer = estrutura.cod-refer.
                                end.

                                assign tt-item.quantidade = tt-item.quantidade + i-fator[i-retorno].
                            end.

                            assign c-item = estrutura.es-codigo
                                   i-retorno = i-retorno + 1
                                   rw-end-ret[i-retorno] = rowid(estrutura).
                            next comeco.
                        end.
                        else
                            if  item.tipo-contr <> 4                /* Debito Direto */ 
                            and item.it-codigo <> "":U then do:
                                find first tt-item 
                                     where tt-item.it-codigo = item.it-codigo no-error.

                                if  not avail tt-item then do:
                                    create tt-item.
                                    assign tt-item.it-codigo = item.it-codigo
                                           tt-item.cod-refer = estrutura.cod-refer.
                                end.
                  
                                assign tt-item.quantidade = tt-item.quantidade + i-fator[i-retorno].
                            end.
                    end.
                    else do:
                        if  i-retorno = 2 then
                            leave comeco.
                        else
                            for first estrutura 
                                fields (estrutura.es-codigo
                                        estrutura.qtd-compon
                                        estrutura.qtd-item   
                                        estrutura.proporcao
                                        estrutura.quant-usada
                                        estrutura.fantasma
                                        estrutura.it-codigo)
                                where rowid(estrutura) = rw-end-ret[i-retorno] no-lock:

                                assign c-item = estrutura.it-codigo
                                       i-retorno = i-retorno - 1.
                            end.
                    end.

                    find next estrutura 
                         where estrutura.it-codigo    = c-item
                         and   estrutura.data-inicio <= p-da-dt-corte
                         and   estrutura.data-termino > p-da-dt-corte
                         and   estrutura.quant-usada  > 0 no-lock no-error.
                end.
            end.
        end.
        else do:
            create tt-item.
            assign tt-item.it-codigo  = p-c-item-pai
                   tt-item.quantidade = p-de-quantidade.
        end.

    assign i-sequencia = p-i-seq-item-um.

    if  p-i-ord-prod <> 0 then 
        for first ord-prod 
            where ord-prod.nr-ord-produ = p-i-ord-prod no-lock:
        end.

    /*************************** Chamada EPC ******************************/
    IF  c-nom-prog-dpc-mg97  <> "" 
    OR  c-nom-prog-appc-mg97 <> "" 
    OR  c-nom-prog-upc-mg97  <> "" THEN DO:
        ASSIGN c-char = STRING(p-i-cod-emitente) + "," + STRING(p-c-cod-estabel)  + "," +
                        STRING(i-tipo-sal-terc)  + "," + STRING(p-c-nat-operacao) + "," +
                        STRING(c-tipo-nota)      + "," + STRING(p-da-dt-trans)    + "," +
                        STRING(i-sequencia)      + "," + STRING(p-i-inc-seq)      + "," +
                        STRING(l-retorno)        + "," + STRING(p-l-recebimento).
        FOR EACH tt-epc:
            DELETE tt-epc.
        END.
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "afterCreateItemTerc"
               tt-epc.cod-parameter = "Handle_BO"
               tt-epc.val-parameter = STRING(THIS-PROCEDURE) + ";" + c-char + ";" + STRING(TEMP-TABLE tt-item-terc:HANDLE).
        {include/i-epc201.i "afterCreateItemTerc"}                          
        for each  RowErrors
            where RowErrors.ErrorType = "INTERNAL":U:
            delete RowErrors.
        end.
    END.
    /******************************* Fim EPC **********************************/ 

    for each tt-item:
        find item 
             where item.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
    
        if  l-retorno THEN DO:
            for each saldo-terc use-index estab-fornec NO-LOCK
                where saldo-terc.it-codigo     = item.it-codigo
                and   saldo-terc.cod-emitente  = p-i-cod-emitente
                and   saldo-terc.cod-estabel   = p-c-cod-estabel
                and   saldo-terc.tipo-sal-terc = i-tipo-sal-terc
                and   saldo-terc.quantidade    > 0 
                and   (   saldo-terc.nr-ord-produ = p-i-ord-prod
                      OR  saldo-terc.nr-ord-produ = 0)
                by saldo-terc.dt-retorno:

               /* O campo DEC-1 armazena o saldo alocado, o saldo que j  est  sendo utilizado em outra NF */    
               assign de-qtd-saldo = saldo-terc.quantidade - saldo-terc.dec-1.
        
               if  de-qtd-saldo <= 0 then 
                   next.
        
               assign de-qtd-saldo = if  de-qtd-saldo > tt-item.quantidade 
                                     then tt-item.quantidade
                                     else de-qtd-saldo.

              if  AVAIL item
              AND not item.fraciona 
              and trunc(de-qtd-saldo, 0) <> de-qtd-saldo then
                  ASSIGN de-qtd-saldo = trunc(de-qtd-saldo, 0).
        
                for first componente
                    where componente.serie-docto  = saldo-terc.serie-docto
                    and   componente.nro-docto    = saldo-terc.nro-docto
                    and   componente.cod-emitente = saldo-terc.cod-emitente
                    and   componente.nat-operacao = saldo-terc.nat-operacao
                    and   componente.it-codigo    = saldo-terc.it-codigo
                    and   componente.cod-refer    = saldo-terc.cod-refer
                    and   componente.sequencia    = saldo-terc.sequencia no-lock:
                end.
        
                /* Cria informa‡äesa na TT-ITEM-TERC de acordo com COMPONENTE */
                run geraItensPartindoDoComponente (input  rowid(componente),
                                                   input  0,
                                                   input  p-c-nat-operacao,
                                                   input  de-qtd-saldo,
                                                   input  c-tipo-nota,
                                                   input  p-l-recebimento,
                                                   input  p-da-dt-trans,
                                                   input  i-sequencia,
                                                   output l-proc-ok-aux).
               {dibo/bodi317.i3 l-proc-ok-aux}
        
                assign tt-item.quantidade = tt-item.quantidade - de-qtd-saldo
                       i-sequencia        = i-sequencia        + p-i-inc-seq.
                       
                if  tt-item.quantidade <= 0 then 
                    leave.
            end.
            IF  tt-item.quantidade > 0 THEN
                IF  NOT CAN-FIND(FIRST tt-item-erro
                                 WHERE tt-item-erro.it-codigo = tt-item.it-codigo) THEN DO:
                    CREATE tt-item-erro.
                    ASSIGN tt-item-erro.it-codigo = tt-item.it-codigo.
                END.
        END.

        if  l-remessa then do:
            if  p-l-recebimento then do: /* Executado pelo Recebimento */
                for first item-fornec
                    fields (item-fornec.unid-med-for)
                    where item-fornec.cod-emitente = p-i-cod-emitente
                    and item-fornec.it-codigo      = item.it-codigo no-lock:
                end.
                
                for first classif-fisc
                    fields (classif-fisc.aliquota-ipi)
                    where classif-fisc.class-fiscal = item.class-fiscal no-lock:
                end.
                
                /* Nao Atualiza Item Controlado por Referencia */
                if  item.tipo-con-est = 4 then
                    next.
                
                create tt-item-terc.
                assign tt-item-terc.nat-operacao = p-c-nat-operacao
                       tt-item-terc.sequencia    = i-sequencia 
                       tt-item-terc.it-codigo    = tt-item.it-codigo
                       tt-item-terc.quantidade   = tt-item.quantidade
                       tt-item-terc.vl-merc-ori  = round(p-vl-item,2) /* Para o Recebimento ‚ valor mercadoria */
                       tt-item-terc.vl-merc-liq  = round(p-vl-item,2) /* Para o Recebimento ‚ valor mercadoria */
                       tt-item-terc.vl-preuni    = if tt-item-terc.quantidade > 0 
                                                   then tt-item-terc.vl-merc-ori / tt-item-terc.quantidade
                                                   else 0
                       tt-item-terc.vl-preori    = tt-item-terc.vl-preuni 
                       tt-item-terc.class-fiscal = item.class-fiscal
                       tt-item-terc.baixa-ce     = if  avail natur-oper 
                                                   and natur-oper.tipo = 2
                                                   and natur-oper.tp-oper-terc = 4 
                                                   then no
                                                   else yes
                       tt-item-terc.un           = if  avail item-fornec 
                                                   then item-fornec.unid-med-for    
                                                   else item.un
                       tt-item-terc.aliquota-ipi = if  param-re.orig-aliq-ip = 1
                                                   and avail classif-fisc
                                                   then classif-fisc.aliquota-ipi
                                                   else item.aliquota-ipi.

                &if "{&bf_dis_versao_ems}" >= "2.062" &then
                    IF  valid-handle(h-api024) THEN
                        run RetornaUnidadeNegocioExternaliz in h-api024 (input p-c-cod-estabel,
                                                                         input tt-item-terc.it-codigo,
                                                                         input "", /*dep¢sito nÆo deve ser informado*/
                                                                         output tt-item-terc.cod-unid-negoc).
                &endif
                
                for first narrativa 
                    fields (narrativa.descricao)
                    where narrativa.it-codigo = item.it-codigo no-lock:
                    assign tt-item-terc.narrativa = narrativa.descricao.
                end.
            end.
            else do: /* Executado pelo Faturamento */
                create tt-item-terc.
                assign tt-item-terc.nat-operacao = p-c-nat-operacao
                       tt-item-terc.sequencia    = i-sequencia 
                       tt-item-terc.it-codigo    = tt-item.it-codigo
                       tt-item-terc.cod-refer    = tt-item.cod-refer
                       tt-item-terc.quantidade   = tt-item.quantidade
                       tt-item-terc.nr-ord-prod  = tt-item.nr-ord-prod
                       tt-item-terc.vl-preori    = p-vl-item  /* Para o Faturamento ‚ pre‡o original */
                       tt-item-terc.vl-preuni    = p-vl-item  /* Para o Faturamento ‚ pre‡o original */
                       tt-item-terc.vl-merc-liq  = round(tt-item-terc.vl-preuni * tt-item-terc.quantidade,2)
                       tt-item-terc.vl-merc-ori  = round(tt-item-terc.vl-merc-liq,2)
                       tt-item-terc.un           = item.un
                       tt-item-terc.baixa-ce     = if  avail natur-oper 
                                                   and natur-oper.tp-oper-terc = 4 
                                                   then no
                                                   else (    item.baixa-estoq
                                                         and natur-oper.baixa-estoq).

                &if "{&bf_dis_versao_ems}" >= "2.062" &then
                    IF  valid-handle(h-api024) THEN
                        run RetornaUnidadeNegocioExternaliz in h-api024 (input p-c-cod-estabel,
                                                                         input tt-item-terc.it-codigo,
                                                                         input "", /*dep¢sito nÆo deve ser informado*/
                                                                         output tt-item-terc.cod-unid-negoc).
                &endif
                       
            end.

            for first item-estab
                fields (item-estab.val-unit-mat-m[1]
                        item-estab.val-unit-ggf-m[1]
                        item-estab.val-unit-mob-m[1]
                        item-estab.val-unit-mat-o[1]
                        item-estab.val-unit-ggf-o[1]
                        item-estab.val-unit-mob-o[1]
                        item-estab.val-unit-mat-p[1]
                        item-estab.val-unit-ggf-p[1]
                        item-estab.val-unit-mob-p[1])
                where item-estab.it-codigo   = tt-item.it-codigo 
                and   item-estab.cod-estabel = p-c-cod-estabel no-lock:
            end.
            
            /* ConversÆo da Unidade de Medida - Recebimento */
            {cdp/cd9950.i item.un tt-item-terc.un p-i-cod-emitente}
            
            if  de-indice = 0 
            or  de-indice = ? then 
                assign de-indice = 1.                      

            /* Caso nÆo tenha sido informado valor para o item, o valor ser  calculado */
            if  p-vl-item = 0 then do:
                if  avail item-estab then do:
                    &if  defined(bf_mat_custeio_item) &then
                        if  avail estab-mat then
                        case estab-mat.custo-contab: 
                             when 1 then assign tt-item-terc.vl-preuni = item-estab.val-unit-mat-m[1] +
                                                                         item-estab.val-unit-ggf-m[1] +
                                                                         item-estab.val-unit-mob-m[1].
                             when 2 then assign tt-item-terc.vl-preuni = item-estab.val-unit-mat-o[1] +
                                                                         item-estab.val-unit-ggf-o[1] +
                                                                         item-estab.val-unit-mob-o[1].                    
                        end case. 
                    &else
                        if  avail estabelec then
                        case estabelec.custo-contab: 
                             when 1 then assign tt-item-terc.vl-preuni = item-estab.val-unit-mat-m[1] +
                                                                         item-estab.val-unit-ggf-m[1] +
                                                                         item-estab.val-unit-mob-m[1].
                             when 2 then assign tt-item-terc.vl-preuni = item-estab.val-unit-mat-o[1] +
                                                                         item-estab.val-unit-ggf-o[1] +
                                                                         item-estab.val-unit-mob-o[1].
                             when 3 then assign tt-item-terc.vl-preuni = item-estab.val-unit-mat-p[1] +
                                                                         item-estab.val-unit-ggf-p[1] +
                                                                         item-estab.val-unit-mob-p[1].
                        end case.
                    &endif
                end.
                else
                    assign tt-item-terc.vl-preuni = item.preco-ul-ent.

                assign tt-item-terc.vl-preori     = tt-item-terc.vl-preuni
                       tt-item-terc.vl-merc-liq   = round(tt-item-terc.vl-preuni * tt-item-terc.quantidade,2)
                       tt-item-terc.vl-merc-ori   = round(tt-item-terc.vl-merc-liq,2).
            end.

            assign i-sequencia               = i-sequencia + p-i-inc-seq
                   tt-item-terc.qt-do-forn-cli = 
                       if  not avail natur-oper
                       or  natur-oper.tipo = 1 
                       then tt-item-terc.quantidade * de-indice
                       else tt-item-terc.quantidade * (item.ft-conversao / exp(10,item.dec-ftcon)).

            if  p-i-ord-prod <> 0 then
                assign tt-item-terc.ct-codigo = ord-prod.ct-codigo
                       tt-item-terc.sc-codigo = ord-prod.sc-codigo.
            else
                if  tt-item-terc.baixa-ce
                and (   item.tipo-contr = 1       /* Item F¡sico   */ 
                     or item.tipo-contr = 4) then /* Debito Direto */
                    assign tt-item-terc.ct-codigo = item.ct-codigo
                           tt-item-terc.sc-codigo = item.sc-codigo.
                     
            assign de-qtd-saldo = tt-item.quantidade.
        
            if  tt-item-terc.baixa-ce then do:
                for first reservas
                    where rowid(reservas) = tt-item.rw-reserva no-lock:

                    assign tt-item-terc.item-pai    = reservas.item-pai
                           tt-item-terc.cod-roteiro = reservas.cod-roteiro
                           tt-item-terc.op-codigo   = reservas.op-codigo.
            
                    if  reservas.quant-aloc > 0 then 
                        for each aloca-reserva 
                            fields (aloca-reserva.quant-aloc
                                    aloca-reserva.cod-depos
                                    aloca-reserva.cod-refer
                                    aloca-reserva.cod-localiz
                                    aloca-reserva.lote-serie)
                            where aloca-reserva.nr-ord-produ = reservas.nr-ord-produ
                            and   aloca-reserva.item-pai    = reservas.item-pai
                            and   aloca-reserva.cod-roteiro = reservas.cod-roteiro
                            and   aloca-reserva.op-codigo   = reservas.op-codigo
                            and   aloca-reserva.cod-estabel = p-c-cod-estabel
                            and   aloca-reserva.it-codigo   = reservas.it-codigo
                            AND   aloca-reserva.cod-refer   = reservas.cod-refer no-lock:
            
                            assign de-disponivel = aloca-reserva.quant-aloc. 
            
                            if  de-disponivel >= de-qtd-saldo then 
                                assign de-disponivel = de-qtd-saldo.
            
                            if  not item.fraciona 
                            and trunc(de-disponivel, 0) <> de-disponivel then
                                assign de-disponivel = trunc(de-disponivel,0) + 1.
                        
                            create tt-baixa-estoq-item-terc.
                            assign de-qtd-saldo                          = de-qtd-saldo - de-disponivel
                                   tt-baixa-estoq-item-terc.sequencia    = tt-item-terc.sequencia
                                   tt-baixa-estoq-item-terc.it-codigo    = tt-item-terc.it-codigo
                                   tt-baixa-estoq-item-terc.cod-depos    = aloca-reserva.cod-depos
                                   tt-baixa-estoq-item-terc.cod-localiz  = aloca-reserva.cod-localiz
                                   tt-baixa-estoq-item-terc.lote         = aloca-reserva.lote-serie
                                   tt-baixa-estoq-item-terc.dt-vali-lote = ?
                                   tt-baixa-estoq-item-terc.quantidade   = de-disponivel
                                   tt-baixa-estoq-item-terc.char-1       = aloca-reserva.cod-refer.

                             if  de-qtd-saldo <= 0 then 
                                 leave.
                        end.
                end.
            
                if  de-qtd-saldo > 0 then
                    for each saldo-estoq 
                        where saldo-estoq.cod-estabel = p-c-cod-estabel
                        and   saldo-estoq.it-codigo = tt-item.it-codigo
                        AND   saldo-estoq.cod-refer = tt-item.cod-refer no-lock,
                        each deposito 
                        where deposito.cod-depos = saldo-estoq.cod-depos
                        and   not deposito.ind-dep-cq
                        and   not deposito.ind-dep-rej no-lock:
            
                        assign de-disponivel = saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-prod - 
                                               saldo-estoq.qt-alocada  - saldo-estoq.qt-aloc-ped.
            
                        
                        /*VERIFICA SE O SALDO DISPONÖVEL EM ESTOQUE Jµ FOI USADO POR ALGUM ITEM DA NOTA QUE ESTµ SENDO GERADA NESTA SEQUÒNCIA* (seq-wt-docto)*/
                        FOR each wt-fat-ser-lote
                             WHERE wt-fat-ser-lote.seq-wt-docto = i-seq-wt-docto     
                             AND   wt-fat-ser-lote.it-codigo    = tt-item-terc.it-codigo
                             AND   wt-fat-ser-lote.cod-depos    = saldo-estoq.cod-depos
                             AND   wt-fat-ser-lote.cod-localiz  = saldo-estoq.cod-localiz
                             AND   wt-fat-ser-lote.lote         = saldo-estoq.lote 
                             AND   wt-fat-ser-lote.cod-refer    = tt-item-terc.cod-refer NO-LOCK:
                             ASSIGN de-disponivel = de-disponivel - wt-fat-ser-lote.quantidade[1] .
                        END.
                        
                        if  de-disponivel <= 0 then 
                            next.
            
                        if  de-disponivel >= de-qtd-saldo then 
                            assign de-disponivel = de-qtd-saldo.
            
                        if  not item.fraciona 
                        and trunc(de-disponivel, 0) <> de-disponivel then
                            assign de-disponivel = trunc(de-disponivel,0) + 1.
                    
                        find first tt-baixa-estoq-item-terc
                             where tt-baixa-estoq-item-terc.sequencia    = tt-item-terc.sequencia
                             and   tt-baixa-estoq-item-terc.it-codigo    = tt-item-terc.it-codigo
                             AND   tt-baixa-estoq-item-terc.char-1       = tt-item-terc.cod-refer
                             and   tt-baixa-estoq-item-terc.cod-depos    = saldo-estoq.cod-depos
                             and   tt-baixa-estoq-item-terc.cod-localiz  = saldo-estoq.cod-localiz
                             and   tt-baixa-estoq-item-terc.lote         = saldo-estoq.lote no-error.

                        if  not avail tt-baixa-estoq-item-terc  then do:
                            create tt-baixa-estoq-item-terc.
                            assign tt-baixa-estoq-item-terc.sequencia    = tt-item-terc.sequencia
                                   tt-baixa-estoq-item-terc.it-codigo    = tt-item-terc.it-codigo
                                   tt-baixa-estoq-item-terc.char-1       = tt-item-terc.cod-refer
                                   tt-baixa-estoq-item-terc.cod-depos    = saldo-estoq.cod-depos
                                   tt-baixa-estoq-item-terc.cod-localiz  = saldo-estoq.cod-localiz
                                   tt-baixa-estoq-item-terc.lote         = saldo-estoq.lote.
                        end.
                                   
                        assign de-qtd-saldo                          = de-qtd-saldo - de-disponivel
                               tt-baixa-estoq-item-terc.dt-vali-lote = saldo-estoq.dt-vali-lote
                               tt-baixa-estoq-item-terc.quantidade   = tt-baixa-estoq-item-terc.quantidade + 
                                                                       de-disponivel.
                        if  de-qtd-saldo <= 0 then 
                            leave.
                    end.

                if  de-qtd-saldo > 0 then do:
                    assign de-disponivel = de-qtd-saldo.

                    if  not item.fraciona 
                    and trunc(de-disponivel, 0) <> de-disponivel then
                        assign de-disponivel = trunc(de-disponivel,0) + 1.
                
                    find first tt-baixa-estoq-item-terc
                         where tt-baixa-estoq-item-terc.sequencia    = tt-item-terc.sequencia
                         and   tt-baixa-estoq-item-terc.it-codigo    = tt-item-terc.it-codigo
                         AND   tt-baixa-estoq-item-terc.char-1       = tt-item-terc.cod-refer
                         and   tt-baixa-estoq-item-terc.cod-depos    = item.deposito-pad
                         and   tt-baixa-estoq-item-terc.cod-localiz  = item.cod-localiz
                         and   tt-baixa-estoq-item-terc.lote         = "":U no-error.

                    if  not avail tt-baixa-estoq-item-terc  then do:
                        create tt-baixa-estoq-item-terc.
                        assign tt-baixa-estoq-item-terc.sequencia    = tt-item-terc.sequencia
                               tt-baixa-estoq-item-terc.it-codigo    = tt-item-terc.it-codigo
                               tt-baixa-estoq-item-terc.char-1       = tt-item-terc.cod-refer
                               tt-baixa-estoq-item-terc.cod-depos    = item.deposito-pad
                               tt-baixa-estoq-item-terc.cod-localiz  = item.cod-localiz
                               tt-baixa-estoq-item-terc.lote         = "":U.
                    end.                               

                    assign de-qtd-saldo                          = de-qtd-saldo - de-disponivel
                           tt-baixa-estoq-item-terc.dt-vali-lote = ?
                           tt-baixa-estoq-item-terc.quantidade   = tt-baixa-estoq-item-terc.quantidade + 
                                                                   de-disponivel.
                end.                               
            end.
        end.
    end.

    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */

    &if "{&bf_dis_versao_ems}" >= "2.062" &then
        IF  valid-handle(h-api024) then
            RUN pi-finalizar IN h-api024.
    &endif

END PROCEDURE.    



/*-------------------------------------------------------------------------------------------------------

 Procedimento: determinaTipoSaldoTer:

     Objetivo: Gera‡Æo de itens para a nota a partir da estrutura.
          
 Parƒmetros de Entrada/Sa¡da:
   Entrada: p-c-nat-operacao....: Natureza de opera‡Æo;
   Sa¡da..: p-i-tipo-sal-terc...: Retorna o tipo de opera‡äes com terceiros;
            p-l-procedimento-ok.: Retorna que o procedimento ocorreu por completo;

 Registros que devem estar dispon¡veis antes da execu‡Æo deste procedimento: 
   <Nenhum>
         
 BOS Necess rios para executar esse m‚todo:
   <Nenhum>

--------------------------------------------------------------------------------------------------------*/

PROCEDURE determinaTipoSaldoTer:
    /* Defini‡Æo dos parƒmetros de Entrada/Sa¡da */
    def input  param p-c-nat-operacao    like natur-oper.nat-operacao no-undo.
    def output param p-i-tipo-sal-terc   as int                       no-undo. 
    def output param p-l-procedimento-ok as log                       no-undo.

    assign c-ultimo-metodo-exec = replace(program-name(1)," ":U, "~~":U).

    /*----------------------------------------------------+
     | Valores poss¡veis do campo NATUR-OPER.TP-OPER-TERC |
     | 1 - Remessa Beneficiamento                         |
     | 2 - Retorno Beneficiamento                         |
     | 3 - Remessa Consigna‡Æo Mercantil                  |
     | 4 - Faturamento Consigna‡Æo Mercantil              |
     | 5 - Devolu‡Æo Consigna‡Æo Mercantil                |
     | 6 - Reajuste Pre‡o Consigna‡Æo                     |
     | 7 - Drawback                                       |
     | 8 - Remessa Dep¢sito Fechado                       |
     | 9 - Retorno Dep¢sito Fechado                       |
     | 10 - Remessa Armaz‚m Geral                         |
     | 11 - Retorno Armaz‚m Geral                         |
     +----------------------------------------------------*/

    if  not avail natur-oper
    or  natur-oper.nat-operacao <> p-c-nat-operacao then 
        for first natur-oper
            fields (natur-oper.nat-operacao
                    natur-oper.terceiros
                    natur-oper.tp-oper-terc
                    natur-oper.tipo
                    natur-oper.baixa-estoq
                    natur-oper.transf)
            where natur-oper.nat-operacao = p-c-nat-operacao no-lock:
        end.
     
    /*-----------------+
     | natur-oper.tipo |
     | 1 - ENTRADA     |
     | 2 - SAIDA       |
     | 3 - SERVICO     |
     +-----------------*/

    CASE natur-oper.tp-oper-terc:
         WHEN 1  THEN ASSIGN p-i-tipo-sal-terc = IF natur-oper.tipo = 1 THEN 2  ELSE 1.       
         WHEN 2  THEN ASSIGN p-i-tipo-sal-terc = IF natur-oper.tipo = 1 THEN 1  ELSE 2.
         WHEN 3  THEN ASSIGN p-i-tipo-sal-terc = IF natur-oper.tipo = 1 THEN 5  ELSE 4.
         WHEN 4  THEN ASSIGN p-i-tipo-sal-terc = IF natur-oper.tipo = 1 THEN 5  ELSE 4.
         WHEN 5  THEN ASSIGN p-i-tipo-sal-terc = IF natur-oper.tipo = 1 THEN 4  ELSE 5.
         WHEN 6  THEN ASSIGN p-i-tipo-sal-terc = IF natur-oper.tipo = 1 THEN 5  ELSE 4.
         WHEN 8  THEN ASSIGN p-i-tipo-sal-terc = IF natur-oper.tipo = 1 THEN 9  ELSE 8.
         WHEN 9  THEN ASSIGN p-i-tipo-sal-terc = IF natur-oper.tipo = 1 THEN 8  ELSE 9.
         WHEN 10 THEN ASSIGN p-i-tipo-sal-terc = IF natur-oper.tipo = 1 THEN 11 ELSE 10.
         WHEN 11 THEN ASSIGN p-i-tipo-sal-terc = IF natur-oper.tipo = 1 THEN 10 ELSE 11.
    END CASE.

    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
END PROCEDURE.    


/*-------------------------------------------------------------------------------------------------------

 Procedimento: leaveOrdemProducao:

     Objetivo: tratamento do leave do campo ordem de produ‡Æo do programa ft4007.
          
 Parƒmetros de Entrada/Sa¡da:
   Entrada: p-i-nr-ord-prod-estrut.: Numero da Ordem de Produ‡Æo;
   Sa¡da..: p-de-quantidade........: Quantidade;
            p-c-item-pai...........: codigo do item pai;
            p-l-procedimento-ok....: Retorna que achou a ordem.

 Registros que devem estar dispon¡veis antes da execu‡Æo deste procedimento: 
   <Nenhum>
         
 BOS Necess rios para executar esse m‚todo:
   <Nenhum>

--------------------------------------------------------------------------------------------------------*/

PROCEDURE leaveOrdemProducao:
    def input  param p-i-nr-ord-prod-estrut like ord-prod.nr-ord-produ no-undo.
    def output param p-de-quantidade        like ord-prod.qt-ordem     no-undo.
    def output param p-c-item-pai           like item.it-codigo        no-undo.
    def output param p-l-procedimento-ok    as   log                   no-undo.

    find ord-prod where 
         ord-prod.nr-ord-produ = p-i-nr-ord-prod-estrut
         no-lock no-error.
    if  avail ord-prod then
        assign p-de-quantidade = ord-prod.qt-ordem - ord-prod.qt-produzida
               p-c-item-pai    = ord-prod.it-codigo
               p-l-procedimento-ok = yes.
    else 
        assign p-l-procedimento-ok = no.

END PROCEDURE.


/*-------------------------------------------------------------------------------------------------------

 Procedimento: buscaTempTableItem:

     Objetivo: Retorna os registros da tabelas tempor ria tt-item.
          
 Parƒmetros de Entrada/Sa¡da:
   Entrada: <Nenhum>
   Sa¡da..: tabela tt-item............: Dados de itens;
            
 Registros que devem estar dispon¡veis antes da execu‡Æo deste procedimento: 
   <Nenhum>
         
 BOS Necess rios para executar esse m‚todo:
   <Nenhum>

--------------------------------------------------------------------------------------------------------*/

PROCEDURE buscaTempTableItem:
    def OUTPUT param table for tt-item.
    
END PROCEDURE.


/*-------------------------------------------------------------------------------------------------------

 Procedimento: buscaTempTablesTerceiros:

     Objetivo: Retorna os registros das tabelas tempor rias tt-item-terc e tt-baixa-estoq-item-terc.
          
 Parƒmetros de Entrada/Sa¡da:
   Entrada: <Nenhum>
   Sa¡da..: tabela tt-item-terc............: Dados de terceiros;
            tabela tt-baixa-estoq-item-terc: Dados da baixa do estoque relacionado a tabela tt-item-terc;

 Registros que devem estar dispon¡veis antes da execu‡Æo deste procedimento: 
   <Nenhum>
         
 BOS Necess rios para executar esse m‚todo:
   <Nenhum>

--------------------------------------------------------------------------------------------------------*/

PROCEDURE buscaTempTablesTerceiros:
    def output param table for tt-item-terc.
    def output param table for tt-baixa-estoq-item-terc.

END PROCEDURE.



/*-------------------------------------------------------------------------------------------------------

 Procedimento: eliminaRegistrosTempTablesTerceiros:

     Objetivo: Elimina os registros das tabelas tempor rias tt-item-terc e tt-baixa-estoq-item-terc.
          
 Parƒmetros de Entrada/Sa¡da:
   Entrada: <Nenhum>
   Sa¡da..: <Nenhum>

 Registros que devem estar dispon¡veis antes da execu‡Æo deste procedimento: 
   <Nenhum>
         
 BOS Necess rios para executar esse m‚todo:
   <Nenhum>

--------------------------------------------------------------------------------------------------------*/

PROCEDURE eliminaRegistrosTempTablesTerceiros:
    for each tt-item:
        delete tt-item.
    end.

    for each tt-item-terc:
        delete tt-item-terc.
    end.

    for each tt-baixa-estoq-item-terc:
        delete tt-baixa-estoq-item-terc.
    end.
END PROCEDURE.

/*-------------------------------------------------------------------------------------------------------

 Procedimento: pi-gboin404te:

     Objetivo: Chama a EPC desta BO, evento "create-tt-item-level-2".
           
--------------------------------------------------------------------------------------------------------*/

PROCEDURE pi-epc:

    DEF INPUT PARAM p-de-quantidade AS DEC  NO-UNDO.
    DEF INPUT PARAM p-c-es-codigo  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-da-dt-corte  AS DATE NO-UNDO.
    DEF INPUT PARAM p-c-tt-handle  AS CHAR NO-UNDO.

    /* Inicio chamada epc grendene */
    /*--------- INICIO EPC ---------*/
    for each tt-epc where tt-epc.cod-event = "create-tt-item-level-2":U:
        delete tt-epc.
    end.

    create tt-epc.
    assign tt-epc.cod-event     = "create-tt-item-level-2":U
           tt-epc.cod-parameter = "item-amount":U
           tt-epc.val-parameter = STRING(p-de-quantidade).

    create tt-epc.
    assign tt-epc.cod-event     = "create-tt-item-level-2":U
           tt-epc.cod-parameter = "es-codigo":U
           tt-epc.val-parameter = p-c-es-codigo.

    create tt-epc.
    assign tt-epc.cod-event     = "create-tt-item-level-2":U
           tt-epc.cod-parameter = "validity-date":U
           tt-epc.val-parameter = string(p-da-dt-corte).

    create tt-epc.
    assign tt-epc.cod-event     = "create-tt-item-level-2":U
           tt-epc.cod-parameter = "temp-table-handle":U
           tt-epc.val-parameter = p-c-tt-handle.


    {include/i-epc201.i create-tt-item-level-2}
    /*--------- FIM EPC ---------*/

END PROCEDURE.


PROCEDURE pi-envia-nf-venda:
    /*
    ** Procedure respons vel por receber a chave da nota fiscal que est  sendo criada 
    ** de forma autom tica para dep¢sito fechado
    */
    DEFINE INPUT PARAMETER prw-nota-fiscal      AS ROWID     NO-UNDO.
    DEFINE INPUT PARAMETER pl-nf-depos-fechado  AS LOGICAL   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-dep-ext       AS CHARACTER NO-UNDO.

    ASSIGN rw-nota-fiscal          = prw-nota-fiscal 
           l-nf-depos-fechado-auto = pl-nf-depos-fechado
           c-cod-dep-ext           = pc-cod-dep-ext.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-envia-rw-rat-componente:
    /*
    ** Procedure respons vel por receber o rowid da rat-componente da nota fiscal que est  sendo 
    ** criada de forma autom tica para dep¢sito fechado
    */

    DEFINE INPUT PARAMETER pr-rw-rat-componente AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR tt-it-terc-nf2-aux.
    DEFINE INPUT PARAMETER TABLE FOR tt-rat-saldo-terc-aux.
    DEFINE INPUT PARAMETER TABLE FOR tt-fat-ser-lote.

    ASSIGN rw-rat-componente = pr-rw-rat-componente.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-rateio-quantidade:
    /*
    ** Procedure respons vel por fazer o rateio da quantidades da rat-saldo-terc
    ** para realizar a aloca‡Æo na saldo-terc.dec-1
    */

    DEFINE VARIABLE de-qtd-aux-1         AS   DECIMAL                        NO-UNDO.
    DEFINE VARIABLE de-qtd-aux-2         AS   DECIMAL                        NO-UNDO.
    DEFINE VARIABLE de-qtd-saldo         LIKE saldo-terc.quantidade          NO-UNDO.
    DEFINE VARIABLE de-qtd-saldo-fatur   AS   DECIMAL                        NO-UNDO.

    ASSIGN de-qtd-saldo       = tt-item-terc.quantidade
           de-qtd-saldo-fatur = tt-item-terc.quantidade
           d-porcent          = (de-qtd-saldo-fatur * 100) / de-qtd-saldo-total.

    bloco:
    FOR EACH tt-rat-saldo-terc-aux 
       WHERE tt-rat-saldo-terc-aux.serie-docto  = componente.serie-docto 
         AND tt-rat-saldo-terc-aux.nro-docto    = componente.nro-docto 
         AND tt-rat-saldo-terc-aux.cod-emitente = componente.cod-emitente 
         AND tt-rat-saldo-terc-aux.nat-operacao = componente.nat-operacao
         AND tt-rat-saldo-terc-aux.sequencia    = componente.sequencia
         AND tt-rat-saldo-terc-aux.it-codigo    = componente.it-codigo NO-LOCK:

        FOR FIRST nota-fiscal
            WHERE ROWID(nota-fiscal) = rw-nota-fiscal NO-LOCK:

            IF NOT CAN-FIND(FIRST b-fat-ser-lote
                            WHERE b-fat-ser-lote.cod-estabel = nota-fiscal.cod-estabel
                              AND b-fat-ser-lote.serie       = nota-fiscal.serie
                              AND b-fat-ser-lote.nr-nota-fis = nota-fiscal.nr-nota-fis
                              AND b-fat-ser-lote.it-codigo   = tt-rat-saldo-terc-aux.it-codigo
                              AND b-fat-ser-lote.nr-serlote  = tt-rat-saldo-terc-aux.lote
                              AND b-fat-ser-lote.cod-depos   = c-cod-dep-ext) THEN NEXT bloco.

        END.

        FOR FIRST tt-baixa-estoq-item-terc-aux
            WHERE tt-baixa-estoq-item-terc-aux.rw-saldo-terc = tt-rat-saldo-terc-aux.rw-rat-saldo-terc NO-LOCK:
        END.                                             

        IF NOT AVAIL tt-baixa-estoq-item-terc-aux THEN DO:
            CREATE tt-baixa-estoq-item-terc-aux.
            ASSIGN tt-baixa-estoq-item-terc-aux.rw-saldo-terc = tt-rat-saldo-terc-aux.rw-rat-saldo-terc 
                   tt-baixa-estoq-item-terc-aux.sequencia     = tt-item-terc.sequencia
                   tt-baixa-estoq-item-terc-aux.it-codigo     = tt-rat-saldo-terc-aux.it-codigo
                   tt-baixa-estoq-item-terc-aux.cod-depos     = tt-rat-saldo-terc-aux.cod-depos
                   tt-baixa-estoq-item-terc-aux.cod-localiz   = tt-rat-saldo-terc-aux.cod-localiz
                   tt-baixa-estoq-item-terc-aux.lote          = tt-rat-saldo-terc-aux.lote
                   tt-baixa-estoq-item-terc-aux.dt-vali-lote  = tt-rat-saldo-terc-aux.dt-vali-lote
                   tt-baixa-estoq-item-terc-aux.char-1        = tt-rat-saldo-terc-aux.cod-refer
                   tt-baixa-estoq-item-terc-aux.serie-docto   = tt-rat-saldo-terc-aux.serie-docto 
                   tt-baixa-estoq-item-terc-aux.nro-docto     = tt-rat-saldo-terc-aux.nro-docto   
                   tt-baixa-estoq-item-terc-aux.cod-emitente  = tt-rat-saldo-terc-aux.cod-emitente
                   tt-baixa-estoq-item-terc-aux.nat-operacao  = tt-rat-saldo-terc-aux.nat-operacao.
        END.

        ASSIGN de-qtd-aux-1 = 0.
        IF CAN-FIND(FIRST rat-componente NO-LOCK
                    WHERE rat-componente.serie-comp     = tt-rat-saldo-terc-aux.serie-docto
                      AND rat-componente.nro-comp       = tt-rat-saldo-terc-aux.nro-docto
                      AND rat-componente.cod-emitente   = tt-rat-saldo-terc-aux.cod-emitente
                      AND rat-componente.nat-comp       = tt-rat-saldo-terc-aux.nat-operacao
                      AND rat-componente.it-codigo      = tt-rat-saldo-terc-aux.it-codigo
                      AND rat-componente.cod-refer      = tt-rat-saldo-terc-aux.cod-refer
                      AND rat-componente.seq-comp       = tt-rat-saldo-terc-aux.sequencia
                      AND rat-componente.lote           = tt-rat-saldo-terc-aux.lote 
                      AND rat-componente.componente     = 1) THEN
    
            FOR EACH rat-componente NO-LOCK
               WHERE rat-componente.serie-comp     = tt-rat-saldo-terc-aux.serie-docto  
                 AND rat-componente.nro-comp       = tt-rat-saldo-terc-aux.nro-docto    
                 AND rat-componente.cod-emitente   = tt-rat-saldo-terc-aux.cod-emitente 
                 AND rat-componente.nat-comp       = tt-rat-saldo-terc-aux.nat-operacao 
                 AND rat-componente.it-codigo      = tt-rat-saldo-terc-aux.it-codigo    
                 AND rat-componente.cod-refer      = tt-rat-saldo-terc-aux.cod-refer    
                 AND rat-componente.seq-comp       = tt-rat-saldo-terc-aux.sequencia    
                 AND rat-componente.lote           = tt-rat-saldo-terc-aux.lote         
                 AND rat-componente.componente     = 1:
                ASSIGN de-qtd-aux-1 = de-qtd-aux-1 + rat-componente.quantidade.
            END.
    
    
        ASSIGN de-qtd-aux-2 = 0.
        IF CAN-FIND(FIRST rat-componente NO-LOCK
                    WHERE rat-componente.serie-comp   = tt-rat-saldo-terc-aux.serie-docto
                      AND rat-componente.nro-comp     = tt-rat-saldo-terc-aux.nro-docto
                      AND rat-componente.nat-comp     = tt-rat-saldo-terc-aux.nat-operacao
                      AND rat-componente.cod-emitente = tt-rat-saldo-terc-aux.cod-emitente
                      AND rat-componente.it-codigo    = tt-rat-saldo-terc-aux.it-codigo
                      AND rat-componente.cod-refer    = tt-rat-saldo-terc-aux.cod-refer
                      AND rat-componente.seq-comp     = tt-rat-saldo-terc-aux.sequencia
                      AND rat-componente.lote         = tt-rat-saldo-terc-aux.lote
                      AND rat-componente.componente   = 2) THEN
            FOR EACH rat-componente NO-LOCK
               WHERE rat-componente.serie-comp   = tt-rat-saldo-terc-aux.serie-docto 
                 AND rat-componente.nro-comp     = tt-rat-saldo-terc-aux.nro-docto   
                 AND rat-componente.nat-comp     = tt-rat-saldo-terc-aux.nat-operacao
                 AND rat-componente.cod-emitente = tt-rat-saldo-terc-aux.cod-emitente
                 AND rat-componente.it-codigo    = tt-rat-saldo-terc-aux.it-codigo   
                 AND rat-componente.cod-refer    = tt-rat-saldo-terc-aux.cod-refer   
                 AND rat-componente.seq-comp     = tt-rat-saldo-terc-aux.sequencia   
                 AND rat-componente.lote         = tt-rat-saldo-terc-aux.lote        
                 AND rat-componente.componente   = 2:   
                ASSIGN de-qtd-aux-2 = de-qtd-aux-2 + rat-componente.quantidade.
            END.
    
        FOR FIRST rat-componente OF tt-rat-saldo-terc-aux NO-LOCK: END.

        /* SE FOR UM FATURAMENTO TOTAL, BUSCA O SALDO DO LOTE */
        IF de-qtd-saldo-fatur = de-qtd-saldo-total THEN DO:
            IF {cdp/cd0066.i2 saldo-terc.cod-estabel} 
            OR (natur-oper.tp-oper-terc = 2  AND natur-oper.baixa-estoq = YES) 
            OR (natur-oper.tp-oper-terc = 9  AND natur-oper.baixa-estoq = YES)
            OR (natur-oper.tp-oper-terc = 11 AND natur-oper.baixa-estoq = YES) THEN DO:
                /* QUANTIDADE ORIGINAL DA REMESSA RECEBIDA PELO RE1001 - TOTAL DAS DEVOLUCOES SIMBOLICAS OU DE MERCADORIAS */ 
                IF (rat-componente.quantidade - de-qtd-aux-2) = 0 THEN
                    NEXT.
                ELSE 
                    ASSIGN tt-baixa-estoq-item-terc-aux.quantidade = (rat-componente.quantidade - de-qtd-aux-2).
            END.
            ELSE DO:               
                /* QUANTIDADE ORIGINAL DA REMESSA RECEBIDA PELO RE1001 - TOTAL DOS FATURAMENTOS OU DEVOLUCOES DE MERCADORIAS */ 
                IF (rat-componente.quantidade - (de-qtd-aux-1 + de-qtd-aux-2)) = 0 THEN
                   NEXT.
                ELSE 
                   ASSIGN tt-baixa-estoq-item-terc-aux.quantidade = (rat-componente.quantidade - (de-qtd-aux-1 + de-qtd-aux-2)).                                   
            END.
        END.
        ELSE DO:
            IF {cdp/cd0066.i2 saldo-terc.cod-estabel} 
            OR (natur-oper.tp-oper-terc = 2  AND natur-oper.baixa-estoq = YES) 
            OR (natur-oper.tp-oper-terc = 9  AND natur-oper.baixa-estoq = YES) 
            OR (natur-oper.tp-oper-terc = 11 AND natur-oper.baixa-estoq = YES) THEN DO:
                /* NAO FORAM REALIZADAS DEVOLUCOES SIMBOLICAS OU DE MERCADORIA */
                IF de-qtd-aux-2 = 0 THEN DO:
                   ASSIGN tt-baixa-estoq-item-terc-aux.quantidade = ROUND(rat-componente.quantidade * (d-porcent / 100), IF item.fraciona THEN 4 ELSE 0).                                
                END.
                ELSE DO:	
                    /* FAZ A PROPORSAO SE BASEANDO PELA QUANTIDADE AINDA DISPONIVEL PARA DEVOLUCAO */
                    ASSIGN tt-baixa-estoq-item-terc-aux.quantidade = ROUND((rat-componente.quantidade - de-qtd-aux-2) * (d-porcent / 100), IF item.fraciona THEN 4 ELSE 0).                                
                END.
            END.
            ELSE DO:
                /* NAO FORAM REALIZADAS FATURAMENTOS DESSA REMESSA */
                IF de-qtd-aux-1 = 0 then do:
                   ASSIGN tt-baixa-estoq-item-terc-aux.quantidade = round(rat-componente.quantidade * (d-porcent / 100), IF item.fraciona THEN 4 ELSE 0).
                END.
                ELSE DO:	
                   /* FAZ A PROPOR€AO SE BASEANDO PELA QUANTIDADE AINDA DISPONIVEL PARA DEVOLUCAO */
                   ASSIGN tt-baixa-estoq-item-terc-aux.quantidade = round((rat-componente.quantidade - (de-qtd-aux-1 + de-qtd-aux-2)) * (d-porcent / 100), IF item.fraciona THEN 4 ELSE 0).
                END.
            END.                  
        END.
    
        /* SE NÃO EXISTE SALDO DISPONIVEL */
        IF tt-baixa-estoq-item-terc-aux.quantidade = 0 THEN
            DELETE tt-baixa-estoq-item-terc-aux.

    END.
    
    IF CAN-FIND(FIRST tt-baixa-estoq-item-terc-aux 
                WHERE tt-baixa-estoq-item-terc-aux.sequencia = tt-item-terc.sequencia) THEN DO:

        ASSIGN de-qt-total-fat = 0.

        /* SE A PROPOR€AO GEROU UMA DIFERENCA */					
        FOR EACH tt-baixa-estoq-item-terc-aux
           WHERE tt-baixa-estoq-item-terc-aux.sequencia = tt-item-terc.sequencia:
            ASSIGN de-qt-total-fat = de-qt-total-fat +  tt-baixa-estoq-item-terc-aux.quantidade.
        END.

        IF de-qt-total-fat <> tt-item-terc.quantidade THEN DO:
            IF de-qt-total-fat > tt-item-terc.quantidade THEN DO:
                FOR FIRST tt-baixa-estoq-item-terc-aux
                    WHERE tt-baixa-estoq-item-terc-aux.sequencia = tt-item-terc.sequencia
                      AND tt-baixa-estoq-item-terc-aux.quantidade > (de-qt-total-fat - tt-item-terc.quantidade): 
                    ASSIGN tt-baixa-estoq-item-terc-aux.quantidade = tt-baixa-estoq-item-terc-aux.quantidade - (de-qt-total-fat - tt-item-terc.quantidade).
                END.
            END.
            ELSE DO:
                FOR FIRST tt-baixa-estoq-item-terc-aux
                    WHERE tt-baixa-estoq-item-terc-aux.sequencia = tt-item-terc.sequencia:
                    ASSIGN tt-baixa-estoq-item-terc-aux.quantidade = tt-baixa-estoq-item-terc-aux.quantidade + (tt-item-terc.quantidade - de-qt-total-fat).
                END.
            END.
            ASSIGN de-qtd-saldo = 0.				
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


/*  BOIN404TE.P  */


