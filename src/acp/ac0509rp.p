/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0509RP 2.00.00.004 } /*** "010004" 09/09/2024 16:35:19  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0509rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac0509RP.P : Gera‡Æo de Gr fico de Desempenho com op‡Æo informar a chave.
**
********************************************************************************/


def var h-acomp            as handle                      no-undo.
def var de-qtde-tot        like cotas.qt-prevista         no-undo.
def var de-qtde-tot-realiz like cotas.qt-pedida           no-undo.
def var c-tit-graf         as char format "x(25)"         no-undo.
def var c-tit-y            as char format "x(18)"         no-undo.
def var i-cont-aux         as int  init 1                 no-undo.
def var l-achou            as log  init no                no-undo.
def var h-utapi011         as handle                      no-undo.
/* defini‡äes de temp tables gr ficos */
{utp/utapi001.i}


/*defini‡Æo da temp table tt-param*/
{acp/ac0509.i}


def temp-table tt-info
    field campo-chave as char
    field qtde        like cotas.qt-prevista.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param as raw no-undo.

create tt-param.
raw-transfer raw-param to tt-param no-error.

find first par-cota no-lock
     where par-cota.cod-estabel  >= tt-param.cod-estab-ini
       and par-cota.cod-estabel  <= tt-param.cod-estab-fim no-error.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Aguarde..." ).

/************************* Inicio Processo **************/

