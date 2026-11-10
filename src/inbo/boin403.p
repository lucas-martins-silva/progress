/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN403 2.00.01.017} /*** "010117" 17/06/2025 16:40:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin403 MUT}
&ENDIF


/*
**  BOIN403.P
**
**  saldo-estoq - Saldos em Estoque
**
**  Ultima alteraá∆o : 21/06/99 - GeraBO 
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY saldo-estoq
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME saldo-estoq

def temp-table tt-saldo-por-deposito
	field cod-estabel as char
	field cod-depos as char	
	field cod-localiz	as char	
	field lote as char
	field qt-saldo as decimal.

{cdp/cdcfgmat.i}

/****************  Utilizado no comparaSaldoWMS (WMS)***********/
DEF TEMP-TABLE tt-deposito NO-UNDO
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD cod-estabel       AS CHAR format "x(05)"
&ELSE
    FIELD cod-estabel       AS CHAR FORMAT "X(3)"
&ENDIF
    FIELD cod-local         AS CHAR FORMAT "X(3)"
    FIELD cod-deposito      AS CHAR FORMAT "X(3)".

DEF TEMP-TABLE tt-erp-saldo-estoque NO-UNDO
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD cod-estabel       AS CHAR format "x(05)"
&ELSE
    FIELD cod-estabel       AS CHAR FORMAT "X(3)"
&ENDIF
    FIELD cod-deposito      AS CHAR FORMAT "X(3)"
    FIELD cod-local         AS CHAR FORMAT "X(3)"
    FIELD cod-item          AS CHAR FORMAT "X(16)"
    FIELD cod-refer         AS CHAR FORMAT "X(8)"
    FIELD cod-unid-med      AS CHAR FORMAT "X(2)"
    FIELD cod-lote          AS CHAR FORMAT "X(10)"
    FIELD dt-validade-lote  AS DATE FORMAT "99/99/9999"
    FIELD qtd-erp-saldo     AS DECIMAL FORMAT ">>>,>>>,>>9.9999"
    FIELD qtd-erp-liberada  AS DECIMAL FORMAT ">>>,>>>,>>9.9999"
    FIELD valor-unit-mat-m  AS DECIMAL FORMAT ">>>>,>>>,>>9.9999"
    INDEX ch-item cod-estabel
                  cod-deposito
                  cod-local
                  cod-item
                  cod-refer
                  cod-lote.

/******************************************************************/

/**************** EMBALAGEM ********************************/
define temp-table tt-saldo-estoque no-undo
   field cod-estabel like saldo-estoq.cod-estabel
   field cod-depos   like deposito.cod-depos
   field nome        like deposito.nome
   field qtidade-atu like saldo-estoq.qtidade-atu.
/******************************************************************/

  
 
{include/boini.i}
 
{inbo/boin403.i RowObject}
{inbo/boin403.i tt-saldo-estoq-aux}

def var c-it-codigo    as char                    no-undo.
def var c-cod-refer    as char                    no-undo.
def var c-cod-estabel  as char                    no-undo.
def var c-cod-depos    as char                    no-undo.
def var l-saldo-zerado as logical                 no-undo.
def var l-sdo-zerado   as logical                 no-undo.
def var c-lote         like saldo-estoq.lote      no-undo.
def var c-lote_ini     like saldo-estoq.lote      no-undo.
def var c-item_ini     like saldo-estoq.it-codigo no-undo.
def var c-item_fim     like saldo-estoq.it-codigo no-undo.
def var c-lote_fim     like saldo-estoq.lote      no-undo.
def var c-cod-localiz  as char                    no-undo.
def var c-depo_ini     as char                    no-undo.
def var c-depo_fim     as char                    no-undo.
def var c-loca_ini     as char                    no-undo.
def var c-loca_fim     as char                    no-undo.
def var dt-vali_ini    as date                    no-undo.
def var dt-vali_fim    as date                    no-undo.
def var d-qtde_ini     as dec                     no-undo.
def var d-qtde_fim     as dec                     no-undo.
def var de-qtidade     like saldo-estoq.qtidade-atu no-undo.
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
  def var l-lote-avancado as log    no-undo.
  def var h-ceapi030      as handle no-undo.
  def var l-retorno       as log    no-undo.

  {cep/ceapi030.i}
  {cdp/cd0666.i}

  if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                           funcao.ativo) then do:
      assign l-lote-avancado = yes.

      if not valid-handle(h-ceapi030) then
          run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                        output table tt-valores,
                                                        output table tt-erro).
  end.
&endif
 
procedure setConstraint1:
	def input parameter p-it-codigo as char.
	def input parameter p-cod-refer as char.
	def input parameter p-cod-estabel as char. 
	assign c-it-codigo = p-it-codigo
		c-cod-refer = p-cod-refer
		c-cod-estabel = p-cod-estabel.
end procedure.

procedure setConstraint3:

  def input parameter r-chave          as rowid no-undo.
  def input parameter p-l-saldo-zerado as log   no-undo.
  
  assign l-saldo-zerado = p-l-saldo-zerado.
  
  find first saldo-estoq where 
       rowid(saldo-estoq) = r-chave
       no-lock no-error.
  if avail saldo-estoq then
    assign c-lote = saldo-estoq.lote.
      
end procedure.

procedure setConstraint4:
  def input parameter r-chave as rowid no-undo.
  def input parameter p-l-sdo-zerado as logical no-undo.
  assign l-sdo-zerado = p-l-sdo-zerado.
  find first estabelec where 
             rowid(estabelec) = r-chave no-lock no-error.
  if avail estabelec then
     assign c-cod-estabel = estabelec.cod-estabel.            
end procedure.

procedure setConstraint5:
  def input parameter r-item as rowid no-undo.
  def input parameter p-l-saldo-zerado as logical no-undo.
  
  assign l-saldo-zerado = p-l-saldo-zerado.
  
  find item where rowid(item) = r-item no-lock no-error.
  
end procedure.

procedure setConstraint6:
  def input parameter p-lote_ini as char no-undo.
  def input parameter p-lote_fim as char no-undo.
  def input parameter p-item_ini as char no-undo.
  def input parameter p-item_fim as char no-undo.  
  assign c-lote_ini = p-lote_ini
         c-lote_fim = p-lote_fim
         c-item_ini = p-item_ini
         c-item_fim = p-item_fim.
  
end procedure.

procedure setConstraint7:
  def input parameter p-cod-localiz  as char no-undo.
  def input parameter p-saldo-zerado as log  no-undo.
  
  assign l-saldo-zerado = p-saldo-zerado
         c-cod-localiz  = p-cod-localiz. 
end procedure.

procedure setConstraint12:

  def input parameter p-item_ini as char no-undo.
  def input parameter p-item_fim as char no-undo.
  def input parameter p-depo_ini as char no-undo.
  def input parameter p-depo_fim as char no-undo.
  def input parameter p-loca_ini as char no-undo.
  def input parameter p-loca_fim as char no-undo.
  def input parameter p-lote_ini as char no-undo.
  def input parameter p-lote_fim as char no-undo.
  def input parameter p-vali_ini as date no-undo.
  def input parameter p-vali_fim as date no-undo.
  def input parameter p-qtde_ini as deci no-undo.
  def input parameter p-qtde_fim as deci no-undo.
    
  assign c-lote_ini  = p-lote_ini
         c-lote_fim  = p-lote_fim
         c-item_ini  = p-item_ini
         c-item_fim  = p-item_fim
         c-loca_ini  = p-loca_ini
         c-loca_fim  = p-loca_fim
         c-depo_ini  = p-depo_ini
         c-depo_fim  = p-depo_fim
         dt-vali_ini = p-vali_ini
         dt-vali_fim = p-vali_fim
         d-qtde_ini  = p-qtde_ini
         d-qtde_fim  = p-qtde_fim.

