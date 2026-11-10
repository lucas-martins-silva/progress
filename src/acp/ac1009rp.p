/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1009RP 2.00.00.016} /*** "010016" 22/05/2025 16:59:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC1009RP MAC}
&ENDIF



/*******************************************************************************
**
** Ac1009RP.P : C¢pia de Cotas e impressÆo dos parƒmetros
**
********************************************************************************/
{utp/ut-glob.i}
/* ********************  Defini‡Æo de Temp-Table ****************************** */


/* include pre-processador */
{cdp/cdcfgdis.i}

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field data-orig        like cotas.dt-inicial
    field data-dest        like cotas.dt-final
    field data-fim-dest    like cotas.dt-final
    field percentual       as decimal format "->>9,99"
    field elimina          as logical
    field estabel-ini      like cotas.cod-estabel
    field estabel-fim      like cotas.cod-estabel
    field l-base-cota      as log 
    field l-canal          as log
    field l-gr-cli         as log
    field l-cliente        as log
    field l-regiao         as log
    field l-mic-reg        as log
    field l-repres         as log
    field i-destino        as int 
    field i-origem         as int. 
        
/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

def var c-processa       as char format "x(20)"              no-undo.
def var c-selecao        as char format "x(11)"              no-undo.
def var c-parametro      as char format "x(14)"              no-undo.
def var c-impressao      as char format "x(12)"              no-undo.
def var c-destino        as char format "x(10)"              no-undo.
def var h-acomp          as handle                           no-undo.
def var de-perc          like tt-param.percentual  format 999.99 no-undo.
def var de-total-cota    as decimal                          no-undo.
def var l-copi-mesmo-reg as logical                          no-undo.
def var c-estab          as char                             no-undo.
def var c-item-prod      as char                             no-undo.
def var c-data-ini       as char                             no-undo.

/* ************************* Defini‡Æo de Buffers *************************** */

def buffer b-cotas for cotas.
def buffer b-base-cota for base-cota.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(01)
     c-selecao   no-label    skip(1)
     tt-param.estabel-ini    colon 40 space(14) "|< >|" 
     tt-param.estabel-fim  no-label colon 73 skip(1)
     c-parametro no-label    skip(1)
     tt-param.data-orig      colon 40 skip
     tt-param.data-dest      colon 40 skip
     tt-param.data-fim-dest  colon 40 skip
     tt-param.percentual     colon 40 skip
     tt-param.elimina        colon 40 skip(1)
     c-impressao no-label    skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.

RUN utp/ut-trfrrp.p (INPUT FRAME f-parametros:HANDLE).

/* *********************** Defini‡Æo de literais  ***************************** */

{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-liter.i PAR¶METROS * R}
assign c-parametro = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Processando * L}
assign c-processa = trim(return-value).

{utp/ut-liter.i "Data Inicial Origem" * L}
assign tt-param.data-orig:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i "Data Inicial Destino" * L}
assign tt-param.data-dest:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i "Data Final Destino" * L}
assign tt-param.data-fim-dest:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i "Percentual C¢pias Cotas" * L}
assign tt-param.percentual:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i "Elimina Registros Existentes" * L}
assign tt-param.elimina:label in frame f-parametros = trim(return-value).

/* ************************ Inicio do programa ****************************** */
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

{utp/ut-liter.i "Controle de Cotas" MAP C}
assign c-programa = 'ac1009'
       c-sistema  = return-value
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.
 
{utp/ut-liter.i "C¢pia de Cotas" MAP C}
assign c-titulo-relat = return-value.

/********************************************************************/
/***                     C¢pia de Cotas                           ***/
/********************************************************************/

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

assign de-perc = 0 .

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i "Aguarde ..." *}
run pi-inicializar in h-acomp (input return-value).

/* Elimina registros existentes */
if tt-param.elimina then do:
    for each base-cota fields(cod-estabel cd-produto dt-inicial)
                       exclusive-lock use-index periodo
        where base-cota.dt-inicial = tt-param.data-dest:
        
        for each cotas fields(cod-rep qt-pedida qt-faturada) use-index periodo exclusive-lock
            where cotas.cod-estabel = base-cota.cod-estabel
            and   cotas.cd-produto  = base-cota.cd-produto
            and   cotas.dt-inicial  = base-cota.dt-inicial:

            run pi-acompanhar in h-acomp (cotas.cod-rep).        

            delete cotas.
        end.    

        delete base-cota.
    end.