if par-cota.log-impl-niveis then do:

   /* leitura do canal venda */
   if i-chave = 1 then do:
      for each cotas no-lock 
          where   cotas.cod-estabel     >= tt-param.cod-estab-ini
            and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
            and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
            and   cotas.cod-gr-cli       = (if par-cota.Cont-gr-cli then ? else 0)
            and   cotas.nome-abrev       = (if par-cota.Cont-cliente then ? else "")
            and   cotas.nome-ab-reg      = (if par-cota.Cont-ab-reg then ? else "")
            and   cotas.nome-mic-reg     = (if par-cota.Cont-mic-reg then ? else "")
            and   cotas.cod-rep          = ?
            and   cotas.cd-produto      >= tt-param.cd-produto-ini
            and   cotas.cd-produto      <= tt-param.cd-produto-fim
            and   cotas.dt-inicial      >= tt-param.dt-inicial
            and   cotas.dt-inicial      <= tt-param.dt-final 
          break by cotas.cod-canal-venda:

          run pi-acompanhar in h-acomp ( input cotas.cod-rep ).

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

          if last-of(cotas.cod-canal-venda) then do:
             create tt-info.
             assign tt-info.campo-chave = string(cotas.cod-canal-venda)
                    tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                    de-qtde-tot         = 0
                    de-qtde-tot-realiz  = 0
                    l-achou            = yes.
          end.        
      end. /*for each que est  na include*/  
   end.

   /* leitura do grupo de clientes */
   if i-chave = 2 then do:
      for each cotas no-lock 
          where   cotas.cod-estabel     >= tt-param.cod-estab-ini
            and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
            and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
            and   cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
            and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
            and   cotas.nome-abrev       = (if par-cota.cont-cliente then ? else "")
            and   cotas.nome-ab-reg      = (if par-cota.cont-ab-reg then ? else "")
            and   cotas.nome-mic-reg     = (if par-cota.cont-mic-reg then ? else "")
            and   cotas.cod-rep          = ?
            and   cotas.cd-produto      >= tt-param.cd-produto-ini
            and   cotas.cd-produto      <= tt-param.cd-produto-fim
            and   cotas.dt-inicial      >= tt-param.dt-inicial
            and   cotas.dt-inicial      <= tt-param.dt-final 
          break by cotas.cod-gr-cli:

          run pi-acompanhar in h-acomp ( input cotas.cod-rep ).

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

          if last-of(cotas.cod-gr-cli) then do:
             create tt-info.
             assign tt-info.campo-chave = string(cotas.cod-gr-cli)
                    tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                    de-qtde-tot         = 0
                    de-qtde-tot-realiz  = 0
                    l-achou             = yes.
          end.        

      end. /*for each que est  na include*/  
   end.

   /* leitura do cliente */
   if i-chave = 3 then do:
      for each cotas no-lock 
          where   cotas.cod-estabel     >= tt-param.cod-estab-ini
            and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
            and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
            and   cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
            and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
            and   cotas.nome-abrev      >= tt-param.nome-abrev-ini
            and   cotas.nome-abrev      <= tt-param.nome-abrev-fim
            and   cotas.nome-ab-reg      = (if par-cota.cont-ab-reg then ? else "")
            and   cotas.nome-mic-reg     = (if par-cota.cont-mic-reg then ? else "")
            and   cotas.cod-rep          = ?
            and   cotas.cd-produto      >= tt-param.cd-produto-ini
            and   cotas.cd-produto      <= tt-param.cd-produto-fim
            and   cotas.dt-inicial      >= tt-param.dt-inicial
            and   cotas.dt-inicial      <= tt-param.dt-final 
          break by cotas.nome-abrev:

          run pi-acompanhar in h-acomp ( input cotas.cod-rep ).

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

          if last-of(cotas.nome-abrev) then do:
             create tt-info.
             assign tt-info.campo-chave = string(cotas.nome-abrev)
                    tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                    de-qtde-tot         = 0
                    de-qtde-tot-realiz  = 0
                    l-achou            = yes.
          end.        

      end. /*for each que est  na include*/  
   end.

   /* leitura da regiÆo  */
   if i-chave = 4 then do:
      for each cotas no-lock 
          where   cotas.cod-estabel     >= tt-param.cod-estab-ini
            and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
            and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
            and   cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
            and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
            and   cotas.nome-abrev      >= tt-param.nome-abrev-ini
            and   cotas.nome-abrev      <= tt-param.nome-abrev-fim
            and   cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
            and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim
            and   cotas.nome-mic-reg     = (if par-cota.cont-mic-reg then ? else "")
            and   cotas.cod-rep          = ?
            and   cotas.cd-produto      >= tt-param.cd-produto-ini
            and   cotas.cd-produto      <= tt-param.cd-produto-fim
            and   cotas.dt-inicial      >= tt-param.dt-inicial
            and   cotas.dt-inicial      <= tt-param.dt-final 
          break by cotas.nome-ab-reg:

          run pi-acompanhar in h-acomp ( input cotas.cod-rep ).

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

          if last-of(cotas.nome-ab-reg) then do:
             create tt-info.
             assign tt-info.campo-chave = string(cotas.nome-ab-reg)
                    tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                    de-qtde-tot         = 0
                    de-qtde-tot-realiz  = 0
                    l-achou            = yes.
          end.        

      end. /*for each que est  na include*/  
   end.

   /* leitura da microrregiÆo  */
   if i-chave = 5 then do:
      for each cotas no-lock 
          where   cotas.cod-estabel     >= tt-param.cod-estab-ini
            and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
            and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
            and   cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
            and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
            and   cotas.nome-abrev      >= tt-param.nome-abrev-ini
            and   cotas.nome-abrev      <= tt-param.nome-abrev-fim
            and   cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
            and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim
            and   cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
            and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim
            and   cotas.cod-rep          = ?
            and   cotas.cd-produto      >= tt-param.cd-produto-ini
            and   cotas.cd-produto      <= tt-param.cd-produto-fim
            and   cotas.dt-inicial      >= tt-param.dt-inicial
            and   cotas.dt-inicial      <= tt-param.dt-final 
          break by cotas.nome-mic-reg:

          run pi-acompanhar in h-acomp ( input cotas.cod-rep ).

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

          if last-of(cotas.nome-mic-reg) then do:
             create tt-info.
             assign tt-info.campo-chave = string(cotas.nome-mic-reg)
                    tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                    de-qtde-tot         = 0
                    de-qtde-tot-realiz  = 0
                    l-achou            = yes.
          end.        

      end. /*for each que est  na include*/  
   end.

   /* leitura da representante  */
   if i-chave = 6 then do:
      for each cotas no-lock 
          where   cotas.cod-estabel     >= tt-param.cod-estab-ini
            and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
            and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
            and   cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
            and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
            and   cotas.nome-abrev      >= tt-param.nome-abrev-ini
            and   cotas.nome-abrev      <= tt-param.nome-abrev-fim
            and   cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
            and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim
            and   cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
            and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim
            and   cotas.cod-rep         >= tt-param.cod-rep-ini
            and   cotas.cod-rep         <= tt-param.cod-rep-fim
            and   cotas.cd-produto      >= tt-param.cd-produto-ini
            and   cotas.cd-produto      <= tt-param.cd-produto-fim
            and   cotas.dt-inicial      >= tt-param.dt-inicial
            and   cotas.dt-inicial      <= tt-param.dt-final 
          break by cotas.cod-rep:

          run pi-acompanhar in h-acomp ( input cotas.cod-rep ).

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

          if last-of(cotas.cod-rep) then do:
             create tt-info.
             assign tt-info.campo-chave = string(cotas.cod-rep)
                    tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                    de-qtde-tot         = 0
                    de-qtde-tot-realiz  = 0
                    l-achou            = yes.
          end.        

      end. /*for each que est  na include*/  
   end.

   /* leitura do produto/item  */
   if i-chave = 7 then do:
      for each cotas no-lock 
          where   cotas.cod-estabel     >= tt-param.cod-estab-ini
            and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
            and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
            and   cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
            and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
            and   cotas.nome-abrev      >= tt-param.nome-abrev-ini
            and   cotas.nome-abrev      <= tt-param.nome-abrev-fim
            and   cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
            and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim
            and   cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
            and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim
            and   cotas.cod-rep         >= tt-param.cod-rep-ini
            and   cotas.cod-rep         <= tt-param.cod-rep-fim
            and   cotas.cd-produto      >= tt-param.cd-produto-ini
            and   cotas.cd-produto      <= tt-param.cd-produto-fim
            and   cotas.dt-inicial      >= tt-param.dt-inicial
            and   cotas.dt-inicial      <= tt-param.dt-final 
          break by cotas.cd-produto:

          run pi-acompanhar in h-acomp ( input cotas.cod-rep ).

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

          if last-of(cotas.cd-produto) then do:
             create tt-info.
             assign tt-info.campo-chave = string(cotas.cd-produto)
                    tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                    de-qtde-tot         = 0
                    de-qtde-tot-realiz  = 0
                    l-achou            = yes.
          end.        

      end. /*for each que est  na include*/  
   end.