end procedure.

procedure setConstraint13:
  DEF INPUT PARAMETER p-cod-estabel   AS CHAR  NO-UNDO.
  def input parameter p-cod-depos     as char  no-undo.
  def input parameter p-saldo-zero    as LOG  no-undo.
  def input parameter p-it-codigo-ini as char  no-undo.
  def input parameter p-it-codigo-fim as char  no-undo.

  assign c-cod-estabel  = p-cod-estabel
         c-cod-depos    = p-cod-depos         
         l-saldo-zerado = p-saldo-zero
         c-item_ini     = p-it-codigo-ini
         c-item_fim     = p-it-codigo-fim.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} 
                 for each  {&TABLE-NAME} no-lock
                     where {&TABLE-NAME}.cod-estabel = c-cod-estabel
				       and {&table-name}.it-codigo = c-it-codigo
					   and {&TABLE-NAME}.cod-refer = c-cod-refer
                       and {&TABLE-NAME}.qtidade-atu > 0 INDEXED-REPOSITION. 
	when 2 then
  	     open query {&QUERY-NAME} for each {&TABLE-NAME} 
                                     where {&TABLE-NAME}.lote > "" NO-LOCK
                                     use-index lote INDEXED-REPOSITION.
       when 3 then do:
            if l-saldo-zerado then
            open query {&QUERY-NAME} for each {&TABLE-NAME} 
                                     WHERE {&TABLE-NAME}.lote        = c-lote NO-LOCK INDEXED-REPOSITION.
            else
            open query {&QUERY-NAME} for each {&TABLE-NAME} 
                                     WHERE {&TABLE-NAME}.lote        = c-lote 
                                     and   {&TABLE-NAME}.qtidade-atu > 0      NO-LOCK INDEXED-REPOSITION.
       end.
       when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} 
                                     WHERE {&TABLE-NAME}.cod-estabel = c-cod-estabel  /*estabelec.cod-estabel*/
                                     AND ((l-sdo-zerado = no and saldo-estoq.qtidade-atu > 0 )  
                                      OR  (l-sdo-zerado = yes)) NO-LOCK INDEXED-REPOSITION.
       when 5 then
            open query {&QUERY-NAME} for EACH saldo-estoq OF item 
                                    WHERE ((not l-saldo-zerado and saldo-estoq.qtidade-atu <> 0 ) or
                                           (l-saldo-zerado = yes)) NO-LOCK by saldo-estoq.cod-estabel INDEXED-REPOSITION.                              
       when 6 then
            open query {&QUERY-NAME} for EACH saldo-estoq OF item 
                                    WHERE ((not l-saldo-zerado and saldo-estoq.qtidade-atu <> 0 ) or
                                           (l-saldo-zerado = yes)) NO-LOCK by saldo-estoq.cod-depos INDEXED-REPOSITION.
                             
       when 7 then
  	     OPEN QUERY {&QUERY-NAME} FOR EACH  {&TABLE-NAME} 
  	                                  WHERE {&TABLE-NAME}.lote > "" 
                                        AND {&TABLE-NAME}.lote >= c-lote_ini
                                        AND {&TABLE-NAME}.lote <= c-lote_fim
                                        AND {&table-name}.it-codigo >= c-item_ini
                                        AND {&table-name}.it-codigo <= c-item_fim NO-LOCK                                           
                                      BY {&TABLE-NAME}.lote INDEXED-REPOSITION.
       when 8 then
  	     OPEN QUERY {&QUERY-NAME} FOR EACH  {&TABLE-NAME} 
  	                                  WHERE {&TABLE-NAME}.lote > "" 
                                        AND {&TABLE-NAME}.lote >= c-lote_ini
                                        AND {&TABLE-NAME}.lote <= c-lote_fim  	                              
                                        AND {&table-name}.it-codigo >= c-item_ini
                                        AND {&table-name}.it-codigo <= c-item_fim NO-LOCK
                                      BY {&table-name}.it-codigo
                                      BY {&TABLE-NAME}.cod-estabel
                                      BY {&TABLE-NAME}.lote INDEXED-REPOSITION.
       when 9 then
  	     open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE                                            
                                              {&TABLE-NAME}.cod-localiz = c-cod-localiz              AND
                                             ((not l-saldo-zerado and {&TABLE-NAME}.qtidade-atu > 0) OR
                                             (l-saldo-zerado = yes)) NO-LOCK USE-INDEX estabel-dep INDEXED-REPOSITION. 
       when 10 then
  	     open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE                                            
                                              {&TABLE-NAME}.cod-localiz = c-cod-localiz              AND
                                             ((not l-saldo-zerado and {&TABLE-NAME}.qtidade-atu > 0) OR
                                             (l-saldo-zerado = yes)) NO-LOCK USE-INDEX dep-estabel INDEXED-REPOSITION. 
       when 11 then
  	     open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE                                            
                                              {&TABLE-NAME}.cod-localiz = c-cod-localiz              AND
                                             ((not l-saldo-zerado and {&TABLE-NAME}.qtidade-atu > 0) OR
                                             (l-saldo-zerado = yes)) NO-LOCK USE-INDEX localizacao INDEXED-REPOSITION.  
       when 12 then
  	     open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE
  	                                         {&table-name}.it-codigo   >= c-item_ini
                                           AND  {&table-name}.it-codigo   <= c-item_fim
                                           AND  {&TABLE-NAME}.lote        >= c-lote_ini
                                           AND  {&TABLE-NAME}.lote        <= c-lote_fim
                                           AND  {&TABLE-NAME}.cod-localiz >= c-loca_ini
                                           AND  {&TABLE-NAME}.cod-localiz <= c-loca_fim
                                           AND  {&TABLE-NAME}.cod-depos   >= c-depo_ini                                           
                                           AND  {&TABLE-NAME}.cod-depos   <= c-depo_fim 
                                           AND  {&TABLE-NAME}.dt-vali-lote>= dt-vali_ini
                                           AND  {&TABLE-NAME}.dt-vali-lote<= dt-vali_fim
                                           AND  {&TABLE-NAME}.qtidade-atu <> 0
                                           AND  {&TABLE-NAME}.qtidade-atu >= d-qtde_ini
                                           AND  {&TABLE-NAME}.qtidade-atu <= d-qtde_fim NO-LOCK
                                           BY   {&table-name}.it-codigo INDEXED-REPOSITION.           
       when 13 then
  	     open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE
  	                                         {&table-name}.it-codigo   >= c-item_ini
                                           AND  {&table-name}.it-codigo   <= c-item_fim
                                           AND  {&TABLE-NAME}.lote        >= c-lote_ini
                                           AND  {&TABLE-NAME}.lote        <= c-lote_fim
                                           AND  {&TABLE-NAME}.cod-localiz >= c-loca_ini
                                           AND  {&TABLE-NAME}.cod-localiz <= c-loca_fim
                                           AND  {&TABLE-NAME}.cod-depos   >= c-depo_ini                                           
                                           AND  {&TABLE-NAME}.cod-depos   <= c-depo_fim 
                                           AND  {&TABLE-NAME}.dt-vali-lote>= dt-vali_ini
                                           AND  {&TABLE-NAME}.dt-vali-lote<= dt-vali_fim
                                           AND  {&TABLE-NAME}.qtidade-atu <> 0
                                           AND  {&TABLE-NAME}.qtidade-atu >= d-qtde_ini
                                           AND  {&TABLE-NAME}.qtidade-atu <= d-qtde_fim NO-LOCK
                                           BY   {&TABLE-NAME}.lote INDEXED-REPOSITION.
       when 14 then
  	     open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE
  	                                         {&table-name}.it-codigo   >= c-item_ini
                                           AND  {&table-name}.it-codigo   <= c-item_fim
                                           AND  {&TABLE-NAME}.lote        >= c-lote_ini
                                           AND  {&TABLE-NAME}.lote        <= c-lote_fim
                                           AND  {&TABLE-NAME}.cod-localiz >= c-loca_ini
                                           AND  {&TABLE-NAME}.cod-localiz <= c-loca_fim
                                           AND  {&TABLE-NAME}.cod-depos   >= c-depo_ini                                           
                                           AND  {&TABLE-NAME}.cod-depos   <= c-depo_fim 
                                           AND  {&TABLE-NAME}.dt-vali-lote>= dt-vali_ini
                                           AND  {&TABLE-NAME}.dt-vali-lote<= dt-vali_fim
                                           AND  {&TABLE-NAME}.qtidade-atu <> 0
                                           AND  {&TABLE-NAME}.qtidade-atu >= d-qtde_ini
                                           AND  {&TABLE-NAME}.qtidade-atu <= d-qtde_fim NO-LOCK
                                           BY   {&TABLE-NAME}.cod-localiz INDEXED-REPOSITION.    
       when 15 then
  	     open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE
  	                                         {&table-name}.it-codigo   >= c-item_ini
                                           AND  {&table-name}.it-codigo   <= c-item_fim
                                           AND  {&TABLE-NAME}.lote        >= c-lote_ini
                                           AND  {&TABLE-NAME}.lote        <= c-lote_fim
                                           AND  {&TABLE-NAME}.cod-localiz >= c-loca_ini
                                           AND  {&TABLE-NAME}.cod-localiz <= c-loca_fim
                                           AND  {&TABLE-NAME}.cod-depos   >= c-depo_ini                                           
                                           AND  {&TABLE-NAME}.cod-depos   <= c-depo_fim 
                                           AND  {&TABLE-NAME}.dt-vali-lote>= dt-vali_ini
                                           AND  {&TABLE-NAME}.dt-vali-lote<= dt-vali_fim
                                           AND  {&TABLE-NAME}.qtidade-atu <> 0
                                           AND  {&TABLE-NAME}.qtidade-atu >= d-qtde_ini
                                           AND  {&TABLE-NAME}.qtidade-atu <= d-qtde_fim NO-LOCK
                                           BY   {&TABLE-NAME}.cod-depos INDEXED-REPOSITION.   
       when 16 then
  	     open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE
  	                                         {&table-name}.it-codigo   >= c-item_ini
                                           AND  {&table-name}.it-codigo   <= c-item_fim
                                           AND  {&TABLE-NAME}.lote        >= c-lote_ini
                                           AND  {&TABLE-NAME}.lote        <= c-lote_fim
                                           AND  {&TABLE-NAME}.cod-localiz >= c-loca_ini
                                           AND  {&TABLE-NAME}.cod-localiz <= c-loca_fim
                                           AND  {&TABLE-NAME}.cod-depos   >= c-depo_ini                                           
                                           AND  {&TABLE-NAME}.cod-depos   <= c-depo_fim 
                                           AND  {&TABLE-NAME}.dt-vali-lote>= dt-vali_ini
                                           AND  {&TABLE-NAME}.dt-vali-lote<= dt-vali_fim
                                           AND  {&TABLE-NAME}.qtidade-atu <> 0
                                           AND  {&TABLE-NAME}.qtidade-atu >= d-qtde_ini
                                           AND  {&TABLE-NAME}.qtidade-atu <= d-qtde_fim NO-LOCK
                                           BY   {&TABLE-NAME}.dt-vali-lote INDEXED-REPOSITION.
       when 17 then
  	     open query {&QUERY-NAME} for each {&TABLE-NAME} WHERE
  	                                         {&table-name}.it-codigo   >= c-item_ini
                                           AND  {&table-name}.it-codigo   <= c-item_fim
                                           AND  {&TABLE-NAME}.lote        >= c-lote_ini
                                           AND  {&TABLE-NAME}.lote        <= c-lote_fim
                                           AND  {&TABLE-NAME}.cod-localiz >= c-loca_ini
                                           AND  {&TABLE-NAME}.cod-localiz <= c-loca_fim
                                           AND  {&TABLE-NAME}.cod-depos   >= c-depo_ini                                           
                                           AND  {&TABLE-NAME}.cod-depos   <= c-depo_fim 
                                           AND  {&TABLE-NAME}.dt-vali-lote>= dt-vali_ini
                                           AND  {&TABLE-NAME}.dt-vali-lote<= dt-vali_fim
                                           AND  {&TABLE-NAME}.qtidade-atu <> 0
                                           AND  {&TABLE-NAME}.qtidade-atu >= d-qtde_ini
                                           AND  {&TABLE-NAME}.qtidade-atu <= d-qtde_fim NO-LOCK
                                           BY   {&TABLE-NAME}.qtidade-atu INDEXED-REPOSITION.                                                                             
        when 18 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 19 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                  where {&TABLE-NAME}.cod-estabel = c-cod-estabel
                                    and {&table-name}.it-codigo   = c-it-codigo INDEXED-REPOSITION.
        when 20 then
            open query {&QUERY-NAME} FOR EACH {&TABLE-NAME} no-lock WHERE 
                                              {&TABLE-NAME}.cod-estabel =  c-cod-estabel   AND
                                              {&TABLE-NAME}.cod-depos   =  c-cod-depos     AND
                                              {&table-name}.it-codigo   >= c-item_ini AND
                                              {&table-name}.it-codigo   <= c-item_fim AND
                                              (({&TABLE-NAME}.qtidade-atu > 0 AND NOT l-saldo-zerado) OR
                                               l-saldo-zerado)
                                              by {&table-name}.it-codigo INDEXED-REPOSITION.     
    end case. 
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
{include/boexeupt.i}
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure findDep_estabel:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-depos as char no-undo.
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-cod-localiz as char no-undo.
    def input parameter c-lote as char no-undo.
    def input parameter c-it-codigo as char no-undo.
    def input parameter c-cod-refer as char no-undo.
    def output parameter c-return as char no-undo.
 
    find saldo-estoq where
        saldo-estoq.cod-depos = c-cod-depos
        and saldo-estoq.cod-estabel = c-cod-estabel
        and saldo-estoq.cod-localiz = c-cod-localiz
        and saldo-estoq.lote = c-lote
        and saldo-estoq.it-codigo = c-it-codigo
        and saldo-estoq.cod-refer = c-cod-refer
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movind {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
    run endMethod ("find").
end procedure.

procedure findEstabel_dep:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-cod-depos as char no-undo.
    def input parameter c-cod-localiz as char no-undo.
    def input parameter c-lote as char no-undo.
    def input parameter c-it-codigo as char no-undo.
    def input parameter c-cod-refer as char no-undo.
    def output parameter c-return as char no-undo.
 
    find saldo-estoq where
        saldo-estoq.cod-estabel = c-cod-estabel
        and saldo-estoq.cod-depos = c-cod-depos
        and saldo-estoq.cod-localiz = c-cod-localiz
        and saldo-estoq.lote = c-lote
        and saldo-estoq.it-codigo = c-it-codigo
        and saldo-estoq.cod-refer = c-cod-refer
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movind {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
    run endMethod ("find").
end procedure.

Procedure findSaldoEstoq:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").

    def input  parameter c-cod-estabel as char no-undo.
    def input  parameter c-cod-depos   as char no-undo.
    def input  parameter c-cod-localiz as char no-undo.
    def input  parameter c-lote        as char no-undo.
    def input  parameter c-it-codigo   as char no-undo.
    def output parameter c-return      as char no-undo.
    
    find first saldo-estoq use-index estabel-dep where
         saldo-estoq.cod-estabel = c-cod-estabel  and
         saldo-estoq.cod-depos   = c-cod-depos    and
         saldo-estoq.cod-localiz = c-cod-localiz  and
         saldo-estoq.lote        = c-lote         and
         saldo-estoq.it-codigo   = c-it-codigo  
         no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movind {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
    run endMethod ("find").

end procedure.

procedure findDep_lote:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-lote as char no-undo.
    def output parameter c-return as char no-undo.
 
    find first saldo-estoq where
               saldo-estoq.lote = c-lote
               no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movind {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
    run endMethod ("find").
end procedure.

procedure findLoteItem:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-lote    as char no-undo.
    def input parameter c-item    as char no-undo.
    def output parameter c-return as char no-undo.
 
    find first saldo-estoq 
        where saldo-estoq.lote      = c-lote
          and saldo-estoq.it-codigo = c-item no-lock no-error.
    if  not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movind {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
        run setCurrent.
    end.
    run endMethod ("find").
end procedure.
  
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-depos = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-depos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estabel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-localiz = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-localiz 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-refer = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-refer 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.concentracao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} concentracao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.it-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} it-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.lote = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} lote 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtidade-atu = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtidade-atu 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtidade-fin = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtidade-fin 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtidade-ini = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtidade-ini 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.rendimento = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} rendimento 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    run endMethod ("validateFields").
 
end procedure.
 
procedure validateCreate:
    /*
    **  Valida criaá∆o da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
 
    run initializeValidate.
    run startMethod ("validateCreate").
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    run validateFields.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find saldo-estoq where
            saldo-estoq.cod-depos = rowObject.cod-depos
        and saldo-estoq.cod-estabel = rowObject.cod-estabel
        and saldo-estoq.cod-localiz = rowObject.cod-localiz
        and saldo-estoq.lote = rowObject.lote
        and saldo-estoq.it-codigo = rowObject.it-codigo
        and saldo-estoq.cod-refer = rowObject.cod-refer
            no-lock no-error.
        if avail saldo-estoq then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movind {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
        else do:
             run executeCreate.
             assign r-chave = to-rowid(return-value).
        end.
    end.
 
    run endMethod ("validateCreate").
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "cd-referencia" then c-value = RowObject.cd-referencia.
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-depos" then c-value = RowObject.cod-depos.
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "cod-localiz" then c-value = RowObject.cod-localiz.
        when "cod-refer" then c-value = RowObject.cod-refer.
        when "it-codigo" then c-value = RowObject.it-codigo.
        when "lote" then c-value = RowObject.lote.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "concentracao" then c-value = RowObject.concentracao.
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "qt-aloc-ped" then c-value = RowObject.qt-aloc-ped.
        when "qt-aloc-prod" then c-value = RowObject.qt-aloc-prod.
        when "qt-alocada" then c-value = RowObject.qt-alocada.
        when "qtidade-atu" then c-value = RowObject.qtidade-atu.
        when "qtidade-fin" then c-value = RowObject.qtidade-fin.
        when "qtidade-ini" then c-value = RowObject.qtidade-ini.
        when "rendimento" then c-value = RowObject.rendimento.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "data-ult-ent" then c-value = RowObject.data-ult-ent.
        when "dt-fabric" then c-value = RowObject.dt-fabric.
        when "dt-ul-contag" then c-value = RowObject.dt-ul-contag.
        when "dt-vali-lote" then c-value = RowObject.dt-vali-lote.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.
 
procedure getSaldoAtual:

   /* 
   Retorna o saldo atual do item disponivel no estoque, por deposito, localizacao e lote. 
   Par‚metros:
   ipar1 : rowid do registro do item do pedido de venda
   opar2 : tabela com os saldos por deposito, localizacao e lote
   */
   
   def input parameter ipar1 as rowid.
   def output parameter /* opar2 */ table for tt-saldo-por-deposito.

   find ped-item no-lock where rowid(ped-item) = ipar1 no-error.
   find ped-venda of ped-item no-lock no-error.

   for each  saldo-estoq no-lock
      where saldo-estoq.cod-estabel = ped-venda.cod-estabel
      and saldo-estoq.it-codigo   = ped-item.it-codigo
      and saldo-estoq.cod-refer   = ped-item.cod-refer,
      first deposito no-lock
      where deposito.cod-depos = saldo-estoq.cod-depos
      and   deposito.ind-acabado:

      &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        assign l-retorno = yes.

        find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
        if l-lote-avancado and
           avail item and
           item.tipo-con-est > 2 then do:

            run pi-identifica-saldo in h-ceapi030 (input 1,
                                                   input saldo-estoq.it-codigo,
                                                   input saldo-estoq.cod-estabel,
                                                   input saldo-estoq.lote,
                                                   input 0,
                                                   output l-retorno,
                                                   output table tt-valores2,
                                                   output table tt-erro).

        end.

        if not l-retorno then
            assign de-qtidade = 0.
        else
      &endif

        assign de-qtidade = saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-ped + saldo-estoq.qt-aloc-prod).

		create tt-saldo-por-deposito.
		assign tt-saldo-por-deposito.cod-estabel = saldo-estoq.cod-estabel
				 tt-saldo-por-deposito.cod-depos = saldo-estoq.cod-depos
				 tt-saldo-por-deposito.cod-localiz = saldo-estoq.cod-localiz
				 tt-saldo-por-deposito.lote = saldo-estoq.lote
				 tt-saldo-por-deposito.qt-saldo = de-qtidade.
	end.