end.

assign de-perc  =  1 + (tt-param.percentual) / 100.


/* Faz apenas copia entre mesmos registros */
if tt-param.data-orig = tt-param.data-dest then
   assign l-copi-mesmo-reg = yes.

&IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PRE-PROCESSADOR */
    run pi-release203.   
&ELSE
    run pi-release202.
&ENDIF 


procedure pi-release202.

    for each cotas no-lock use-index periodo
        where cotas.dt-inicial = tt-param.data-orig
        break by cotas.cod-estabel
              by cotas.cd-produto
              by cotas.dt-inicial:
         
        /********* Ler parametro de Cotas ************/
        IF FIRST-OF(cotas.cod-estabel) THEN DO:
            IF NOT AVAIL para-ped THEN 
                FIND FIRST para-ped NO-LOCK NO-ERROR.
            IF SUBSTRING(para-ped.char-1,1,3)  = "yes" then
               FIND par-cota NO-LOCK 
                    WHERE par-cota.cod-estabel = para-ped.estab-padrao NO-ERROR.
            ELSE 
               FIND par-cota NO-LOCK 
                    WHERE par-cota.cod-estabel = cotas.cod-estabel NO-ERROR.  
        END.
        /*********************************************/ 

        run pi-acompanhar in h-acomp (cotas.cod-rep).        

        find first b-cotas exclusive-lock 
             where b-cotas.cod-estabel     = cotas.cod-estabel
             and   b-cotas.cod-canal-venda = cotas.cod-canal-venda
             and   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
             and   b-cotas.nome-abrev      = cotas.nome-abrev
             and   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
             and   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
             and   b-cotas.cod-rep         = cotas.cod-rep
             and   b-cotas.cd-produto      = cotas.cd-produto
             and   b-cotas.dt-inicial      = tt-param.data-dest no-error.

        if not avail b-cotas then do:
           create b-cotas.
           assign b-cotas.cod-estabel     = cotas.cod-estabel
                  b-cotas.cod-canal-venda = cotas.cod-canal-venda
                  b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                  b-cotas.nome-abrev      = cotas.nome-abrev
                  b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                  b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                  b-cotas.cod-rep         = cotas.cod-rep 
                  b-cotas.cd-produto      = cotas.cd-produto
                  b-cotas.dt-inicial      = tt-param.data-dest.
        end.
        
        assign b-cotas.dt-final      = tt-param.data-fim-dest
               b-cotas.qt-prevista   = cotas.qt-prevista * de-perc
               b-cotas.vl-previsto   = cotas.vl-previsto * de-perc
               b-cotas.qt-original   = cotas.qt-original * de-perc
               b-cotas.vl-original   = cotas.vl-original * de-perc
               b-cotas.qt-solicitado = cotas.qt-solicitado * de-perc
               b-cotas.vl-solicitado = cotas.vl-solicitado * de-perc
               b-cotas.vl-medio-prev = cotas.vl-medio-prev.
        
        if par-cota.tipo-controle = 2 then /*valor*/
           assign de-total-cota = de-total-cota + b-cotas.vl-previsto.       
        else /*pontos,quantidade*/
           assign de-total-cota = de-total-cota + b-cotas.qt-prevista.       
        
        if last-of(cotas.cod-estabel) or
           last-of(cotas.cd-produto)  or
           last-of(cotas.dt-inicial)  then do:
           
           find base-cota exclusive-lock use-index periodo
                where base-cota.cod-estabel = cotas.cod-estabel
                and   base-cota.cd-produto  = cotas.cd-produto
                and   base-cota.dt-inicial  = tt-param.data-dest no-error.
 
           if not avail base-cota then do:
              create base-cota.
              assign base-cota.cod-estabel = cotas.cod-estabel 
                     base-cota.cd-produto  = cotas.cd-produto
                     base-cota.dt-inicial  = tt-param.data-dest.
           end.
           assign base-cota.dt-final    = tt-param.data-fim-dest
                  base-cota.qt-prevista = de-total-cota
                  de-total-cota         = 0.
        end.          
    end.

end procedure.

procedure pi-release203.

&IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */

    if tt-param.l-base-cota and
       l-copi-mesmo-reg = no then do:       
       for each base-cota use-index periodo where
                base-cota.cod-estabel >= tt-param.estabel-ini and
                base-cota.cod-estabel <= tt-param.estabel-fim and
                base-cota.dt-inicial  = tt-param.data-orig no-lock :
          find first b-base-cota use-index periodo where
                     b-base-cota.cod-estabel = base-cota.cod-estabel and
                     b-base-cota.cd-produto  = base-cota.cd-produto and
                     b-base-cota.dt-inicial  = tt-param.data-dest exclusive-lock no-error.
          if not avail b-base-cota then do:
             create b-base-cota.
             assign b-base-cota.cod-estabel      = base-cota.cod-estabel 
                    b-base-cota.cd-produto       = base-cota.cd-produto
                    b-base-cota.dt-inicial       = tt-param.data-dest
                    b-base-cota.dt-final         = tt-param.data-fim-dest.
          end.
          assign b-base-cota.cd-produto-dest  = base-cota.cd-produto-dest
                 b-base-cota.log-consid-cotas = base-cota.log-consid-cotas 
                 b-base-cota.log-cota-limite  = base-cota.log-cota-limite
                 b-base-cota.nr-pontos        = base-cota.nr-pontos
                 b-base-cota.qt-prevista      = b-base-cota.qt-prevista + (base-cota.qt-prevista * de-perc) .
       end.
    end. 
 
    for each cotas no-lock use-index periodo
        where cotas.dt-inicial = tt-param.data-orig
        break by cotas.cod-estabel
              by cotas.cd-produto
              by cotas.dt-inicial:
                       
        /********* Ler parametro de Cotas ************/
        IF FIRST-OF(cotas.cod-estabel) THEN DO:
            IF NOT AVAIL para-ped THEN 
                FIND FIRST para-ped NO-LOCK NO-ERROR.
            IF SUBSTRING(para-ped.char-1,1,3)  = "yes" then
               FIND par-cota NO-LOCK 
                    WHERE par-cota.cod-estabel = para-ped.estab-padrao NO-ERROR.
            ELSE 
               FIND par-cota NO-LOCK 
                    WHERE par-cota.cod-estabel = cotas.cod-estabel NO-ERROR.  
        END.
        /*********************************************/ 

        run pi-acompanhar in h-acomp (cotas.cod-rep).        
         
        /* Caso controle por n¡veis */
        run pi-trata-niveis. 

        /* Caso nÆo controle por n¡veis */
        if par-cota.log-impl-niveis = no and
           l-copi-mesmo-reg = no then do:  
    
            find first b-cotas exclusive-lock 
                 where b-cotas.cod-estabel     = cotas.cod-estabel
                 and   b-cotas.cod-canal-venda = cotas.cod-canal-venda
                 and   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                 and   b-cotas.nome-abrev      = cotas.nome-abrev
                 and   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                 and   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                 and   b-cotas.cod-rep         = cotas.cod-rep
                 and   b-cotas.cd-produto      = cotas.cd-produto
                 and   b-cotas.dt-inicial      = tt-param.data-dest no-error.
    
            if not avail b-cotas then do:
               create b-cotas.
               assign b-cotas.cod-estabel     = cotas.cod-estabel
                      b-cotas.cod-canal-venda = cotas.cod-canal-venda
                      b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                      b-cotas.nome-abrev      = cotas.nome-abrev
                      b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                      b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                      b-cotas.cod-rep         = cotas.cod-rep 
                      b-cotas.cd-produto      = cotas.cd-produto
                      b-cotas.dt-inicial      = tt-param.data-dest.
            end.
            
            assign b-cotas.dt-final      = tt-param.data-fim-dest
                   b-cotas.qt-prevista   = b-cotas.qt-prevista + (cotas.qt-prevista * de-perc)
                   b-cotas.vl-previsto   = b-cotas.vl-previsto + (cotas.vl-previsto * de-perc)
                   b-cotas.qt-original   = b-cotas.qt-original + (cotas.qt-original * de-perc)
                   b-cotas.vl-original   = b-cotas.vl-original + (cotas.vl-original * de-perc)
                   b-cotas.qt-solicitado = b-cotas.qt-solicitado + (cotas.qt-solicitado * de-perc)
                   b-cotas.vl-solicitado = b-cotas.vl-solicitado + (cotas.vl-solicitado * de-perc)
                   b-cotas.vl-medio-prev = cotas.vl-medio-prev.
            
            if not tt-param.l-base-cota then 
            
            if last-of(cotas.cod-estabel) or
               last-of(cotas.cd-produto)  or
               last-of(cotas.dt-inicial)  then do:
               
               find first base-cota use-index periodo where
                          base-cota.cod-estabel = cotas.cod-estabel
                    and   base-cota.cd-produto  = cotas.cd-produto
                    and   base-cota.dt-inicial  = tt-param.data-orig no-lock no-error.
                    
               if avail base-cota then do: 
                  find first b-base-cota use-index periodo where
                             b-base-cota.cod-estabel = base-cota.cod-estabel and
                             b-base-cota.cd-produto  = base-cota.cd-produto and
                             b-base-cota.dt-inicial  = tt-param.data-dest exclusive-lock no-error.
                  if not avail b-base-cota then do:
                     create b-base-cota.
                     assign b-base-cota.cod-estabel      = base-cota.cod-estabel 
                            b-base-cota.cd-produto       = base-cota.cd-produto
                            b-base-cota.dt-inicial       = tt-param.data-dest
                            b-base-cota.dt-final         = tt-param.data-fim-dest.
                  end.
                  assign b-base-cota.cd-produto-dest  = base-cota.cd-produto-dest
                         b-base-cota.log-consid-cotas = base-cota.log-consid-cotas 
                         b-base-cota.log-cota-limite  = base-cota.log-cota-limite
                         b-base-cota.nr-pontos        = base-cota.nr-pontos
                         b-base-cota.qt-prevista      = b-base-cota.qt-prevista + (base-cota.qt-prevista * de-perc) .
               end. 
            end. 
        end.

    end.