end.
else do:

   /* leitura do canal venda */
   if i-chave = 1 then do:
      /* for each de cotas */
      {acp/ac0504.i1 "break by cotas.cod-canal-venda"}

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

           if last-of(cotas.cod-canal-venda) then do:
              create tt-info.
              assign tt-info.campo-chave = string(cotas.cod-canal-venda)
                     tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                     de-qtde-tot         = 0
                     de-qtde-tot-realiz  = 0
                     l-achou            = yes. 
           end.        
      end. /*for each que est  na include*/  
   end.

   /* leitura do grupo de clientes */
   if i-chave = 2 then do:
      /* for each de cotas */
      {acp/ac0504.i1 "break by cotas.cod-gr-cli"}

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

           if last-of(cotas.cod-gr-cli) then do:
              create tt-info.
              assign tt-info.campo-chave = string(cotas.cod-gr-cli)
                     tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                     de-qtde-tot         = 0
                     de-qtde-tot-realiz  = 0
                     l-achou            = yes. 
           end.        
      end. /*for each que est  na include*/  
   end.

   /* leitura do cliente */
   if i-chave = 3 then do:
      /* for each de cotas */
      {acp/ac0504.i1 "break by cotas.nome-abrev"}

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.           

           if last-of(cotas.nome-abrev) then do:
              create tt-info.
              assign tt-info.campo-chave = cotas.nome-abrev
                     tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                     de-qtde-tot         = 0
                     de-qtde-tot-realiz  = 0
                     l-achou            = yes. 
           end.        
      end. /*for each que est  na include*/  
   end.

   /* leitura da regiÆo  */
   if i-chave = 4 then do:
      /* for each de cotas */
      {acp/ac0504.i1 "break by cotas.nome-ab-reg"}

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.      

           if last-of(cotas.nome-ab-reg) then do:
              create tt-info.
              assign tt-info.campo-chave = cotas.nome-ab-reg
                     tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                     de-qtde-tot         = 0
                     de-qtde-tot-realiz  = 0
                     l-achou            = yes. 
           end.        
      end. /*for each que est  na include*/  
   end.

   /* leitura da microrregiÆo  */
   if i-chave = 5 then do:
      /* for each de cotas */
      {acp/ac0504.i1 "break by cotas.nome-mic-reg"}

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.      

           if last-of(cotas.nome-mic-reg) then do:
              create tt-info.
              assign tt-info.campo-chave = cotas.nome-mic-reg
                     tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                     de-qtde-tot         = 0
                     de-qtde-tot-realiz  = 0
                     l-achou             = yes. 
           end.        
      end. /*for each que est  na include*/  
   end.

   /* leitura da representante  */
   if i-chave = 6 then do:
      /* for each de cotas */
      {acp/ac0504.i1 "break by cotas.cod-rep"}

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

           if last-of(cotas.cod-rep) then do:
              create tt-info.
              assign tt-info.campo-chave = string(cotas.cod-rep)
                     tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                     de-qtde-tot         = 0
                     de-qtde-tot-realiz  = 0
                     l-achou             = yes. 
           end.        
      end. /*for each que est  na include*/  
   end.

   /* leitura do produto/item  */
   if i-chave = 7 then do:
      /* for each de cotas */
      {acp/ac0504.i1 "break by cotas.cd-produto"}

          if i-base-calc = 1 then {acp/ac0509.i2 "cotas.qt-prevista" "cotas.vl-previsto"}.   
          if i-base-calc = 2 then {acp/ac0509.i2 "cotas.qt-original" "cotas.vl-original"}.   
          if i-realizada = 1 then {acp/ac0509.i3 "cotas.qt-pedida" "cotas.vl-pedido"}.   
          if i-realizada = 2 then {acp/ac0509.i3 "cotas.qt-faturada" "cotas.vl-faturado"}.   

           if last-of(cotas.cd-produto) then do:
              create tt-info.
              assign tt-info.campo-chave = cotas.cd-produto
                     tt-info.qtde        = de-qtde-tot-realiz * 100 / de-qtde-tot
                     de-qtde-tot         = 0
                     de-qtde-tot-realiz  = 0
                     l-achou             = yes. 
           end.        
      end. /*for each que est  na include*/  
   end.