end procedure.

procedure retornaSaldosEstoque:
    /*
    Calcula e retorna saldos em estoque 
    ParÉmetros:
    ipar1: r-item          : Rowid da tabela Item
    ipar2: da-dt-transacao : Data inicial da transaá∆o
    opar3: d-tot-dispon°vel: Saldo total dispon°vel
    opar4: d-tot-saldo-calc: Total do saldo calculado
    */
    
    def input  parameter r-item           as rowid   no-undo.
    def input  parameter da-dt-transacao  as date    no-undo.
    def output parameter d-tot-disponivel as decimal no-undo.
    def output parameter d-tot-saldo-calc as decimal no-undo.
    
    def var c-return as char no-undo.
    
    find item where rowid(item) = r-item no-lock no-error.
    if avail item then do:
       assign d-tot-disponivel = 0
              d-tot-saldo-calc = 0.

       run findFirst.
       do while avail saldo-estoq:

          &if '{&bf_lote_avancado_liberado}' = 'yes' &then
            assign l-retorno = yes.
    
            find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
            if l-lote-avancado and
               avail item and
               item.tipo-con-est > 2 then do:
    
                run pi-identifica-saldo in h-ceapi030 (input 1,
                                                       input saldo-estoq.it-codigo,
                                                       input saldo-estoq.cod-estabel,
                                                       input saldo-estoq.lote,
                                                       input 0,
                                                       output l-retorno,
                                                       output table tt-valores2,
                                                       output table tt-erro).
    
            end.
    
            if not l-retorno then
                assign de-qtidade = 0.
            else
          &endif

            assign de-qtidade = (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped).

            assign d-tot-disponivel = d-tot-disponivel + de-qtidade
                   d-tot-saldo-calc = d-tot-saldo-calc + saldo-estoq.qtidade-atu.
        
            if item.tipo-con-est = 1 then do:
                 for each movto-estoq use-index item-data where
                          movto-estoq.it-codigo = saldo-estoq.it-codigo      and
                          movto-estoq.cod-refer = saldo-estoq.cod-refer      and
                          movto-estoq.cod-estabel = saldo-estoq.cod-estabel  and
                          movto-estoq.cod-depos  = saldo-estoq.cod-depos     and
                          movto-estoq.lote = saldo-estoq.lote                and
                          movto-estoq.cod-localiz = saldo-estoq.cod-localiz  and
                          movto-estoq.esp-docto <> 37 and
                          movto-estoq.dt-trans > da-dt-transacao no-lock:
                    if movto-estoq.tipo-trans = 1 then
                        assign d-tot-saldo-calc = d-tot-saldo-calc - movto-estoq.quantidade.
                    else
                        assign d-tot-saldo-calc = d-tot-saldo-calc + movto-estoq.quantidade.
                 end. 
            end. 
            else do:
                 for each movto-estoq use-index item-estab where
                          movto-estoq.it-codigo = saldo-estoq.it-codigo      and
                          movto-estoq.cod-refer = saldo-estoq.cod-refer      and
                          movto-estoq.cod-estabel = saldo-estoq.cod-estabel  and
                          movto-estoq.cod-depos  = saldo-estoq.cod-depos     and
                          movto-estoq.lote = saldo-estoq.lote                and
                          movto-estoq.cod-localiz = saldo-estoq.cod-localiz  and
                          movto-estoq.esp-docto <> 37 and
                          movto-estoq.dt-trans > da-dt-transacao no-lock:
                    if movto-estoq.tipo-trans = 1 then
                        assign d-tot-saldo-calc = d-tot-saldo-calc - movto-estoq.quantidade.
                    else
                        assign d-tot-saldo-calc = d-tot-saldo-calc + movto-estoq.quantidade.
                 end.
            end.
            run findNext (output c-return).
       end.
    end.
    