&ENDIF

end procedure.

procedure pi-trata-niveis.
 /* 
   Para a release 2.03 serÆo tratados n¡veis. Portanto, serÆo copiados apenas os n¡veis setados na 
   interface.
 */

&IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
   
   if par-cota.log-impl-niveis = yes then do:

        if tt-param.l-repres or
           tt-param.l-mic-reg or     
           tt-param.l-regiao or 
           tt-param.l-cliente or
           tt-param.l-gr-cli or
           tt-param.l-canal then 
           
           if not can-find (first base-cota use-index periodo where
                                  base-cota.cod-estabel = cotas.cod-estabel and
                                  base-cota.cd-produto  = cotas.cd-produto and
                                  base-cota.dt-inicial  = tt-param.data-dest) then do:
              {utp/ut-liter.i "  NÆo ser  poss¡vel criar Cotas, pois nÆo existe Base de Cotas cadastrada para:" *}
              put unformatted skip(1) return-value skip(1).

              {utp/ut-liter.i "Estabelecimento : " *}
              c-estab = return-value.
              {utp/ut-liter.i "Item/Produto    : " *}
              c-item-prod = return-value.
              {utp/ut-liter.i "Data Inicial    : " *}
              c-data-ini = return-value.

              put unformatted c-estab cotas.cod-estabel skip
                              c-item-prod cotas.cd-produto skip
                              c-data-ini tt-param.data-dest skip (2).
              return.
           end.   
                
        if tt-param.l-repres and
           cotas.cod-rep  <> ? then do: 
           find first b-cotas exclusive-lock 
                where b-cotas.cod-estabel     = cotas.cod-estabel
                and   b-cotas.cod-canal-venda = cotas.cod-canal-venda
                and   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                and   b-cotas.nome-abrev      = cotas.nome-abrev
                and   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                and   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                and   b-cotas.cod-rep         = cotas.cod-rep
                and   b-cotas.cd-produto      = cotas.cd-produto
                and   b-cotas.dt-inicial      = tt-param.data-dest no-error.
           if l-copi-mesmo-reg = no then do:              
              if not avail b-cotas then do:
                 create b-cotas.
                 assign b-cotas.cod-estabel     = cotas.cod-estabel
                        b-cotas.cod-canal-venda = cotas.cod-canal-venda
                        b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                        b-cotas.nome-abrev      = cotas.nome-abrev
                        b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                        b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                        b-cotas.cod-rep         = cotas.cod-rep 
                        b-cotas.cd-produto      = cotas.cd-produto
                        b-cotas.dt-inicial      = tt-param.data-dest
                        b-cotas.dt-final      = tt-param.data-fim-dest.
              end.
              assign b-cotas.qt-prevista   = b-cotas.qt-prevista + (cotas.qt-prevista * de-perc)
                     b-cotas.vl-previsto   = b-cotas.vl-previsto + (cotas.vl-previsto * de-perc)
                     b-cotas.qt-original   = b-cotas.qt-original + (cotas.qt-original * de-perc)
                     b-cotas.vl-original   = b-cotas.vl-original + (cotas.vl-original * de-perc)
                     b-cotas.qt-solicitado = b-cotas.qt-solicitado + (cotas.qt-solicitado * de-perc)
                     b-cotas.vl-solicitado = b-cotas.vl-solicitado + (cotas.vl-solicitado * de-perc)
                     b-cotas.vl-medio-prev = cotas.vl-medio-prev.
           end.
           else 
               if avail b-cotas then
                  run pi-grava-valores.
           
         
               

        end. /* l-repres ,  if cod-rep */
        
        if tt-param.l-mic-reg      and
           cotas.cod-rep      =  ? and
           cotas.nome-mic-reg <> ? then do:

           find first b-cotas exclusive-lock 
                where b-cotas.cod-estabel     = cotas.cod-estabel
                and   b-cotas.cod-canal-venda = cotas.cod-canal-venda
                and   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                and   b-cotas.nome-abrev      = cotas.nome-abrev
                and   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                and   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                and   b-cotas.cod-rep         = cotas.cod-rep
                and   b-cotas.cd-produto      = cotas.cd-produto
                and   b-cotas.dt-inicial      = tt-param.data-dest no-error.
           if l-copi-mesmo-reg = no then do:
              if not avail b-cotas then do:
                 create b-cotas.
                 assign b-cotas.cod-estabel     = cotas.cod-estabel
                        b-cotas.cod-canal-venda = cotas.cod-canal-venda
                        b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                        b-cotas.nome-abrev      = cotas.nome-abrev
                        b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                        b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                        b-cotas.cod-rep         = cotas.cod-rep 
                        b-cotas.cd-produto      = cotas.cd-produto
                        b-cotas.dt-inicial      = tt-param.data-dest
                        b-cotas.dt-final      = tt-param.data-fim-dest.
              end.

              assign b-cotas.qt-prevista   = b-cotas.qt-prevista + (cotas.qt-prevista * de-perc)
                     b-cotas.vl-previsto   = b-cotas.vl-previsto + (cotas.vl-previsto * de-perc)
                     b-cotas.qt-original   = b-cotas.qt-original + (cotas.qt-original * de-perc)
                     b-cotas.vl-original   = b-cotas.vl-original + (cotas.vl-original * de-perc)
                     b-cotas.qt-solicitado = b-cotas.qt-solicitado + (cotas.qt-solicitado * de-perc)
                     b-cotas.vl-solicitado = b-cotas.vl-solicitado + (cotas.vl-solicitado * de-perc)
                     b-cotas.vl-medio-prev = cotas.vl-medio-prev.
           end.
           else 
               if avail b-cotas then
                  run pi-grava-valores.

        end. /*l-mic-reg  , if par-cota */
           
        if tt-param.l-regiao and
           cotas.cod-rep      = ? and
           cotas.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
           cotas.nome-ab-reg <> ? then do:
              
           find first b-cotas exclusive-lock 
                where b-cotas.cod-estabel     = cotas.cod-estabel
                and   b-cotas.cod-canal-venda = cotas.cod-canal-venda
                and   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                and   b-cotas.nome-abrev      = cotas.nome-abrev
                and   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                and   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                and   b-cotas.cod-rep         = cotas.cod-rep
                and   b-cotas.cd-produto      = cotas.cd-produto
                and   b-cotas.dt-inicial      = tt-param.data-dest no-error.
           if l-copi-mesmo-reg = no then do:
              if not avail b-cotas then do:
                 create b-cotas.
                 assign b-cotas.cod-estabel     = cotas.cod-estabel
                        b-cotas.cod-canal-venda = cotas.cod-canal-venda
                        b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                        b-cotas.nome-abrev      = cotas.nome-abrev
                        b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                        b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                        b-cotas.cod-rep         = cotas.cod-rep 
                        b-cotas.cd-produto      = cotas.cd-produto
                        b-cotas.dt-inicial      = tt-param.data-dest
                        b-cotas.dt-final        = tt-param.data-fim-dest.
              end.
                
              assign b-cotas.qt-prevista   = b-cotas.qt-prevista + (cotas.qt-prevista * de-perc)
                     b-cotas.vl-previsto   = b-cotas.vl-previsto + (cotas.vl-previsto * de-perc)
                     b-cotas.qt-original   = b-cotas.qt-original + (cotas.qt-original * de-perc)
                     b-cotas.vl-original   = b-cotas.vl-original + (cotas.vl-original * de-perc)
                     b-cotas.qt-solicitado = b-cotas.qt-solicitado + (cotas.qt-solicitado * de-perc)
                     b-cotas.vl-solicitado = b-cotas.vl-solicitado + (cotas.vl-solicitado * de-perc)
                     b-cotas.vl-medio-prev = cotas.vl-medio-prev.
           end.
           else 
               if avail b-cotas then
                  run pi-grava-valores.

        end. /* l-regiao , if par-cota */        


        if tt-param.l-cliente and
           cotas.cod-rep = ? and
           cotas.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
           cotas.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and  
           cotas.nome-abrev <> ? then do:
              
           find first b-cotas exclusive-lock 
                where b-cotas.cod-estabel     = cotas.cod-estabel
                and   b-cotas.cod-canal-venda = cotas.cod-canal-venda
                and   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                and   b-cotas.nome-abrev      = cotas.nome-abrev
                and   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                and   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                and   b-cotas.cod-rep         = cotas.cod-rep
                and   b-cotas.cd-produto      = cotas.cd-produto
                and   b-cotas.dt-inicial      = tt-param.data-dest no-error.
           if l-copi-mesmo-reg = no then do:
              if not avail b-cotas then do:
                 create b-cotas.
                 assign b-cotas.cod-estabel     = cotas.cod-estabel
                        b-cotas.cod-canal-venda = cotas.cod-canal-venda
                        b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                        b-cotas.nome-abrev      = cotas.nome-abrev
                        b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                        b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                        b-cotas.cod-rep         = cotas.cod-rep 
                        b-cotas.cd-produto      = cotas.cd-produto
                        b-cotas.dt-inicial      = tt-param.data-dest
                        b-cotas.dt-final        = tt-param.data-fim-dest.
              end.
                
              assign b-cotas.qt-prevista   = b-cotas.qt-prevista + (cotas.qt-prevista * de-perc)
                     b-cotas.vl-previsto   = b-cotas.vl-previsto + (cotas.vl-previsto * de-perc)
                     b-cotas.qt-original   = b-cotas.qt-original + (cotas.qt-original * de-perc)
                     b-cotas.vl-original   = b-cotas.vl-original + (cotas.vl-original * de-perc)
                     b-cotas.qt-solicitado = b-cotas.qt-solicitado + (cotas.qt-solicitado * de-perc)
                     b-cotas.vl-solicitado = b-cotas.vl-solicitado + (cotas.vl-solicitado * de-perc)
                     b-cotas.vl-medio-prev = cotas.vl-medio-prev.
           end.
           else 
               if avail b-cotas then
                  run pi-grava-valores.

        end. /* l-cliente , if par-cota */        


        if tt-param.l-gr-cli and
           cotas.cod-rep = ? and
           cotas.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
           cotas.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and  
           cotas.nome-abrev = (if par-cota.Cont-cliente then ? else "" ) and
           cotas.cod-gr-cli <> ? then do:
              
           find first b-cotas exclusive-lock 
                where b-cotas.cod-estabel     = cotas.cod-estabel
                and   b-cotas.cod-canal-venda = cotas.cod-canal-venda
                and   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                and   b-cotas.nome-abrev      = cotas.nome-abrev
                and   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                and   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                and   b-cotas.cod-rep         = cotas.cod-rep
                and   b-cotas.cd-produto      = cotas.cd-produto
                and   b-cotas.dt-inicial      = tt-param.data-dest no-error.
           if l-copi-mesmo-reg = no then do:
              if not avail b-cotas then do:
                 create b-cotas.
                 assign b-cotas.cod-estabel     = cotas.cod-estabel
                        b-cotas.cod-canal-venda = cotas.cod-canal-venda
                        b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                        b-cotas.nome-abrev      = cotas.nome-abrev
                        b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                        b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                        b-cotas.cod-rep         = cotas.cod-rep 
                        b-cotas.cd-produto      = cotas.cd-produto
                        b-cotas.dt-inicial      = tt-param.data-dest
                        b-cotas.dt-final        = tt-param.data-fim-dest.
              end.
                
              assign b-cotas.qt-prevista   = b-cotas.qt-prevista + (cotas.qt-prevista * de-perc)
                     b-cotas.vl-previsto   = b-cotas.vl-previsto + (cotas.vl-previsto * de-perc)
                     b-cotas.qt-original   = b-cotas.qt-original + (cotas.qt-original * de-perc)
                     b-cotas.vl-original   = b-cotas.vl-original + (cotas.vl-original * de-perc)
                     b-cotas.qt-solicitado = b-cotas.qt-solicitado + (cotas.qt-solicitado * de-perc)
                     b-cotas.vl-solicitado = b-cotas.vl-solicitado + (cotas.vl-solicitado * de-perc)
                     b-cotas.vl-medio-prev = cotas.vl-medio-prev.
           end.
           else 
               if avail b-cotas then
                  run pi-grava-valores.
        end. /*l-gr-cli , if par-cota */        
 
        if tt-param.l-canal and
           cotas.cod-rep = ? and
           cotas.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
           cotas.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and  
           cotas.nome-abrev = (if par-cota.Cont-cliente then ? else "" ) and
           cotas.cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0 ) and
           cotas.cod-canal-venda <> ? then do:
              
           find first b-cotas exclusive-lock 
                where b-cotas.cod-estabel     = cotas.cod-estabel
                and   b-cotas.cod-canal-venda = cotas.cod-canal-venda
                and   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                and   b-cotas.nome-abrev      = cotas.nome-abrev
                and   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                and   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                and   b-cotas.cod-rep         = cotas.cod-rep
                and   b-cotas.cd-produto      = cotas.cd-produto
                and   b-cotas.dt-inicial      = tt-param.data-dest no-error.
           if l-copi-mesmo-reg = no then do:
              if not avail b-cotas then do:
                 create b-cotas.
                 assign b-cotas.cod-estabel     = cotas.cod-estabel
                        b-cotas.cod-canal-venda = cotas.cod-canal-venda
                        b-cotas.cod-gr-cli      = cotas.cod-gr-cli
                        b-cotas.nome-abrev      = cotas.nome-abrev
                        b-cotas.nome-ab-reg     = cotas.nome-ab-reg
                        b-cotas.nome-mic-reg    = cotas.nome-mic-reg
                        b-cotas.cod-rep         = cotas.cod-rep 
                        b-cotas.cd-produto      = cotas.cd-produto
                        b-cotas.dt-inicial      = tt-param.data-dest
                        b-cotas.dt-final        = tt-param.data-fim-dest.
              end.
                
              assign b-cotas.qt-prevista   = b-cotas.qt-prevista + (cotas.qt-prevista * de-perc)
                     b-cotas.vl-previsto   = b-cotas.vl-previsto + (cotas.vl-previsto * de-perc)
                     b-cotas.qt-original   = b-cotas.qt-original + (cotas.qt-original * de-perc)
                     b-cotas.vl-original   = b-cotas.vl-original + (cotas.vl-original * de-perc)
                     b-cotas.qt-solicitado = b-cotas.qt-solicitado + (cotas.qt-solicitado * de-perc)
                     b-cotas.vl-solicitado = b-cotas.vl-solicitado + (cotas.vl-solicitado * de-perc)
                     b-cotas.vl-medio-prev = cotas.vl-medio-prev.
           end.
           else 
               if avail b-cotas then
                  run pi-grava-valores.
        end. /*l-canal , if par-cota */                          
        
        release b-cotas.    
    
    end. /* par-cota.log-impl-niveis */
    