end.

/*************************** Inicio Gera‡Æo do gr fico ***********************/
run pi-finalizar in h-acomp.

IF THIS-PROCEDURE:PERSISTENT = TRUE THEN RETURN.

if l-achou = no then do:
   return.
end.

for each tt-sets:
  delete tt-sets.
end.
for each tt-ylabels:
  delete tt-ylabels.
end.                              
for each tt-points:
  delete tt-points.
end.
for each tt-dados:
  delete tt-dados.
end.
for each tt-atributos:
  delete tt-atributos.
end.

do on error undo, return error
   on stop  undo, return error:  

   if tt-param.i-chave = 1 then 
      {utp/ut-liter.i Canal_Venda  MAC R}.
   if tt-param.i-chave = 2 then
      {utp/ut-liter.i Grupo_Cliente  MAC R}.
   if tt-param.i-chave = 3 then
      {utp/ut-liter.i Cliente  MAC R}.
   if tt-param.i-chave = 4 then
      {utp/ut-liter.i RegiÆo  MAC R}.
   if tt-param.i-chave = 5 then
      {utp/ut-liter.i MicrorregiÆo  MAC R}.
   if tt-param.i-chave = 6 then
      {utp/ut-liter.i Representante  MAC R}.
   if tt-param.i-chave = 7 then
      {utp/ut-liter.i Produto  MAC R}.

   assign c-tit-graf = return-value.

   assign c-tit-y  = "% Realizado".

