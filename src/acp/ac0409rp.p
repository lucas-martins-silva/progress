/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0409RP 2.00.00.015 } /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0409rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac0409RP.P : ImpressÆo An lize do Pre‡o M‚dio de Vendas
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

def var c-selecao          as char format "x(11)"         no-undo.
def var c-impressao        as char format "x(12)"         no-undo.
def var c-destino          as char format "x(10)"         no-undo.
def var h-acomp            as handle                      no-undo.
def var c-estabel          as character format "x(15)"    no-undo.
def var c-desc-regiao      as character format "x(20)"    no-undo.
def var c-nome-abrev       as character format "x(13)"    no-undo.
def var c-nome-mic-reg     as character format "x(12)"    no-undo.
def var c-cliente          as character format "x(7)"     no-undo.
def var c-canal-venda      as character format "x(13)"    no-undo.
def var c-mic-reg          as character format "x(12)"    no-undo.
def var c-ab-reg           as character format "x(12)"    no-undo.
def var c-cod-rep          as character format "x(16)"    no-undo.
def var c-gr-cli           as character format "x(13)"    no-undo.
def var c-qt-real          as character format "x(12)"    no-undo.
def var c-tipo-valor       as character format "x(06)"    no-undo.
def var c-tipo-contr       as character format "x(10)"    no-undo.

def var c-vl-real          as character format "x(15)"    no-undo.
def var c-vl-medio         as character format "x(16)"    no-undo.
def var c-medio-real       as character format "x(15)"    no-undo.
def var c-prevista         as character format "x(09)"    no-undo.
def var c-produto          as character format "x(13)"    no-undo.
def var c-desc-produto     as character format "x(60)"    no-undo.
def var c-tot-prev         as character format "x(14)"    no-undo.
def var c-realizado        as character format "x(09)"    no-undo.
def var c-quantidade       as character format "x(20)"    no-undo.
def var c-parametros       as character format "x(12)"    no-undo.
def var de-tot-prev        like cotas.qt-prevista         no-undo.
def var de-tot-qt-prev     like cotas.qt-prevista         no-undo.
def var de-qt-tot-prev     like cotas.qt-prevista         no-undo.
def var de-tot-ger-prev    like cotas.vl-medio-prev       no-undo.

def var de-tot-med-prev    like cotas.vl-medio-prev       no-undo.
def var de-tot-qt-real     like cotas.qt-pedida           no-undo.
def var de-tot-vl-real     like cotas.vl-pedido           no-undo.
def var de-perc-med        as decimal format ">>9.99"     no-undo.
def var de-tot-perc-med    as decimal format ">>9.99"     no-undo.
def var de-med-prev        as decimal format ">>9.99"     no-undo.
def var de-tot-med         as decimal format ">>9.99"     no-undo.
def var de-perc-qt         as decimal format ">>9.99"     no-undo.
def var de-tot-perc-qt     as decimal format ">>9.99"     no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field cod-estab-ini        like cotas.cod-estabel
    field cod-estab-fim        like cotas.cod-estabel
    field cod-canal-venda-ini  like cotas.cod-canal-venda
    field cod-canal-venda-fim  like cotas.cod-canal-venda
    field cod-gr-cli-ini       like cotas.cod-gr-cli
    field cod-gr-cli-fim       like cotas.cod-gr-cli
    field nome-abrev-ini       like cotas.nome-abrev 
    field nome-abrev-fim       like cotas.nome-abrev
    field nome-ab-reg-ini      like cotas.nome-ab-reg
    field nome-ab-reg-fim      like cotas.nome-ab-reg
    field nome-mic-reg-ini     like cotas.nome-mic-reg
    field nome-mic-reg-fim     like cotas.nome-mic-reg
    field cod-rep-ini          like cotas.cod-rep
    field cod-rep-fim          like cotas.cod-rep
    field cd-produto-ini       like cotas.cd-produto
    field cd-produto-fim       like cotas.cd-produto
    field dt-inicial           like cotas.dt-inicial
    field dt-final             like cotas.dt-final
    field i-quantidade         as integer.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

form c-estabel      no-label at 01
     ":"                
     estabelec.nome no-label at 19      
     c-tipo-valor       at 72 
     c-tipo-contr       at 106 skip(2)
     with side-label width 132 stream-io page-top frame f-estab. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-estab:HANDLE).
  