&ENDIF    

end procedure.


procedure pi-grava-valores.
/* Faz uma copia dos valores para o mesmo registro */

    if tt-param.i-destino = 1 and 
       tt-param.i-origem  = 1 then 
       if par-cota.tipo-controle = 2 then do:
          if cotas.vl-previsto <> 0 then 
             assign b-cotas.vl-previsto = cotas.vl-previsto.
       end.   
       else do:
          if cotas.qt-prevista <> 0 then 
             assign b-cotas.qt-prevista = cotas.qt-prevista.
       end.   
     
    if tt-param.i-destino = 1 and 
       tt-param.i-origem  = 2 then
       if par-cota.tipo-controle = 2 then do:
          if cotas.vl-original <> 0 then
             assign b-cotas.vl-previsto = cotas.vl-original.
       end.
       else do:
          if cotas.qt-original <> 0 then 
             assign b-cotas.qt-prevista = cotas.qt-original.
       end.   

    if tt-param.i-destino = 1 and 
       tt-param.i-origem  = 3 then
       if par-cota.tipo-controle = 2 then do:
          if cotas.vl-solicitado <> 0 then 
             assign b-cotas.vl-previsto = cotas.vl-solicitado.
       end.   
       else do:
          if cotas.qt-solicitado <> 0 then 
             assign b-cotas.qt-prevista = cotas.qt-solicitado.
       end.   

    if tt-param.i-destino = 2 and 
       tt-param.i-origem  = 1 then
       if par-cota.tipo-controle = 2 then do:
          if cotas.vl-previsto <> 0 then  
             assign b-cotas.vl-original = cotas.vl-previsto.
       end.   
       else do:
          if cotas.qt-prevista <> 0 then 
             assign b-cotas.qt-original = cotas.qt-prevista.
       end.   

    if tt-param.i-destino = 2 and 
       tt-param.i-origem  = 2 then
       if par-cota.tipo-controle = 2 then do:
          if cotas.vl-original <> 0 then  
             assign b-cotas.vl-original = cotas.vl-original.
       end.   
       else do:
          if cotas.qt-original <> 0 then 
             assign b-cotas.qt-original = cotas.qt-original.
       end.
          
    if tt-param.i-destino = 2 and 
       tt-param.i-origem  = 3 then
       if par-cota.tipo-controle = 2 then do:
          if cotas.vl-solicitado <> 0 then 
             assign b-cotas.vl-solicitado = cotas.vl-solicitado.
       end.   
       else do:
          if cotas.qt-solicitado <> 0 then 
             assign b-cotas.qt-solicitado= cotas.qt-solicitado.
       end.   

    if tt-param.i-destino = 3 and 
       tt-param.i-origem  = 1 then
       if par-cota.tipo-controle = 2 then do:
          if cotas.vl-previsto <> 0 then
             assign b-cotas.vl-solicitado = cotas.vl-previsto.
       end.   
       else do:
          if cotas.qt-prevista <> 0 then
             assign b-cotas.qt-solicitado = cotas.qt-prevista.
       end.
          
    if tt-param.i-destino = 3 and 
       tt-param.i-origem  = 2 then
       if par-cota.tipo-controle = 2 then do:
          if cotas.vl-original <> 0 then 
             assign b-cotas.vl-solicitado = cotas.vl-original.
       end.  
       else do:
          if cotas.qt-original <> 0 then 
             assign b-cotas.qt-solicitado = cotas.qt-original.
       end.   

    if tt-param.i-destino = 3 and 
       tt-param.i-origem  = 3 then
       if par-cota.tipo-controle = 2 then do:
          if cotas.vl-solicitado <> 0 then 
             assign b-cotas.vl-solicitado = cotas.vl-solicitado.
       end.   
       else do:
          if cotas.qt-solicitado <> 0 then 
             assign b-cotas.qt-solicitado = cotas.qt-solicitado.
       end.
          
end procedure.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
display c-selecao 
        tt-param.estabel-ini
        tt-param.estabel-fim
        c-parametro
        tt-param.data-orig
        tt-param.data-dest
        tt-param.data-fim-dest
        tt-param.percentual
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.
if tt-param.elimina then 
   {utp/ut-liter.i Sim * R}
else 
   {utp/ut-liter.i NÆo * R}

disp trim(return-value) @ tt-param.elimina with frame f-parametros.
down with frame f-parametros.

{include/i-rpclo.i}
run pi-finalizar in h-acomp.



RETURN "OK".


/* Fim do Programa */