/*
   Foi retirado alguns tipos de grÿficos, porque estavam com problema. 
   (O fonte da API de gr˜ficos foi perdida.)

Antiga  - Atual
01      - 01 - Pizza 2D
02      - 02 - Pizza 3D
03      - 03 - Barra 2D
04      - 04 - Barra 3D
05 - Gantt
06      - 05 - Linha 
07 - Log/Lin
08      - 06 - Area 2D 
09      - 07 - Scatter 2D 
10      - 08 - Polar 
11 - High Low Close 	 
12 - Bolha 
13      - 09 - Tape 
14      - 10 - Area 3D
15 - Log/Log 	
16      - 11 - Lin / Log 
17      - 12 - Box whisker 
18 - Open High Low Close 
19 - Clandertick 	
20 - True 3D Surface 
21      - 13 True 3D Scatter 
22 - Time Series 
*/

   /* Ô necessÿrio manter a numera‡Æo antiga dos grÿficos */
   IF i-grafico = 5 THEN 
       ASSIGN tt-param.i-grafico = tt-param.i-grafico + 1.
   ELSE
   IF tt-param.i-grafico = 6 OR 
      tt-param.i-grafico = 7 OR
      tt-param.i-grafico = 8 THEN
       ASSIGN tt-param.i-grafico = tt-param.i-grafico + 2.
   ELSE
   IF tt-param.i-grafico = 9 OR 
      tt-param.i-grafico = 10 THEN 
       ASSIGN tt-param.i-grafico = tt-param.i-grafico + 4.
   ELSE
   IF tt-param.i-grafico = 11 OR 
      tt-param.i-grafico = 12 THEN 
       ASSIGN tt-param.i-grafico = tt-param.i-grafico + 5.
   ELSE
   IF tt-param.i-grafico = 13 THEN 
       ASSIGN tt-param.i-grafico = tt-param.i-grafico + 8.


   create tt-atributos.         
   assign tt-atributos.numgraph              = 1    
          tt-atributos.cod-versao-integracao = 3
          tt-atributos.graphtype             = i-grafico
          tt-atributos.graphtitle            = c-tit-graf 
          tt-atributos.lefttitle             = c-tit-y
          tt-atributos.lefttitlestyle        = 1
/*          tt-atributos.bottomtitle           = c-tit-x */
          tt-atributos.legendpos             = 0
          tt-atributos.gridstyle             = 1
          tt-atributos.gridlinestyle         = 1.                   

   create tt-sets.
   assign tt-sets.numset        = 1
          tt-sets.numgraph      = 1.


   for each tt-info.
        create tt-dados.
        assign tt-dados.numpoint  = i-cont-aux
               tt-dados.numset    = 1
               tt-dados.numgraph  = 1
               tt-dados.graphdata = tt-info.qtde. 

        if i-chave = 1 then {utp/ut-field.i mgdis cotas cod-canal-venda 1}.
        if i-chave = 2 then {utp/ut-field.i mgdis cotas cod-gr-cli 1}.
        if i-chave = 3 then {utp/ut-field.i mgdis cotas nome-abrev 1}.
        if i-chave = 4 then {utp/ut-field.i mgdis cotas nome-ab-reg 1}.
        if i-chave = 5 then {utp/ut-field.i mgdis cotas nome-mic-reg 1}.
        if i-chave = 6 then {utp/ut-field.i mgdis cotas cod-rep 1}.
        if i-chave = 7 then {utp/ut-field.i mgdis cotas cd-produto 1}.

        create tt-points.
        assign tt-points.numpoint  = i-cont-aux
               tt-points.numgraph  = 1
               tt-points.labeltext = trim(return-value) + ": " + tt-info.campo-chave
               i-cont-aux          = i-cont-aux + 1.       

   end.     
end. 


  /*******************/           
  /** Monta gr fico **/
  /*******************/

   run utp/utapi001.p (input table tt-atributos, 
                       input        table tt-points,
                       input        table tt-sets,
                       input        table tt-dados, 
                       input        table tt-ylabels,
                       output       table tt-erros).   


   for each tt-erros:
       run utp/ut-msgs.p (input 'show', input tt-erros.cod-erro, '').
   end.

RETURN "OK".

PROCEDURE returnTtInfo:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-info.
END PROCEDURE.

/* Fim do Programa */