end procedure.

Procedure getRowidItem :

    /*
      Procura o rowid da tabela item a partir do c¢digo do item
      que vem da tabela saldo-estoq.
      Parametros :
      ipar1 : r-saldo-estoq : rowid do registro da tabela saldo-estoq
      opar2 : r-item        : rowid da tabela item
    */
    
    def input  param r-saldo-estoq as rowid no-undo.
    def output param r-item        as rowid no-undo.    

    find first saldo-estoq where
         rowid(saldo-estoq) = r-saldo-estoq 
         no-lock no-error.
    
    if avail saldo-estoq then do:
        find first item where
                   item.it-codigo = saldo-estoq.it-codigo
                   no-lock no-error.
         if avail item then
            assign r-item = rowid(item).
    end.
    
end.

procedure findPrevSaldoEstoque:

    /*
      Procedure com o objetivo de encontrar o registro anterior da 
      tabela saldo-estoq desde que seja o primeiro registro da tabela 
      com determinado cΩdigo (lote).
      Parametros:
      ipar1 : r-rowid  : rowid corrente da tabela saldo-estoq
      opar2 : c-return : retorna informaªío - Çltimo Registro da Tabela 
    */


    def input  parameter r-rowid  as rowid no-undo.
    def output parameter c-return as char  no-undo.
    
    def var c-cod-anterior as char no-undo.

    find first saldo-estoq where
         rowid(saldo-estoq) = r-rowid no-lock no-error.
 
    if  avail saldo-estoq then 
         assign c-cod-anterior = saldo-estoq.lote. 
  
    repeat while avail saldo-estoq:
        get prev {&query-name} no-lock.
        if  avail saldo-estoq then do:
            if  saldo-estoq.lote = c-cod-anterior then
                next.
            else do:
                run setCurrent.
                leave.
            end.
        end.
        else do:
            run utp/ut-msgs.p (input "msg",
                               input 7998,
                               input "").
            assign c-return = return-value .        
            get first {&query-name} no-lock.      
            leave.
        end.
    end.