form skip(1)
     c-canal-venda         no-label at 02
     ":":U
     canal-venda.descricao no-label format "x(25)" at 18
     c-gr-cli              no-label at 02
     ":":U
     gr-cli.descricao      no-label at 18
     c-nome-abrev          no-label at 55
     ":":U
     cotas.nome-abrev      no-label at 71
     c-ab-reg              no-label at 02
     " :":U      
     c-desc-regiao         no-label format "x(25)" at 18
     c-mic-reg             no-label at 55
     " :":U
     c-nome-mic-reg        no-label at 70 
     cotas.cod-rep                  at 03 space(17)
     " - " repres.nome-abrev     no-label at 49
     skip(1)     
     with width 132 no-box no-attr stream-io side-label frame f-cotas. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cotas:HANDLE).
  

form skip(01)
     c-selecao   no-label    skip(1)
     tt-param.cod-estab-ini              colon 40 space(12) "|< >|"
     tt-param.cod-estab-fim           no-label colon 73 skip
     tt-param.cod-canal-venda-ini        colon 40 space(14) "|< >|"
     tt-param.cod-canal-venda-fim     no-label colon 73 skip
     tt-param.cod-gr-cli-ini             colon 40 space(13) "|< >|"
     tt-param.cod-gr-cli-fim          no-label colon 73 skip
     tt-param.nome-abrev-ini             colon 40 space(5)  "|< >|"
     tt-param.nome-abrev-fim          no-label colon 73 skip
     tt-param.nome-ab-reg-ini            colon 40 space(05) "|< >|"
     tt-param.nome-ab-reg-fim         no-label colon 73 skip
     tt-param.nome-mic-reg-ini           colon 40 space(05) "|< >|"
     tt-param.nome-mic-reg-fim        no-label colon 73 skip
     tt-param.cod-rep-ini                colon 40 space(12) "|< >|"
     tt-param.cod-rep-fim             no-label colon 73 skip
     tt-param.cd-produto-ini             colon 40 space(1)  "|< >|"
     tt-param.cd-produto-fim          no-label colon 73 skip
     tt-param.dt-inicial                 colon 40 space(7)  "|< >|"
     tt-param.dt-final                no-label colon 73 skip(1)     
     c-parametros no-label   skip(1)
     c-quantidade            no-label colon 40 skip(1)
     c-impressao no-label    skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-parametros:HANDLE).


/* *********************** Defini‡Æo de literais  ***************************** */

{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-field.i mgdis cotas cod-estabel 1}
assign tt-param.cod-estab-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas cod-canal-venda 1}
assign tt-param.cod-canal-venda-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas cod-gr-cli 1}
assign tt-param.cod-gr-cli-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas nome-ab-reg 1}
assign tt-param.nome-ab-reg-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas nome-mic-reg 1}
assign tt-param.nome-mic-reg-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas cod-rep 1}
assign tt-param.cod-rep-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Produto/Item * R}
assign tt-param.cd-produto-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Per¡odo * L}
assign tt-param.dt-inicial:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i PAR¶METROS * R}
assign c-parametros = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Cliente * R}
assign c-cliente = trim(return-value).

{utp/ut-field.i mgdis cotas cod-estabel 1}
assign c-estabel = return-value.

{utp/ut-field.i mgdis cotas cod-canal-venda 1}
assign c-canal-venda = return-value.

{utp/ut-field.i mgdis cotas cod-gr-cli 1}
assign c-gr-cli = return-value.

{utp/ut-field.i mgdis cotas nome-abrev 1}
assign c-nome-abrev = return-value.

{utp/ut-field.i mgdis cotas nome-ab-reg 1}
assign c-ab-reg = return-value.

{utp/ut-field.i mgdis cotas nome-mic-reg 1}
assign c-mic-reg = return-value.

{utp/ut-field.i mgdis cotas cod-rep 1}
assign c-cod-rep = return-value.

{utp/ut-field.i mgdis cotas qt-prevista 1}
assign c-prevista = return-value.

{utp/ut-liter.i Produto/Item * R}
assign c-produto = return-value.

{utp/ut-liter.i  Valor_M‚dio_Prev * R}
assign c-vl-medio = return-value.

{utp/ut-liter.i  Total_Previsto * R}
assign c-tot-prev = return-value.

{utp/ut-liter.i  M‚dio_Realizado_Pedido * R}
assign c-medio-real = return-value.

{utp/ut-liter.i Valor_Analisado * L}
assign c-tipo-valor:label in frame f-estab = trim(return-value).

{utp/ut-liter.i Tipo_Cota * L}
assign c-tipo-contr:label in frame f-estab = trim(return-value).


/* ************************ Inicio do programa ****************************** */
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.
find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

{utp/ut-liter.i Controle_de_Cotas MAP C}
assign c-programa = 'ap0409'
       c-sistema  = return-value
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.
 