end.

procedure findNextSaldoEstoque:

    /*
      Procedure com o objetivo de encontrar o prΩximo registro da 
      tabela saldo-estoq desde que seja o primeiro registro da tabela 
      com determinado cΩdigo (lote).
      Parametros:
      ipar1 : r-rowid  : rowid corrente da tabela saldo-estoq
      opar2 : c-return : retorna informaªío - Çltimo Registro da Tabela 
    */

    def input  parameter r-rowid  as rowid no-undo.
    def output parameter c-return as char  no-undo.
    
    def var c-cod-anterior as char no-undo.

    find first saldo-estoq where
         rowid(saldo-estoq) = r-rowid no-lock no-error.
 
    if  avail saldo-estoq then 
         assign c-cod-anterior = saldo-estoq.lote. 
  
    repeat while avail saldo-estoq:
        get next {&query-name} no-lock.
        if  avail saldo-estoq then do:
            if  saldo-estoq.lote = c-cod-anterior then
                next.
            else do:
                run setCurrent.
                leave.
            end.
        end.
        else do:
            run utp/ut-msgs.p (input "msg",
                               input 7999,
                               input "").
            assign c-return = return-value .       
            get last {&query-name} no-lock.      
            leave.
        end.
    end.
end.

procedure CalculaSaldoEstoqItem:
    define input  parameter p-it-codigo as char    no-undo.
    define output parameter de-saldo    as decimal no-undo.

    for each saldo-estoq
            where saldo-estoq.it-codigo = p-it-codigo no-lock,
            each deposito
            where deposito.cod-depos = saldo-estoq.cod-depos
              and deposito.alocado = yes no-lock:

       &if '{&bf_lote_avancado_liberado}' = 'yes' &then
         assign l-retorno = yes.
    
         find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
         if l-lote-avancado and
            avail item and
            item.tipo-con-est > 2 then do:
    
             run pi-identifica-saldo in h-ceapi030 (input 1,
                                                    input saldo-estoq.it-codigo,
                                                    input saldo-estoq.cod-estabel,
                                                    input saldo-estoq.lote,
                                                    input 0,
                                                    output l-retorno,
                                                    output table tt-valores2,
                                                    output table tt-erro).
    
         end.
    
         if l-retorno then
       &endif
        
         assign de-saldo = de-saldo
                         + (saldo-estoq.qtidade-atu
                         -  saldo-estoq.qt-alocada
                         -  saldo-estoq.qt-aloc-ped).
    end.
end procedure.

procedure retornaSaldoEstoqItem:

    define input  parameter p-cod-estabel as char    no-undo.
    define input  parameter p-it-codigo   as char    no-undo.
    define output parameter table for tt-saldo-estoq-aux.

    for each saldo-estoq where 
             saldo-estoq.cod-estabel = p-cod-estabel and
             saldo-estoq.it-codigo   = p-it-codigo no-lock:
             
        create tt-saldo-estoq-aux.
        buffer-copy saldo-estoq to tt-saldo-estoq-aux.
    end.

end procedure.

procedure retornaSaldoEstoqItemDep:

    define input  parameter p-cod-estabel as char    no-undo.
    define input  parameter p-cod-depos   as char    no-undo.
    define input  parameter p-it-codigo   as char    no-undo.
    define output parameter table for tt-saldo-estoq-aux.

    for each saldo-estoq use-index item
        where saldo-estoq.it-codigo   = p-it-codigo 
          and saldo-estoq.cod-estabel = p-cod-estabel 
        no-lock:
             
        if saldo-estoq.cod-depos <> p-cod-depos then next.
        
        create tt-saldo-estoq-aux.
        buffer-copy saldo-estoq to tt-saldo-estoq-aux.
        
    end.

end procedure.

procedure retornaQuantidadeData:
    /*
    Calcula e retorna quantidade 
    ParÉmetros:
    ipar1: r-item          : Rowid da tabela Item
    ipar2: r-saldo         : Rowid da tabela Saldo-estoq
    opar3: g-dt-saldo      : Data atual
    opar4: d-tot-saldo-calc: Quantidade calculada
    */

    define input  parameter r-item            as rowid   no-undo.
    define input  parameter r-saldo           as rowid   no-undo.
    define input  parameter g-dt-saldo        as char    no-undo.
    define output parameter d-saldo-calculado as decimal no-undo.

    define variable d-tot-disponivel as decimal no-undo.
    define variable d-tot-saldo-calc as decimal no-undo.
    define variable dt-saldo         as date    no-undo.
    

    find item where rowid(item) = r-item no-lock no-error.

    def buffer b-saldo-estoq for saldo-estoq.

    find b-saldo-estoq where rowid(b-saldo-estoq) = r-saldo no-lock no-error.

    assign d-tot-disponivel = 0
           d-tot-saldo-calc = 0
           dt-saldo = date(g-dt-saldo).

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    assign l-retorno = yes.

    if l-lote-avancado and
       avail item and
       item.tipo-con-est > 2 then do:

        run pi-identifica-saldo in h-ceapi030 (input 1,
                                               input b-saldo-estoq.it-codigo,
                                               input b-saldo-estoq.cod-estabel,
                                               input b-saldo-estoq.lote,
                                               input 0,
                                               output l-retorno,
                                               output table tt-valores2,
                                               output table tt-erro).

    end.

    if not l-retorno then
        assign de-qtidade = 0.
    else
  &endif

    assign de-qtidade = (b-saldo-estoq.qtidade-atu - b-saldo-estoq.qt-alocada -
                         b-saldo-estoq.qt-aloc-prod - b-saldo-estoq.qt-aloc-ped).

    assign d-tot-disponivel  = d-tot-disponivel + de-qtidade
           d-saldo-calculado = b-saldo-estoq.qtidade-atu.                                                 
    
    if item.tipo-con-est = 1 then do:
        for each movto-estoq use-index item-data where
                             movto-estoq.it-codigo   =  b-saldo-estoq.it-codigo    and
                             movto-estoq.cod-refer   =  b-saldo-estoq.cod-refer    and
                             movto-estoq.cod-estabel =  b-saldo-estoq.cod-estabel  and
                             movto-estoq.cod-depos   =  b-saldo-estoq.cod-depos    and
                             movto-estoq.lote        =  b-saldo-estoq.lote         and
                             movto-estoq.cod-localiz =  b-saldo-estoq.cod-localiz  and
                             movto-estoq.esp-docto   <> 37                         and
                             movto-estoq.dt-trans    >  dt-saldo no-lock:                                 
        if movto-estoq.tipo-trans = 1 then
            assign d-saldo-calculado = d-saldo-calculado - movto-estoq.quantidade.
        else
            assign d-saldo-calculado = d-saldo-calculado + movto-estoq.quantidade.
        end.
    end.
    else do:
        for each movto-estoq use-index item-estab where
                             movto-estoq.it-codigo   =  b-saldo-estoq.it-codigo    and
                             movto-estoq.cod-refer   =  b-saldo-estoq.cod-refer    and
                             movto-estoq.cod-estabel =  b-saldo-estoq.cod-estabel  and
                             movto-estoq.cod-depos   =  b-saldo-estoq.cod-depos    and
                             movto-estoq.lote        =  b-saldo-estoq.lote         and
                             movto-estoq.cod-localiz =  b-saldo-estoq.cod-localiz  and
                             movto-estoq.esp-docto   <> 37                         and
                             movto-estoq.dt-trans    >  dt-saldo no-lock:
        if movto-estoq.tipo-trans = 1 then
            assign d-saldo-calculado = d-saldo-calculado - movto-estoq.quantidade.
        else
            assign d-saldo-calculado = d-saldo-calculado + movto-estoq.quantidade.
       end.
    end.       
    
    assign d-tot-saldo-calc = d-tot-saldo-calc + d-saldo-calculado.

end procedure.

/****************  EMBALAGEM ********************************************/

procedure saldoEstoque:
    DEF INPUT  PARAM c-it-codigo like item.it-codigo.
    DEF INPUT  PARAM dt-saldo    like movto-estoq.dt-trans.
    DEF OUTPUT PARAM TABLE FOR tt-saldo-estoque.

    for each tt-saldo-estoque:
        delete tt-saldo-estoque.
    end.

    if dt-saldo = ? then
       assign dt-saldo = today.

    for each saldo-estoq where saldo-estoq.it-codigo  = c-it-codigo no-lock,
      first deposito where deposito.cod-depos = saldo-estoq.cod-depos
                      and (deposito.ind-processo = yes or deposito.ind-acabado = yes) no-lock,
        first movto-estoq where movto-estoq.it-codigo   = saldo-estoq.it-codigo
                            and movto-estoq.cod-estabel = saldo-estoq.cod-estabel
                            and movto-estoq.cod-refer   = saldo-estoq.cod-refer
                            and movto-estoq.dt-trans   <= dt-saldo no-lock:
        create tt-saldo-estoque.
        assign tt-saldo-estoque.cod-estabel = saldo-estoq.cod-estabel
               tt-saldo-estoque.cod-depos   = deposito.cod-depos
               tt-saldo-estoque.nome        = deposito.nome
               tt-saldo-estoque.qtidade-atu = saldo-estoq.qtidade-atu.
    end.

end procedure.