{utp/ut-liter.i An lise_do_Pre‡o_M‚dio_de_Venda MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.
     
run pi-inicializar in h-acomp (input "Aguarde...").
main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    /****************** Literais Diferenciadas conforme parƒmetros ******************/

    if tt-param.i-quantidade = 1 then do:
         {utp/ut-liter.i  Qt_Real_Ped * C}
         assign c-qt-real = return-value.

         {utp/ut-liter.i  Realizado_Pedido * C}
         assign c-quantidade = return-value.
         
    end.
    else do:
         {utp/ut-liter.i  Qt_Real_Fat * C}
         assign c-qt-real = return-value.

         {utp/ut-liter.i  Realizado_Faturado * C}
         assign c-quantidade = return-value.
    end.
    
    if tt-param.i-quantidade = 1 then do:
         {utp/ut-liter.i  Valor_Pedido * L}
         assign c-vl-real = return-value.
    end.
    else do:
         {utp/ut-liter.i  Valor_Faturado * R}
         assign c-vl-real = return-value.
    end.    
           
    for each cotas no-lock 
        where   cotas.cod-estabel     >= tt-param.cod-estab-ini
          and   cotas.cod-estabel     <= tt-param.cod-estab-fim
        and   ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
          and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim)
          or    cotas.cod-canal-venda  = ? )
        and   ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
          and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
          or    cotas.cod-gr-cli       = ? )
        and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
          and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
          or    cotas.nome-ab-reg      = ? ) 
        and   ((cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
          and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
          or    cotas.nome-mic-reg     = ? )
        and   ((cotas.cod-rep         >= tt-param.cod-rep-ini
          and   cotas.cod-rep         <= tt-param.cod-rep-fim)
          or    cotas.cod-rep          = ? )
        and     cotas.cd-produto      >= tt-param.cd-produto-ini
          and   cotas.cd-produto      <= tt-param.cd-produto-fim
        and     cotas.dt-inicial      >= tt-param.dt-inicial
          and   cotas.dt-inicial      <= tt-param.dt-final
        break by cotas.cod-estabel
              by cotas.cod-canal-venda
              by cotas.cod-gr-cli
              by cotas.nome-abrev
              by cotas.nome-ab-reg
              by cotas.nome-mic-reg
              by cotas.cod-rep:

        run pi-acompanhar in h-acomp (cotas.cod-rep). 
        
        if first-of(cotas.cod-estabel) then do:
           disp c-estabel with frame f-estab.
           find estabelec no-lock where estabelec.cod-estabel = cotas.cod-estabel no-error.
           if avail estabelec then do:
              disp estabelec.nome with frame f-estab.
              find par-cota no-lock where par-cota.cod-estabel = estabelec.cod-estabel no-error.
              assign c-tipo-valor = if avail par-cota then {diinc/i05di257.i 04 par-cota.tipo-valor} else ""
                     c-tipo-contr = if avail par-cota then {diinc/i04di257.i 04 par-cota.tipo-controle} else "".          
              disp c-tipo-valor
                   c-tipo-contr with frame f-estab. 
           end.   
        end.
              
        if first-of(cotas.cod-canal-venda) or first-of(cotas.cod-gr-cli)   or
           first-of(cotas.nome-abrev)      or first-of(cotas.nome-ab-reg)  or
           first-of(cotas.nome-mic-reg)    or first-of(cotas.cod-rep)      then do:
           
           if LINE-COUNTER >= 54 then page.
           disp c-canal-venda with frame f-cotas.
           
           find canal-venda no-lock where canal-venda.cod-canal-venda = cotas.cod-canal-venda no-error.
           if avail canal-venda then 
              disp canal-venda.descricao with frame f-cotas.         
           disp c-gr-cli with frame f-cotas.

           find gr-cli no-lock where gr-cli.cod-gr-cli = cotas.cod-gr-cli no-error.
           if avail gr-cli then 
              disp gr-cli.descricao with frame f-cotas.             
           disp c-ab-reg with frame f-cotas.

           disp c-nome-abrev 
                cotas.nome-abrev with frame f-cotas.             

           find regiao no-lock where regiao.nome-ab-reg = cotas.nome-ab-reg no-error.
           if avail regiao then 
              assign c-desc-regiao = regiao.nome-regiao.             
           disp c-desc-regiao 
                c-mic-reg with frame f-cotas.

           find micro-reg no-lock where micro-reg.nome-mic-reg = cotas.nome-mic-reg no-error.
           if avail micro-reg then
              assign c-nome-mic-reg = micro-reg.nome-mic-reg.
           disp c-nome-mic-reg cotas.cod-rep with frame f-cotas.
           
           find repres no-lock where repres.cod-rep = cotas.cod-rep no-error.
           if avail repres then disp repres.nome-abrev with frame f-cotas.     
           
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-vl AS CHARACTER FORMAT "X(6)" NO-UNDO.
           {utp/ut-liter.i "%_Vl" *}
           ASSIGN c-lbl-liter-vl = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-qt AS CHARACTER FORMAT "X(6)" NO-UNDO.
           {utp/ut-liter.i "%_Qt" *}
           ASSIGN c-lbl-liter-qt = TRIM(RETURN-VALUE).
           put c-prevista            at 09
               c-vl-medio            at 18
               c-tot-prev            at 37
               c-qt-real             at 57   
               c-medio-real          at 70
               c-vl-real             at 88
               c-lbl-liter-vl              at 114
               c-lbl-liter-qt              at 129
               "----------------"    at 01
               "----------------"    at 18
               "----------------"    at 35
               "----------------"    at 52
               "----------------"    at 69 
               "----------------"    at 86 
               "---------------"     at 103
               "--------------"      at 119.
           
        end.    
        
        if tt-param.i-quantidade = 1 then do:
            assign de-med-prev     =  (cotas.vl-pedido   / cotas.qt-pedida) 
                   de-qt-tot-prev  =  (cotas.qt-prevista * cotas.vl-medio-prev)
                   de-perc-med     =  (cotas.vl-pedido   / de-qt-tot-prev)    * 100
                   de-perc-qt      =  (cotas.qt-pedida   / cotas.qt-prevista) * 100.
        end.
        else do:
            assign de-med-prev     =  (cotas.vl-faturado   / cotas.qt-faturada) 
                   de-qt-tot-prev  =  (cotas.qt-prevista * cotas.vl-medio-prev)
                   de-perc-med     =  (cotas.vl-faturado   / de-qt-tot-prev)    * 100
                   de-perc-qt      =  (cotas.qt-faturada   / cotas.qt-prevista) * 100.
        end.

        if de-med-prev = ? then  assign de-med-prev = 0.
        if de-perc-med = ? then assign de-perc-med = 0.
        if de-perc-qt  = ? then assign de-perc-qt  = 0.         
        
        /***
         *Busca descri‡Æo do produto/item
         ***/
        &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
            find first produto-coml no-lock where
                       produto-coml.cod-produto-coml = cotas.cd-produto no-error.
            if avail produto-coml then 
               assign c-desc-produto = produto-coml.des-produto-coml. 
            if not avail produto-coml then do:
        &else
            find first produto no-lock where
                      produto.cd-produto = cotas.cd-produto no-error.
            if avail produto then 
               assign c-desc-produto = produto.descricao. 
            if not avail produto then do:
        &endif
               for first item fields(desc-item) no-lock where
                         item.it-codigo = cotas.cd-produto :
                   assign c-desc-produto = item.desc-item.
               end.
            end.   

                                                            
        if tt-param.i-quantidade = 1 then do                :
            put /*impressÆo do produto/item - descri‡Æo*/
                c-produto                                    at 01
                ":":U
                trim(cotas.cd-produto)                       at 16
                " - ":U
                c-desc-produto
                /*impressÆo dos valores*/
                cotas.qt-prevista   format ">>>>,>>>,>>>,>>9.99" at 05
                cotas.vl-medio-prev format ">>>>,>>>,>>9.99" at 19 
                de-qt-tot-prev      format ">>>>,>>>,>>9.99" at 36      /* Quantidade total do previsto */
                cotas.qt-pedida     format ">>>>,>>>,>>9.99" at 53       
                de-med-prev         format ">>>>,>>>,>>9.99" at 70      /* M‚dio realizado */
                cotas.vl-pedido     format ">>>>,>>>,>>9.99" at 87   
                de-perc-med         format ">>>>,>>>,>>9.99" at 103     /* Percentual do Valor m‚dio */
                de-perc-qt          format  ">>>,>>>,>>9.99" at 119.    /* Percentual da quantidade */ 
                                                                     
            assign de-tot-qt-prev  = de-tot-qt-prev  + cotas.qt-prevista
                   de-tot-med-prev = de-tot-med-prev + cotas.vl-medio-prev
                   de-tot-ger-prev = de-tot-ger-prev + de-qt-tot-prev
                   de-tot-qt-real  = de-tot-qt-real  + cotas.qt-pedida
                   de-tot-vl-real  = de-tot-vl-real  + cotas.vl-pedido.
        end.
        else do:
            put /*impressÆo do produto/item - descri‡Æo*/
                c-produto                                    at 01
                ":":U
                trim(cotas.cd-produto)                       at 16
                " - ":U
                c-desc-produto
                /*impressÆo dos valores*/
                cotas.qt-prevista   format ">>>>,>>>,>>>,>>9.99" at 05
                cotas.vl-medio-prev format ">>>>,>>>,>>9.99" at 19 
                de-qt-tot-prev      format ">>>>,>>>,>>9.99" at 36      /* Quantidade total do previsto */
                cotas.qt-faturada   format ">>>>,>>>,>>9.99" at 53       
                de-med-prev         format ">>>>,>>>,>>9.99" at 70      /* M‚dio realizado */
                cotas.vl-faturado   format ">>>>,>>>,>>9.99" at 87   
                de-perc-med         format ">>>>,>>>,>>9.99" at 103     /* Percentual do Valor m‚dio */
                de-perc-qt          format  ">>>,>>>,>>9.99" at 119.    /* Percentual da quantidade */ 

            assign de-tot-qt-prev  = de-tot-qt-prev  + cotas.qt-prevista
                   de-tot-med-prev = de-tot-med-prev + cotas.vl-medio-prev
                   de-tot-ger-prev = de-tot-ger-prev + de-qt-tot-prev
                   de-tot-qt-real  = de-tot-qt-real  + cotas.qt-faturada
                   de-tot-vl-real  = de-tot-vl-real  + cotas.vl-faturado.
        end.
               
        if last-of(cotas.cod-canal-venda) or last-of(cotas.cod-gr-cli)   or
           last-of(cotas.nome-abrev)      or last-of(cotas.nome-ab-reg)  or
           last-of(cotas.nome-mic-reg)    or last-of(cotas.cod-rep)      then do:

           assign de-tot-med      =  de-tot-med + de-med-prev                
                  de-tot-perc-med = (de-tot-vl-real / de-tot-ger-prev) * 100
                  de-tot-perc-qt  = (de-tot-qt-real / de-tot-qt-prev)  * 100.
                  
           if de-tot-perc-med = ? then assign de-tot-perc-med = 0.
           if de-tot-perc-qt  = ? then assign de-tot-perc-qt  = 0.

           put "----------------"    at 01 
               "----------------"    at 18 
               "----------------"    at 35 
               "----------------"    at 52 
               "----------------"    at 69 
               "----------------"    at 86 
               "---------------"     at 103
               "--------------"      at 119
               de-tot-qt-prev     format ">>>>,>>>,>>>,>>9.99" at 05   /* Total da quantidade prevista */
               de-tot-med-prev    format ">>>>,>>>,>>9.99" at 19   /* Total do valor m‚dio previsto */
               de-tot-ger-prev    format ">>>>,>>>,>>9.99" at 36   /* Total geral do previsto */
               de-tot-qt-real     format ">>>>,>>>,>>9.99" at 53   /* Total da quantidade realizada */
               de-tot-med         format ">>>>,>>>,>>9.99" at 70   /* Total do m‚dio realizado */ 
               de-tot-vl-real     format ">>>>,>>>,>>9.99" at 87   /* Total do valor realizado */
               de-tot-perc-med    format ">>>>,>>>,>>9.99" at 103  /* Total do percentual Valor m‚dio */
               de-tot-perc-qt     format  ">>>,>>>,>>9.99" at 119 skip(1). /* Total do percentual da quantidade */
           
           assign de-tot-prev     = 0
                  de-tot-qt-prev  = 0
                  de-tot-med-prev = 0
                  de-tot-qt-real  = 0 
                  de-tot-vl-real  = 0.
        end.
        
        if last-of(cotas.cod-estabel) then do:
           hide frame f-estab.
           page.
        end.
    end.    
end.

run pi-finalizar in h-acomp.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
hide frame f-estab.
display c-selecao 
        tt-param.cod-estab-ini   
        tt-param.cod-estab-fim   
        tt-param.cod-canal-venda-ini   
        tt-param.cod-canal-venda-fim   
        tt-param.cod-gr-cli-ini        
        tt-param.cod-gr-cli-fim        
        tt-param.nome-abrev-ini        
        tt-param.nome-abrev-fim        
        tt-param.nome-ab-reg-ini    
        tt-param.nome-ab-reg-fim    
        tt-param.nome-mic-reg-ini     
        tt-param.nome-mic-reg-fim    
        tt-param.cod-rep-ini      
        tt-param.cod-rep-fim      
        tt-param.cd-produto-ini   
        tt-param.cd-produto-fim  
        tt-param.dt-inicial
        tt-param.dt-final
        c-parametros
        c-quantidade
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.


{include/i-rpclo.i}

RETURN "OK".


/* Fim do Programa */