/******************************************************************/

    
/****************  WMS ********************************************/
procedure comparaSaldoWMS:

    DEF INPUT  PARAM pcod-item-ini    AS CHAR FORMAT "X(16)" NO-UNDO.
    DEF INPUT  PARAM pcod-item-fim    AS CHAR FORMAT "X(16)" NO-UNDO.
    DEF INPUT  PARAM pcod-familia-ini AS CHAR FORMAT "X(8)"  NO-UNDO.
    DEF INPUT  PARAM pcod-familia-fim AS CHAR FORMAT "X(8)"  NO-UNDO.
    
    DEF INPUT  PARAM pIntegraFamWMS   AS INT                 NO-UNDO.
    DEFINE VARIABLE i          AS INTEGER INITIAL 1  NO-UNDO.
    DEFINE VARIABLE j          AS INTEGER INITIAL 1  NO-UNDO.
    DEFINE VARIABLE cProgramName AS CHARACTER   NO-UNDO.
    
    &IF integer(entry(1,proversion,".")) >= 8 &THEN
        DEF INPUT  PARAM TABLE FOR tt-deposito.
        DEF OUTPUT PARAM TABLE FOR tt-erp-saldo-estoque.
    &ENDIF
    
    DO WHILE PROGRAM-NAME(i) <> ?:
        DO WHILE j < (LENGTH(PROGRAM-NAME(i)) - 6):
            IF SUBSTRING(PROGRAM-NAME(i), j, 6) = "WM0500":U THEN DO:
                ASSIGN cProgramName = "WM0500".
            END.
            j = j + 1.
        END.
        j = 1.
        i = i + 1.
    END.
        
    IF cProgramName = "WM0500" THEN DO:
        
        FOR EACH tt-deposito:

            FOR EACH saldo-estoq WHERE
                saldo-estoq.cod-estabel  = tt-deposito.cod-estabel  AND
                saldo-estoq.cod-depos    = tt-deposito.cod-deposito AND
               (saldo-estoq.it-codigo   >= pcod-item-ini            AND
                saldo-estoq.it-codigo   <= pcod-item-fim)           AND
                saldo-estoq.qtidade-atu <> 0                    
                NO-LOCK,
                EACH  item
                WHERE item.it-codigo   = saldo-estoq.it-codigo
                  AND((pIntegraFamWMS  = 1
                  AND item.fm-cod-com >= pcod-familia-ini
                  AND item.fm-cod-com <= pcod-familia-fim)
                   OR (pIntegraFamWMS  = 2
                  AND item.fm-codigo  >= pcod-familia-ini
                  AND item.fm-codigo  <= pcod-familia-fim))
                  NO-LOCK:
                FIND tt-erp-saldo-estoque WHERE
                     tt-erp-saldo-estoque.cod-estabel  = saldo-estoq.cod-estabel  AND
                     tt-erp-saldo-estoque.cod-deposito = saldo-estoq.cod-depos    AND
                     tt-erp-saldo-estoque.cod-item     = saldo-estoq.it-codigo    AND
                     tt-erp-saldo-estoque.cod-refer    = saldo-estoq.cod-refer    AND
                     tt-erp-saldo-estoque.cod-lote     = saldo-estoq.lote NO-ERROR.
        
                IF NOT AVAIL tt-erp-saldo-estoque THEN DO:
                      CREATE tt-erp-saldo-estoque.
                      ASSIGN tt-erp-saldo-estoque.cod-estabel      = saldo-estoq.cod-estabel            
                             tt-erp-saldo-estoque.cod-deposito     = tt-deposito.cod-deposito
                             tt-erp-saldo-estoque.cod-local        = tt-deposito.cod-local
                             tt-erp-saldo-estoque.cod-item         = saldo-estoq.it-codigo
                             tt-erp-saldo-estoque.cod-unid-med     = item.un
                             tt-erp-saldo-estoque.cod-refer        = saldo-estoq.cod-refer
                             tt-erp-saldo-estoque.cod-lote         = saldo-estoq.lote
                             tt-erp-saldo-estoque.dt-validade-lote = saldo-estoq.dt-vali-lote.
                END.            
        
                ASSIGN tt-erp-saldo-estoque.qtd-erp-saldo     =  tt-erp-saldo-estoque.qtd-erp-saldo
                                                              + saldo-estoq.qtidade-atu.

              &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                assign l-retorno = yes.
            
                if l-lote-avancado and
                   item.tipo-con-est > 2 then do:
            
                    run pi-identifica-saldo in h-ceapi030 (input 1,
                                                           input saldo-estoq.it-codigo,
                                                           input saldo-estoq.cod-estabel,
                                                           input saldo-estoq.lote,
                                                           input 0,
                                                           output l-retorno,
                                                           output table tt-valores2,
                                                           output table tt-erro).
            
                end.
            
                if l-retorno then
              &endif
                
              assign tt-erp-saldo-estoque.qtd-erp-liberada  =  tt-erp-saldo-estoque.qtd-erp-liberada
                                                              + (saldo-estoq.qtidade-atu
                                                              - (saldo-estoq.qt-aloc-ped 
                                                              +  saldo-estoq.qt-aloc-prod 
                                                              +  saldo-estoq.qt-alocada)). 
                
                IF  NOT AVAIL item-estab
                OR (item-estab.cod-estabel <> saldo-estoq.cod-estabel
                OR  item-estab.it-codigo   <> saldo-estoq.it-codigo) THEN DO:
    
                    FIND item-estab NO-LOCK 
                        WHERE item-estab.cod-estabel = saldo-estoq.cod-estabel
                          AND item-estab.it-codigo   = saldo-estoq.it-codigo NO-ERROR.
                END.
    
                &IF '{&bf_mat_versao_ems}' >= '2.042' &THEN
                    IF  NOT AVAIL estab-mat
                    OR  estab-mat.cod-estabel <> saldo-estoq.cod-estabel THEN
                        FIND estab-mat NO-LOCK
                            WHERE estab-mat.cod-estabel = saldo-estoq.cod-estabel NO-ERROR.
    
                    IF  estab-mat.custo-contab = 1 /* Mensal */ THEN
                        ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-estab.val-unit-mat-m[1] + 
                                                                       item-estab.val-unit-mob-m[1] + 
                                                                       item-estab.val-unit-ggf-m[1].
                    ELSE /* Custo On-line */
                        ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-estab.val-unit-mat-o[1] + 
                                                                       item-estab.val-unit-mob-o[1] + 
                                                                       item-estab.val-unit-ggf-o[1].
                &ELSE
                    IF  NOT AVAIL estabelec
                    OR  estabelec.cod-estabel <> saldo-estoq.cod-estabel THEN
                        FIND estabelec NO-LOCK
                            WHERE estabelec.cod-estabel = saldo-estoq.cod-estabel NO-ERROR.
    
                    CASE estabelec.custo-contab:
                        WHEN 1 THEN /* Mensal */
                            ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-estab.val-unit-mat-m[1] + 
                                                                           item-estab.val-unit-mob-m[1] + 
                                                                           item-estab.val-unit-ggf-m[1].
                        WHEN 2 THEN /* On-line */
                            ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-estab.val-unit-mat-o[1] + 
                                                                           item-estab.val-unit-mob-o[1] + 
                                                                           item-estab.val-unit-ggf-o[1].
                        OTHERWISE /* Padr∆o */
                            ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-estab.val-unit-mat-p[1] + 
                                                                           item-estab.val-unit-mob-p[1] + 
                                                                           item-estab.val-unit-ggf-p[1].
                    END CASE.
                &ENDIF
                
                IF  tt-erp-saldo-estoque.valor-unit-mat-m = 0 THEN DO:
    
                    FIND item-uni-estab NO-LOCK
                        WHERE item-uni-estab.cod-estabel = saldo-estoq.cod-estabel
                          AND item-uni-estab.it-codigo   = saldo-estoq.it-codigo NO-ERROR.
                    IF  AVAIL item-uni-estab THEN DO:
                        IF  item-uni-estab.preco-ul-ent <> 0 THEN
                            ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-uni-estab.preco-ul-ent.
                        ELSE
                            IF  item-uni-estab.preco-repos <> 0 THEN
                                ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-uni-estab.preco-repos.
                            ELSE
                                IF  item-uni-estab.preco-base <> 0 THEN
                                    ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-uni-estab.preco-base.
                                ELSE
                                    ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = 1.
                    END.
                END.
            END.
        END.
    END.
        ELSE DO:
              FOR EACH tt-deposito:

                  FOR EACH saldo-estoq WHERE
                      saldo-estoq.cod-estabel  = tt-deposito.cod-estabel  AND
                      saldo-estoq.cod-depos    = tt-deposito.cod-deposito AND
                     (saldo-estoq.it-codigo   >= pcod-item-ini            AND
                      saldo-estoq.it-codigo   <= pcod-item-fim)           AND
                      saldo-estoq.qtidade-atu > 0                   
                      NO-LOCK,
                      EACH  item
                      WHERE item.it-codigo   = saldo-estoq.it-codigo
                        AND((pIntegraFamWMS  = 1
                        AND item.fm-cod-com >= pcod-familia-ini
                        AND item.fm-cod-com <= pcod-familia-fim)
                         OR (pIntegraFamWMS  = 2
                        AND item.fm-codigo  >= pcod-familia-ini
                        AND item.fm-codigo  <= pcod-familia-fim))
                        NO-LOCK:
                      FIND tt-erp-saldo-estoque WHERE
                           tt-erp-saldo-estoque.cod-estabel  = saldo-estoq.cod-estabel  AND
                           tt-erp-saldo-estoque.cod-deposito = saldo-estoq.cod-depos    AND
                           tt-erp-saldo-estoque.cod-item     = saldo-estoq.it-codigo    AND
                           tt-erp-saldo-estoque.cod-refer    = saldo-estoq.cod-refer    AND
                           tt-erp-saldo-estoque.cod-lote     = saldo-estoq.lote NO-ERROR.
              
                      IF NOT AVAIL tt-erp-saldo-estoque THEN DO:
                            CREATE tt-erp-saldo-estoque.
                            ASSIGN tt-erp-saldo-estoque.cod-estabel      = saldo-estoq.cod-estabel            
                                   tt-erp-saldo-estoque.cod-deposito     = tt-deposito.cod-deposito
                                   tt-erp-saldo-estoque.cod-local        = tt-deposito.cod-local
                                   tt-erp-saldo-estoque.cod-item         = saldo-estoq.it-codigo
                                   tt-erp-saldo-estoque.cod-unid-med     = item.un
                                   tt-erp-saldo-estoque.cod-refer        = saldo-estoq.cod-refer
                                   tt-erp-saldo-estoque.cod-lote         = saldo-estoq.lote
                                   tt-erp-saldo-estoque.dt-validade-lote = saldo-estoq.dt-vali-lote.
                      END.            
              
                      ASSIGN tt-erp-saldo-estoque.qtd-erp-saldo     =  tt-erp-saldo-estoque.qtd-erp-saldo
                                                                    + saldo-estoq.qtidade-atu.

                    &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                      assign l-retorno = yes.
                    
                      if l-lote-avancado and
                         item.tipo-con-est > 2 then do:
                    
                          run pi-identifica-saldo in h-ceapi030 (input 1,
                                                                 input saldo-estoq.it-codigo,
                                                                 input saldo-estoq.cod-estabel,
                                                                 input saldo-estoq.lote,
                                                                 input 0,
                                                                 output l-retorno,
                                                                 output table tt-valores2,
                                                                 output table tt-erro).
                    
                      end.
                    
                      if l-retorno then
                    &endif

                      assign tt-erp-saldo-estoque.qtd-erp-liberada  =  tt-erp-saldo-estoque.qtd-erp-liberada
                                                                    + (saldo-estoq.qtidade-atu
                                                                    - (saldo-estoq.qt-aloc-ped 
                                                                    +  saldo-estoq.qt-aloc-prod 
                                                                    +  saldo-estoq.qt-alocada)). 
                        
                     IF tt-erp-saldo-estoque.qtd-erp-liberada < 0  THEN DO:
                          DELETE tt-erp-saldo-estoque.
                          NEXT.
                      END. 
                      
                      IF  NOT AVAIL item-estab
                      OR (item-estab.cod-estabel <> saldo-estoq.cod-estabel
                      OR  item-estab.it-codigo   <> saldo-estoq.it-codigo) THEN DO:
            
                          FIND item-estab NO-LOCK 
                              WHERE item-estab.cod-estabel = saldo-estoq.cod-estabel
                                AND item-estab.it-codigo   = saldo-estoq.it-codigo NO-ERROR.
                      END.
            
                      &IF '{&bf_mat_versao_ems}' >= '2.042' &THEN
                          IF  NOT AVAIL estab-mat
                          OR  estab-mat.cod-estabel <> saldo-estoq.cod-estabel THEN
                              FIND estab-mat NO-LOCK
                                  WHERE estab-mat.cod-estabel = saldo-estoq.cod-estabel NO-ERROR.
            
                          IF  estab-mat.custo-contab = 1 /* Mensal */ THEN
                              ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-estab.val-unit-mat-m[1] + 
                                                                             item-estab.val-unit-mob-m[1] + 
                                                                             item-estab.val-unit-ggf-m[1].
                          ELSE /* Custo On-line */
                              ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-estab.val-unit-mat-o[1] + 
                                                                             item-estab.val-unit-mob-o[1] + 
                                                                             item-estab.val-unit-ggf-o[1].
                      &ELSE
                          IF  NOT AVAIL estabelec
                          OR  estabelec.cod-estabel <> saldo-estoq.cod-estabel THEN
                              FIND estabelec NO-LOCK
                                  WHERE estabelec.cod-estabel = saldo-estoq.cod-estabel NO-ERROR.
            
                          CASE estabelec.custo-contab:
                              WHEN 1 THEN /* Mensal */
                                  ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-estab.val-unit-mat-m[1] + 
                                                                                 item-estab.val-unit-mob-m[1] + 
                                                                                 item-estab.val-unit-ggf-m[1].
                              WHEN 2 THEN /* On-line */
                                  ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-estab.val-unit-mat-o[1] + 
                                                                                 item-estab.val-unit-mob-o[1] + 
                                                                                 item-estab.val-unit-ggf-o[1].
                              OTHERWISE /* Padr∆o */
                                  ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-estab.val-unit-mat-p[1] + 
                                                                                 item-estab.val-unit-mob-p[1] + 
                                                                                 item-estab.val-unit-ggf-p[1].
                          END CASE.
                      &ENDIF
                      
                      IF  tt-erp-saldo-estoque.valor-unit-mat-m = 0 THEN DO:
            
                          FIND item-uni-estab NO-LOCK
                              WHERE item-uni-estab.cod-estabel = saldo-estoq.cod-estabel
                                AND item-uni-estab.it-codigo   = saldo-estoq.it-codigo NO-ERROR.
                          IF  AVAIL item-uni-estab THEN DO:
                              IF  item-uni-estab.preco-ul-ent <> 0 THEN
                                  ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-uni-estab.preco-ul-ent.
                              ELSE
                                  IF  item-uni-estab.preco-repos <> 0 THEN
                                      ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-uni-estab.preco-repos.
                                  ELSE
                                      IF  item-uni-estab.preco-base <> 0 THEN
                                          ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = item-uni-estab.preco-base.
                                      ELSE
                                          ASSIGN tt-erp-saldo-estoque.valor-unit-mat-m = 1.
                          END.
                      END.
                  END.
              END.
        END.

end procedure.

PROCEDURE getDataValidade:

    DEFINE INPUT  PARAMETER pCodEstabel   LIKE saldo-estoq.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pCodDeposito  LIKE saldo-estoq.cod-depos    NO-UNDO.
    DEFINE INPUT  PARAMETER pCodItem      LIKE saldo-estoq.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER pCodLote      LIKE saldo-estoq.lote         NO-UNDO.
    DEFINE INPUT  PARAMETER pCodRefer     LIKE saldo-estoq.cod-refer    NO-UNDO.
    DEFINE INPUT  PARAMETER pCodLocaliz   LIKE saldo-estoq.cod-localiz  NO-UNDO.
    DEFINE OUTPUT PARAMETER pDataValidade LIKE saldo-estoq.dt-vali-lote NO-UNDO.

    FIND FIRST saldo-estoq
         WHERE saldo-estoq.cod-estabel = pCodEstabel  AND
               saldo-estoq.cod-depos   = pCodDeposito AND
               saldo-estoq.cod-localiz = pCodLocaliz  AND
               saldo-estoq.lote        = pCodLote     AND
               saldo-estoq.it-codigo   = pCodItem     AND
               saldo-estoq.cod-refer   = pCodRefer    NO-LOCK NO-ERROR.

    IF AVAIL saldo-estoq THEN
        ASSIGN pDataValidade = saldo-estoq.dt-vali-lote.
    ELSE
        ASSIGN pDataValidade = ?.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE AlteraDataValidade:

&IF '{&mgscm_version}' >= '2.06B' &THEN    
    DEFINE INPUT  PARAM pItem    LIKE saldo-estoq.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAM pLote    LIKE saldo-estoq.lote         NO-UNDO.
    DEFINE INPUT  PARAM pDtValid LIKE saldo-estoq.dt-vali-lote NO-UNDO.

    def buffer b-saldo-estoq for saldo-estoq.

    FOR EACH b-saldo-estoq EXCLUSIVE-LOCK
        WHERE b-saldo-estoq.it-codigo = pItem
        AND   b-saldo-estoq.lote      = pLote:
        ASSIGN b-saldo-estoq.dt-vali-lote = pDtValid.
    END.                                          
    
    RETURN "OK":U.
&ENDIF

END PROCEDURE.



