/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD260 2.00.00.036} /*** "010036" 10/06/2025 09:30:37  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad260 MUT}
&ENDIF

/*
**  BOAD260.P
**
**  tit-ap - Documentos do Contas a Pagar
**
**  Ultima altera‡Æo : 07/05/99 - bre18759
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY tit-ap
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tit-ap
 
{include/boini.i}
 
{adbo/boad260.i RowObject}

/* Defini‡Æo de Temp-Tables relativas … APIs */
{app/ap0005b.i}   /* Defini‡Æo de tt-cod-barras */

def buffer b-tit-ap   for tit-ap.
def buffer b-emitente for emitente.
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
/**Defini‡Æo de Vari veis para o setConstraint3 **/
&IF "{&mguni_version}" >= "2.07A" &THEN
def var i-ep-codigo-usuario LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-ep-codigo-usuario as integer no-undo.
&ENDIF
def var c-bordero           as char    no-undo.
def var c-portador          as char    no-undo.

/**Defini‡Æo de Vari veis para o setConstraint2 **/
&IF "{&mguni_version}" >= "2.07A" &THEN
DEFINE VAR i-ep-cod-port    LIKE empresa.ep-codigo   NO-UNDO.
&ELSE
DEFINE VAR i-ep-cod-port    AS INTEGER   NO-UNDO.
&ENDIF
DEFINE VAR i-portador       AS INTEGER   NO-UNDO.
&IF "{&mguni_version}" >= "2.07A" &THEN
DEFINE VAR i-empresa        LIKE empresa.ep-codigo   NO-UNDO.
&ELSE
DEFINE VAR i-empresa        AS INTEGER   NO-UNDO.
&ENDIF
DEFINE VAR i-modalidade     AS INTEGER   NO-UNDO.
DEFINE VAR c-selecao        AS CHARACTER NO-UNDO.
DEFINE VAR r-chave          AS ROWID     NO-UNDO.
DEFINE VAR c-codigo         AS CHARACTER NO-UNDO.
&IF "{&mguni_version}" >= "2.07A" &THEN
DEFINE VAR ep-codigo        LIKE empresa.ep-codigo   NO-UNDO. 
&ELSE
DEFINE VAR ep-codigo        AS INTEGER   NO-UNDO. 
&ENDIF
DEFINE VAR cod-emit         AS INTEGER   NO-UNDO.
DEFINE VAR l-matriz         AS LOGICAL   NO-UNDO.
DEFINE VAR l-baixados       AS LOGICAL   NO-UNDO. 
DEFINE VAR cod-moeda        AS INTEGER   NO-UNDO.
DEFINE VAR dt-conversao     AS DATE      NO-UNDO.
DEFINE VAR cod-estab-ini    AS CHARACTER NO-UNDO.
DEFINE VAR cod-estab-fim    AS CHARACTER NO-UNDO.
DEFINE VAR cod-esp-ini      AS CHARACTER NO-UNDO.
DEFINE VAR cod-esp-fim      AS CHARACTER NO-UNDO.
DEFINE VAR cod-port-ini     AS INTEGER   NO-UNDO.
DEFINE VAR cod-port-fim     AS INTEGER   NO-UNDO.
DEFINE VAR dt-emissao-ini   AS DATE      NO-UNDO.
DEFINE VAR dt-emissao-fim   AS DATE      NO-UNDO.
DEFINE VAR c-cod-esp-ini    AS CHARACTER NO-UNDO.
DEFINE VAR c-cod-esp-fim    AS CHARACTER NO-UNDO.
DEFINE VAR dt-transacao-ini AS DATE      NO-UNDO.
DEFINE VAR dt-transacao-fim AS DATE      NO-UNDO.
DEFINE VAR dt-vencto-ini    AS DATE      NO-UNDO.
DEFINE VAR dt-vencto-fim    AS DATE      NO-UNDO.
DEFINE VAR l-aberto         AS LOGICAL   NO-UNDO.
DEFINE VAR c-cod-esp        AS CHAR      NO-UNDO.
DEFINE VAR i-cod-fornec-fim AS INTEGER   NO-UNDO.
DEFINE VAR c-cod-estabel-fim AS CHAR     NO-UNDO.
DEFINE VAR d-dt-venc-fim     AS DATE     NO-UNDO.
DEFINE VAR c-nr-docto-fim    AS CHAR     NO-UNDO.


/**
** Nova Tabela
** A Tabela tt documento e montada na boad260 conforme as inumeras
** possibilidades de criacao a tribuicao de valores. 
** Utilizada pelo programa de consulta Bordero - wap0812
**/
/* miniflexibiliza»’o */
  {include/i_dbvers.i}
  {cdp/cdcfgfin.i}

    def temp-table tt-documento 
        field cod-estabel   like tit-ap.cod-estabel
        field cod-esp       like tit-ap.cod-esp
        field serie         like tit-ap.serie
        field nr-docto      like tit-ap.nr-docto
        field parcela       like tit-ap.parcela
        field cod-fornec    like tit-ap.cod-fornec
        field referencia    like tit-ap.referencia
        field dt-transacao  like tit-ap.dt-transacao
        field valor-saldo   like tit-ap.valor-saldo
        field vl-original   like tit-ap.vl-original
        field vl-juros-dia  like tit-ap.vl-juros-dia
        &if defined(BF_FIN_MULTA_ABATIMENTO) &then
        field vl-multa      like tit-ap.vl-multa-tot
        field vl-abatimento like tit-ap.vl-abatimento-tot
        &endif
        field portador      like tit-ap.portador
        field lancamento    like tit-ap.lancamento
        field nome-abrev    like tit-ap.nome-abrev.  

/****************************************************************/




/**Defini‡Æo de Vari veis para o setConstraint4 **/
&IF "{&mguni_version}" >= "2.07A" &THEN
def var i-ep-codigo LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-ep-codigo as integer no-undo.
&ENDIF
def var c-docto-ini as char    no-undo.
def var c-docto-fim as char    no-undo.

/* Defini‡Æo de vari veis para setConstraint10 */
def var v-ext-perfil-usuar as char  no-undo.

procedure setConstraint3:
   def input parameter p-bordero           as char no-undo.
   def input parameter p-portador          as char no-undo. 
   def input parameter p-ep-codigo-usuario as char no-undo.
      assign &IF "{&mguni_version}" >= "2.07A" &THEN
             i-ep-codigo-usuario = p-ep-codigo-usuario
             &ELSE
             i-ep-codigo-usuario = int(p-ep-codigo-usuario)
             &ENDIF
             c-bordero  = p-bordero
             c-portador = p-portador.
end procedure.

procedure setConstraint2:
    /*
    * Carrega vari veis necess rias ao openQuery 2*
    */
    def input param p-chave as rowid.
    &IF "{&mguni_version}" >= "2.07A" &THEN
    def input param p-cod-port like empresa.ep-codigo no-undo.
    &ELSE
    def input param p-cod-port as int no-undo.
    &ENDIF
    def input param p-portador as int no-undo.
    def input param p-empresa as char no-undo.
    def input param p-modalidade as int no-undo.
    def input param p-c-esp-ini like tit-ap.cod-esp.
    def input param p-c-esp-fim like tit-ap.cod-esp.
    def input param p-da-data-ini like tit-ap.dt-transacao.
    def input param p-da-data-fim like tit-ap.dt-transacao.
    def input param p-da-ven-ini like tit-ap.dt-vencimen.
    def input param p-da-ven-fim like tit-ap.dt-vencimen.
    def input param p-l-aberto as logical no-undo.
    
   assign r-chave = p-chave
          i-ep-cod-port = p-cod-port
          i-portador = p-portador
          &IF "{&mguni_version}" >= "2.07A" &THEN
          i-empresa = p-empresa
          &ELSE
          i-empresa = int(p-empresa)
          &ENDIF
          i-modalidade = p-modalidade 
          c-cod-esp-ini = p-c-esp-ini
          c-cod-esp-fim = p-c-esp-fim
          dt-transacao-ini = p-da-data-ini
          dt-transacao-fim = p-da-data-fim
          dt-vencto-ini = p-da-ven-ini
          dt-vencto-fim = p-da-ven-fim
          l-aberto = p-l-aberto.
          
end procedure.
 
procedure setConstraint4:
def input parameter p-ep-codigo like empresa.ep-codigo.
def input parameter p-inicial   like tit-ap.nr-docto.
assign i-ep-codigo = p-ep-codigo
	   c-docto-ini = p-inicial.
   
end procedure.
 
procedure setConstraint5:
    def input parameter i-ep-codigo-usuario like empresa.ep-codigo.
	assign i-empresa = i-ep-codigo-usuario.
end procedure.

procedure setConstraint6:
	def input parameter p-rowid as rowid no-undo.
	find b-tit-ap where
		rowid(b-tit-ap) = p-rowid
		no-lock no-error.
end procedure.
 
procedure setConstraint7:
&IF "{&mguni_version}" >= "2.07A" &THEN
def input parameter p-cod-empresa-usuaria LIKE empresa.ep-codigo   no-undo.
&ELSE
def input parameter p-cod-empresa-usuaria as integer   no-undo.
&ENDIF
def input parameter p-cod-emitente        as integer   no-undo.
def input parameter p-l-tit-matriz        as logical   no-undo.
def input parameter p-l-tit-baixados      as logical   no-undo.
def input parameter p-i-moeda             as integer   no-undo.
def input parameter p-dt-conversao        as date      no-undo.
def input parameter p-cod-estab-ini       as character no-undo.
def input parameter p-cod-estab-fim       as character no-undo.
def input parameter p-cod-esp-ini         as character no-undo.
def input parameter p-cod-esp-fim         as character no-undo.
def input parameter p-cod-port-ini        as integer   no-undo.
def input parameter p-cod-port-fim        as integer   no-undo.
def input parameter p-dt-emissao-ini      as date      no-undo.
def input parameter p-dt-emissao-fim      as date      no-undo.

    assign ep-codigo      = p-cod-empresa-usuaria
           cod-emit       = p-cod-emitente
           l-matriz       = p-l-tit-matriz
           l-baixados     = p-l-tit-baixados
           cod-moeda      = p-i-moeda
           dt-conversao   = p-dt-conversao
           cod-estab-ini  = p-cod-estab-ini
           cod-estab-fim  = p-cod-estab-fim
           cod-esp-ini    = p-cod-esp-ini
           cod-esp-fim    = p-cod-esp-fim
           cod-port-ini   = p-cod-port-ini
           cod-port-fim   = p-cod-port-fim
           dt-emissao-ini = p-dt-emissao-ini
           dt-emissao-fim = p-dt-emissao-fim.
end procedure.


Procedure setConstraint8:
   /*** Carrega vari veis p/ o Open-query(8) ***/   
   def input parameter p-ep-codigo-usuar as char no-undo.
   def input parameter p-selecao as char no-undo.      
   assign c-selecao = p-selecao.     
   assign &IF "{&mguni_version}" >= "2.07A" &THEN
          i-ep-codigo = p-ep-codigo-usuar.
          &ELSE
          i-ep-codigo = int(p-ep-codigo-usuar).
          &ENDIF
          
end procedure.

def var i-cod-fornec  as int  no-undo.
def var c-cod-estabel as char no-undo.
def var d-dt-venc     as date no-undo.
def var c-nr-docto    as char no-undo.

procedure setConstraint9 :
def input parameter p-cod-fornec  as int no-undo.
def input parameter p-cod-estabel as char no-undo.
def input parameter p-dt-venc     as date no-undo.
def input parameter p-nr-docto    as char no-undo.
&IF "{&mguni_version}" >= "2.07A" &THEN
def input parameter p-ep-codigo   LIKE empresa.ep-codigo no-undo.
&ELSE
def input parameter p-ep-codigo   as int no-undo.
&ENDIF
def input parameter p-c-cod-esp   as char no-undo.

assign i-cod-fornec  = p-cod-fornec
       c-cod-estabel = p-cod-estabel
       d-dt-venc     = p-dt-venc
       c-nr-docto    = p-nr-docto
       i-ep-codigo   = p-ep-codigo
       c-cod-esp     = p-c-cod-esp.

end procedure.

procedure setConstraint10 :
def input parameter i-ep-codigo-usuario like empresa.ep-codigo.
def input parameter p-ext-perfil-usuario as char no-undo.

    assign i-empresa = i-ep-codigo-usuario
           v-ext-perfil-usuar     = p-ext-perfil-usuario.
end procedure.

procedure setConstraint11 :

def input parameter i-ep-codigo-usuario like empresa.ep-codigo.
def input parameter p-ext-perfil-usuario  as char no-undo.
def input parameter p-nr-docto            as char no-undo.
def input parameter p-cod-estabel         as char no-undo.
def input parameter p-dt-venc             as date no-undo.
def  input parameter p-c-cod-esp           as char no-undo.

    assign i-empresa          = i-ep-codigo-usuario
           v-ext-perfil-usuar = p-ext-perfil-usuario
           c-nr-docto         = p-nr-docto
           c-cod-estabel      = p-cod-estabel
           d-dt-venc          = p-dt-venc.
           c-cod-esp          = p-c-cod-esp.

end procedure.

procedure setConstraint12 :
def input parameter p-cod-fornec      as int no-undo.
def input parameter p-cod-fornec-fim  as int no-undo.
def input parameter p-cod-estabel     as char no-undo.
def input parameter p-cod-estabel-fim as char no-undo.
def input parameter p-dt-venc         as date no-undo.
def input parameter p-dt-venc-fim     as date no-undo.
def input parameter p-nr-docto        as char no-undo.
def input parameter p-nr-docto-fim    as char no-undo.
&IF "{&mguni_version}" >= "2.07A" &THEN
def input parameter p-ep-codigo       LIKE empresa.ep-codigo no-undo.
&ELSE
def input parameter p-ep-codigo       as int no-undo.
&ENDIF
def input parameter p-c-cod-esp       as char no-undo.
def input parameter p-c-cod-esp-fim   as char no-undo.

assign i-cod-fornec      = p-cod-fornec
       i-cod-fornec-fim  = p-cod-fornec-fim
       c-cod-estabel     = p-cod-estabel
       c-cod-estabel-fim = p-cod-estabel-fim
       d-dt-venc         = p-dt-venc
       d-dt-venc-fim     = p-dt-venc-fim
       c-nr-docto        = p-nr-docto
       c-nr-docto-fim    = p-nr-docto-fim
       i-ep-codigo       = p-ep-codigo
       c-cod-esp         = p-c-cod-esp
       c-cod-esp-fim     = p-c-cod-esp-fim.

end procedure.

procedure setConstraint16:
def input parameter p-ep-codigo like empresa.ep-codigo.
def input parameter p-inicial   like tit-ap.nr-docto.
def input parameter p-final     like tit-ap.nr-docto.

assign i-ep-codigo = p-ep-codigo
	   c-docto-ini = p-inicial
	   c-docto-fim = p-final.
   
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                        where tit-ap.ep-codigo      = i-ep-cod-port    and
                              tit-ap.portador       = i-portador       and 
                              tit-ap.modalidade     = i-modalidade     and 
                              tit-ap.ep-codigo      = i-empresa        and 
                              tit-ap.cod-esp       >= c-cod-esp-ini    and 
                              tit-ap.cod-esp       <= c-cod-esp-fim    and 
                              tit-ap.dt-transacao  >= dt-transacao-ini and  
                              tit-ap.dt-transacao  <= dt-transacao-fim and 
                              tit-ap.dt-vencimen   >= dt-vencto-ini    and 
                              tit-ap.dt-vencimen   <= dt-vencto-fim    and 
                              ((tit-ap.valor-saldo <> 0 and l-aberto = yes) or l-aberto = no) INDEXED-REPOSITION. 

        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                               where tit-ap.ep-codigo          = i-ep-codigo-usuario and   
                                     string(tit-ap.nr-bordero) = c-bordero           and  
                                     string(tit-ap.portador)   = c-portador INDEXED-REPOSITION.
       when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                               where tit-ap.ep-codigo   = i-ep-codigo and
                                     tit-ap.nr-docto   >= c-docto-ini and
                                    (tit-ap.tipo = 2 or tit-ap.tipo = 3) and
					   tit-ap.valor-saldo > 0 BY tit-ap.nr-docto 
                                                            BY tit-ap.parcela 
                                                            BY tit-ap.cod-estabel 
                                                            BY tit-ap.cod-esp 
                                                            BY tit-ap.cod-fornec INDEXED-REPOSITION.
       when 5 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                               where tit-ap.ep-codigo = i-empresa INDEXED-REPOSITION.
       when 6 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                              where tit-ap.ep-codigo    = b-tit-ap.ep-codigo   and 
                                    tit-ap.cod-estabel  = b-tit-ap.cod-estabel and 
                                    tit-ap.cod-esp      = b-tit-ap.cod-esp     and 
                                    tit-ap.serie        = b-tit-ap.serie       and 
                                    tit-ap.nr-docto     = b-tit-ap.nr-docto    and 
                                    tit-ap.parcela      = b-tit-ap.parcela     and 
                                    tit-ap.cod-fornec   = b-tit-ap.cod-fornec  and 
					 (tit-ap.tipo = 8 or tit-ap.tipo = 1) INDEXED-REPOSITION.
      when 7 then do:
          find emitente where emitente.cod-emitente = cod-emit no-lock no-error.
          if l-matriz = no then
                open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock  
                            where tit-ap.ep-codigo      = ep-codigo               
                            and   tit-ap.cod-fornec     = emitente.cod-emitente
                            and   tit-ap.cod-estabel   >= cod-estab-ini           
                            and   tit-ap.cod-estabel   <= cod-estab-fim           
                            and   tit-ap.cod-esp       >= cod-esp-ini             
                            and   tit-ap.cod-esp       <= cod-esp-fim             
                            and   tit-ap.portador      >= cod-port-ini            
                            and   tit-ap.portador      <= cod-port-fim            
                            and   tit-ap.dt-transacao  >= dt-emissao-ini          
                            and   tit-ap.dt-transacao  <= dt-emissao-fim          
                            and  (if l-baixados = yes then yes else tit-ap.vl-saldo-me <> 0)
                            and  (tit-ap.tipo = 1                               or 
                                  tit-ap.tipo = 2                               or
                                  tit-ap.tipo = 3                               or
                                  tit-ap.tipo = 7                               or
                                  tit-ap.tipo = 8                               or
                                  tit-ap.tipo = 10)
                                  by tit-ap.cod-estabel 
                                  by tit-ap.cod-fornec 
                                  by tit-ap.cod-esp
                                  by tit-ap.serie 
                                  by tit-ap.nr-docto INDEXED-REPOSITION.
          
          else
                open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock  
                            where tit-ap.ep-codigo      = ep-codigo  
                            and   tit-ap.matriz         = emitente.cod-emitente                                         
                            and   tit-ap.cod-estabel   >= cod-estab-ini           
                            and   tit-ap.cod-estabel   <= cod-estab-fim           
                            and   tit-ap.cod-esp       >= cod-esp-ini             
                            and   tit-ap.cod-esp       <= cod-esp-fim             
                            and   tit-ap.portador      >= cod-port-ini            
                            and   tit-ap.portador      <= cod-port-fim            
                            and   tit-ap.dt-transacao  >= dt-emissao-ini          
                            and   tit-ap.dt-transacao  <= dt-emissao-fim          
                            and  (if l-baixados = yes then yes else tit-ap.vl-saldo-me <> 0)
                            and  (tit-ap.tipo = 1                               or 
                                  tit-ap.tipo = 2                               or
                                  tit-ap.tipo = 3                               or
                                  tit-ap.tipo = 7                               or
                                  tit-ap.tipo = 8                               or
                                  tit-ap.tipo = 10)
                                  by tit-ap.cod-estabel 
                                  by tit-ap.cod-fornec 
                                  by tit-ap.cod-esp
                                  by tit-ap.serie 
                                  by tit-ap.nr-docto INDEXED-REPOSITION.          
     end.                       
     when 8 then
           open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock                                                                                 
                       where tit-ap.ep-codigo     = i-ep-codigo and
                             tit-ap.portador      = integer(entry(13, c-selecao)) and 
                             tit-ap.cod-estabel  >= entry(1, c-selecao)  and
                             tit-ap.cod-estabel  <= entry(2, c-selecao)  and
                             tit-ap.cod-esp      >= entry(3, c-selecao)  and 
                             tit-ap.cod-esp      <= entry(4, c-selecao)  and
                             tit-ap.nr-docto     >= entry(5, c-selecao)  and
                             tit-ap.nr-docto     <= entry(6, c-selecao)  and
                             tit-ap.dt-transacao >= date(entry(7, c-selecao)) and
                             tit-ap.dt-transacao <= date(entry(8, c-selecao)) and
                             tit-ap.dt-vencimen  >= date(entry(9, c-selecao)) and           
                             tit-ap.dt-vencimen  <= date(entry(10, c-selecao)) and
                             tit-ap.nr-bordero   >= integer(entry(11, c-selecao)) and
                             tit-ap.nr-bordero   <= integer(entry(12, c-selecao)) INDEXED-REPOSITION. 
                        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
     when 9 then
           open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock                                                                                  
                       where tit-ap.ep-codigo    =  i-ep-codigo
                       and   tit-ap.cod-estabel  >= c-cod-estabel
                       and   tit-ap.nr-docto     >= c-nr-docto
                       and   tit-ap.dt-vencimen  >= d-dt-venc 
                       and   tit-ap.cod-fornec   >= i-cod-fornec
                       and   tit-ap.cod-esp      >= c-cod-esp
                       by  tit-ap.ep-codigo 
                       by  tit-ap.cod-fornec
                       by  tit-ap.cod-estabel
                       by  tit-ap.cod-esp
                       by  tit-ap.serie
                       by  tit-ap.nr-docto
                       by  tit-ap.parcela INDEXED-REPOSITION.
    when 10 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                               where tit-ap.ep-codigo   = i-empresa
                               and   tit-ap.cod-fornec  = int(v-ext-perfil-usuar) INDEXED-REPOSITION.
    when 11 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                               where tit-ap.ep-codigo   = i-empresa
                               and   tit-ap.cod-fornec  = int(v-ext-perfil-usuar)
                               and   tit-ap.nr-docto    >= c-nr-docto
                               and   tit-ap.cod-estabel >= c-cod-estabel
                               and   tit-ap.dt-vencimen >= d-dt-venc
                               and   tit-ap.cod-esp     >= c-cod-esp
                               by  tit-ap.ep-codigo 
                               by  tit-ap.cod-fornec
                               by  tit-ap.cod-estabel
                               by  tit-ap.cod-esp
                               by  tit-ap.serie
                               by  tit-ap.nr-docto
                               by  tit-ap.parcela INDEXED-REPOSITION.
    when 12 then
         if c-cod-estabel = c-cod-estabel-fim then
             open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock                                                                                  
                         where tit-ap.ep-codigo     =  i-ep-codigo
                         and   tit-ap.cod-estabel   = c-cod-estabel
                         and   tit-ap.nr-docto     >= c-nr-docto
                         and   tit-ap.nr-docto     <= c-nr-docto-fim
                         and   tit-ap.dt-vencimen  >= d-dt-venc 
                         and   tit-ap.dt-vencimen  <= d-dt-venc-fim 
                         and   tit-ap.cod-fornec   >= i-cod-fornec
                         and   tit-ap.cod-fornec   <= i-cod-fornec-fim
                         and   tit-ap.cod-esp      >= c-cod-esp
                         and   tit-ap.cod-esp      <= c-cod-esp-fim
                         by  tit-ap.ep-codigo 
                         by  tit-ap.cod-fornec
                         by  tit-ap.cod-estabel
                         by  tit-ap.cod-esp
                         by  tit-ap.serie
                         by  tit-ap.nr-docto
                         by  tit-ap.parcela INDEXED-REPOSITION.
         else do:
            if d-dt-venc = d-dt-venc-fim then 
                open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock                                                                                  
                            where tit-ap.ep-codigo     =  i-ep-codigo
                            and   tit-ap.dt-vencimen   = d-dt-venc
                            and   tit-ap.cod-estabel  >= c-cod-estabel
                            and   tit-ap.cod-estabel  <= c-cod-estabel-fim
                            and   tit-ap.nr-docto     >= c-nr-docto
                            and   tit-ap.nr-docto     <= c-nr-docto-fim
                            and   tit-ap.cod-fornec   >= i-cod-fornec
                            and   tit-ap.cod-fornec   <= i-cod-fornec-fim
                            and   tit-ap.cod-esp      >= c-cod-esp
                            and   tit-ap.cod-esp      <= c-cod-esp-fim
                            by  tit-ap.ep-codigo 
                            by  tit-ap.cod-fornec
                            by  tit-ap.cod-estabel
                            by  tit-ap.cod-esp
                            by  tit-ap.serie
                            by  tit-ap.nr-docto
                            by  tit-ap.parcela INDEXED-REPOSITION.
            else do:
               if i-cod-fornec = i-cod-fornec-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock                                                                                  
                                where tit-ap.ep-codigo     =  i-ep-codigo
                                and   tit-ap.cod-fornec    = i-cod-fornec
                                and   tit-ap.cod-estabel  >= c-cod-estabel
                                and   tit-ap.cod-estabel  <= c-cod-estabel-fim
                                and   tit-ap.nr-docto     >= c-nr-docto
                                and   tit-ap.nr-docto     <= c-nr-docto-fim
                                and   tit-ap.dt-vencimen  >= d-dt-venc 
                                and   tit-ap.dt-vencimen  <= d-dt-venc-fim 
                                and   tit-ap.cod-esp      >= c-cod-esp
                                and   tit-ap.cod-esp      <= c-cod-esp-fim
                                by  tit-ap.ep-codigo 
                                by  tit-ap.cod-fornec
                                by  tit-ap.cod-estabel
                                by  tit-ap.cod-esp
                                by  tit-ap.serie
                                by  tit-ap.nr-docto
                                by  tit-ap.parcela INDEXED-REPOSITION.               
               else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock                                                                                  
                                where tit-ap.ep-codigo    =  i-ep-codigo
                                and   tit-ap.cod-estabel  >= c-cod-estabel
                                and   tit-ap.cod-estabel  <= c-cod-estabel-fim
                                and   tit-ap.nr-docto     >= c-nr-docto
                                and   tit-ap.nr-docto     <= c-nr-docto-fim
                                and   tit-ap.dt-vencimen  >= d-dt-venc 
                                and   tit-ap.dt-vencimen  <= d-dt-venc-fim 
                                and   tit-ap.cod-fornec   >= i-cod-fornec
                                and   tit-ap.cod-fornec   <= i-cod-fornec-fim
                                and   tit-ap.cod-esp      >= c-cod-esp
                                and   tit-ap.cod-esp      <= c-cod-esp-fim
                                by  tit-ap.ep-codigo 
                                by  tit-ap.cod-fornec
                                by  tit-ap.cod-estabel
                                by  tit-ap.cod-esp
                                by  tit-ap.serie
                                by  tit-ap.nr-docto
                                by  tit-ap.parcela INDEXED-REPOSITION.
            end.
         end. 
        when 13 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                               where tit-ap.ep-codigo          = i-ep-codigo-usuario
                                 and string(tit-ap.nr-bordero) = c-bordero
                                 and string(tit-ap.portador)   = c-portador
                                 and tit-ap.valor-saldo        = 0 INDEXED-REPOSITION.
        when 14 then do:
            find first tit-ap no-lock
                               where tit-ap.ep-codigo          = i-ep-codigo-usuario
                                 and string(tit-ap.nr-bordero) = c-bordero
                                 and string(tit-ap.portador)   = c-portador no-error.
            open query {&QUERY-NAME} for each tit-ap no-lock
                               where tit-ap.ep-codigo          = i-ep-codigo-usuario
                                 and string(tit-ap.nr-bordero) = c-bordero
                                 and string(tit-ap.portador)   = c-portador
                                 and tit-ap.valor-saldo        <> 0 INDEXED-REPOSITION.                    
        end.
        when 15 then do:
            find first mov-ap no-lock
                 where mov-ap.ep-codigo          = i-ep-codigo-usuario
                   AND string(mov-ap.nr-bordero) = c-bordero
                   and string(mov-ap.portador)   = c-portador no-error.
            if avail mov-ap then        
            open query {&QUERY-NAME} for each tit-ap no-lock
                               where tit-ap.ep-codigo   = mov-ap.ep-codigo
                                 and tit-ap.cod-fornec  = mov-ap.cod-fornec
                                 and tit-ap.cod-estabel = mov-ap.cod-estabel
                                 and tit-ap.cod-esp     = mov-ap.cod-esp
                                 and tit-ap.serie       = mov-ap.serie
                                 and tit-ap.nr-docto    = mov-ap.nr-docto
                                 and tit-ap.parcela     = mov-ap.parcela 
                                 USE-INDEX codigo INDEXED-REPOSITION.
        end.
        when 16 then do:
             if c-docto-ini = c-docto-fim then
                open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                   where tit-ap.ep-codigo  = i-ep-codigo and
                                         tit-ap.nr-docto   = c-docto-ini and
                                        (tit-ap.tipo = 2 or tit-ap.tipo = 3) and
                                         tit-ap.valor-saldo > 0 
                                         BY tit-ap.nr-docto 
                                         BY tit-ap.parcela 
                                         BY tit-ap.cod-estabel 
                                         BY tit-ap.cod-esp 
                                         BY tit-ap.cod-fornec INDEXED-REPOSITION.
             else
                open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                   where tit-ap.ep-codigo  = i-ep-codigo and
                                         tit-ap.nr-docto  >= c-docto-ini and
                                         tit-ap.nr-docto  <= c-docto-fim and
                                        (tit-ap.tipo = 2 or tit-ap.tipo = 3) and
                                         tit-ap.valor-saldo > 0 
                                         BY tit-ap.nr-docto 
                                         BY tit-ap.parcela 
                                         BY tit-ap.cod-estabel 
                                         BY tit-ap.cod-esp 
                                         BY tit-ap.cod-fornec INDEXED-REPOSITION.
        end.                              
  end case.
    assign l-query = true
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
 
procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input parameter i-ep-codigo LIKE empresa.ep-codigo no-undo.
&ELSE
    def input parameter i-ep-codigo as inte no-undo.
&ENDIF
    def input parameter i-cod-fornec as inte no-undo.
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-cod-esp as char no-undo.
    def input parameter c-serie as char no-undo.
    def input parameter c-nr-docto as char no-undo.
    def input parameter c-parcela as char no-undo.
    def output parameter c-return as char no-undo.
 
    find tit-ap where
        tit-ap.ep-codigo       = i-ep-codigo
        and tit-ap.cod-fornec  = i-cod-fornec
        and tit-ap.cod-estabel = c-cod-estabel
        and tit-ap.cod-esp     = c-cod-esp
        and tit-ap.serie       = c-serie
        and tit-ap.nr-docto    = c-nr-docto
        and tit-ap.parcela     = c-parcela
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movadm {&TABLE-NAME} 1}
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
 
 procedure findEmpresa:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input parameter i-ep-codigo LIKE empresa.ep-codigo no-undo.
&ELSE
    def input parameter i-ep-codigo as inte no-undo.
&ENDIF
    def output parameter c-return as char no-undo.
    find first tit-ap where
        tit-ap.ep-codigo = i-ep-codigo no-lock no-error.
    if not avail {&TABLE-NAME} then do:
       /* {utp/ut-table.i mguni empresa 1}*/
        run utp/ut-msgs.p (input "msg",
                           input 8499,
                           input i-ep-codigo).
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
    if rowObject.atualiza-bor = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.calcula-cmi = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.calcula-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-banco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-esp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estabel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-fornec = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ct-conta-db = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dias-atraso = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.docto-ant = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-emissao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-vencimen = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.emitiu = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ep-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.estado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.inst-banc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.jur-dia-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.matriz = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.moeda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-abrev = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-bordero = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-cheque = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-fluxo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.origem = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.parcela = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.pedido = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.perc-juros = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.perc-mora = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.portador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.referencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.sc-conta-db = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.serie = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.serie-ant = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.taxa-emis-anbid = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.taxa-emis-cmi = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.taxa-emis-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.taxa-vencto-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tipo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tp-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.transacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-ir = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-saldo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-desc-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-desconto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-fluxo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-imposto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-orig-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-original = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-sal-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    run endMethod ("validateFields").
 
end procedure.
 
procedure validateCreate:
    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
 
    run initializeValidate.
    run startMethod ("validateCreate").
 
    for each tt-bo-erro exclusive-lock:
        delete tt-bo-erro.
    end.
 
    find first rowObject
        no-lock no-error.
    if rowObject.atualiza-bor = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} atualiza-bor 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.calcula-cmi = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} calcula-cmi 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.calcula-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} calcula-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-banco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} cod-banco 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-esp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} cod-esp 1}
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
        {utp/ut-field.i movadm {&TABLE-NAME} cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-fornec = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} cod-fornec 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ct-conta-db = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} ct-conta-db 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dias-atraso = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} dias-atraso 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.docto-ant = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} docto-ant 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-emissao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} dt-emissao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-vencimen = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} dt-vencimen 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.emitiu = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} emitiu 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ep-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} ep-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.estado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} estado 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.inst-banc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} inst-banc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.jur-dia-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} jur-dia-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.matriz = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} matriz 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.moeda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} moeda 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-abrev = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nome-abrev 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-bordero = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nr-bordero 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-cheque = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nr-cheque 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nr-docto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-fluxo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nr-fluxo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.origem = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} origem 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.parcela = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} parcela 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.pedido = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} pedido 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.perc-juros = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} perc-juros 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.perc-mora = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} perc-mora 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.portador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} portador 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.referencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} referencia 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.sc-conta-db = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} sc-conta-db 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.serie = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} serie 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.serie-ant = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} serie-ant 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.taxa-emis-anbid = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} taxa-emis-anbid 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.taxa-emis-cmi = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} taxa-emis-cmi 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.taxa-emis-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} taxa-emis-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.taxa-vencto-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} taxa-vencto-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tipo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} tipo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tp-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} tp-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.transacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} transacao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-ir = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} valor-ir 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-saldo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} valor-saldo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-desc-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} vl-desc-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-desconto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} vl-desconto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-fluxo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} vl-fluxo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-imposto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} vl-imposto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-orig-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} vl-orig-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-original = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} vl-original 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-sal-fasb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} vl-sal-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find tit-ap where
            tit-ap.ep-codigo    = rowObject.ep-codigo
        and tit-ap.cod-fornec   = rowObject.cod-fornec
        and tit-ap.cod-estabel  = rowObject.cod-estabel
        and tit-ap.cod-esp      = rowObject.cod-esp
        and tit-ap.serie        = rowObject.serie
        and tit-ap.nr-docto     = rowObject.nr-docto
        and tit-ap.parcela      = rowObject.parcela
            no-lock no-error.
        if avail tit-ap then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movadm {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
    end.
 
    run validateFields.
    find first tt-bo-erro
        no-lock no-error.
 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.
 
    run endMethod ("validateCreate").
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        &IF "{&mguni_version}" >= "2.07A" &THEN
            when "ep-codigo" then c-value = RowObject.ep-codigo.
        &ENDIF
        when "arq-remessa" then c-value = RowObject.arq-remessa.
        when "cgc" then c-value = RowObject.cgc.
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-barras" then c-value = RowObject.cod-barras.
        when "cod-esp" then c-value = RowObject.cod-esp.
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "conta-debito" then c-value = RowObject.conta-debito.
        when "conta-fornecedor" then c-value = RowObject.conta-fornecedor.
        when "ct-conta-db" then c-value = RowObject.ct-conta-db.
        when "ct-conta-for" then c-value = RowObject.ct-conta-for.
        when "docto-ant" then c-value = RowObject.docto-ant.
        when "esp-ant" then c-value = RowObject.esp-ant.
        when "esp-vinc" then c-value = RowObject.esp-vinc.
        when "inst-banc" then c-value = RowObject.inst-banc.
        when "nat-operac" then c-value = RowObject.nat-operac.
        when "nome-abrev" then c-value = RowObject.nome-abrev.
        when "nr-docto" then c-value = RowObject.nr-docto.
        when "nr-docto-vinc" then c-value = RowObject.nr-docto-vinc.
        when "observacao" then c-value = RowObject.observacao.
        when "parc-ant" then c-value = RowObject.parc-ant.
        when "parcela" then c-value = RowObject.parcela.
        when "parcela-vinc" then c-value = RowObject.parcela-vinc.
        when "pedido" then c-value = RowObject.pedido.
        when "referencia" then c-value = RowObject.referencia.
        when "sc-conta-db" then c-value = RowObject.sc-conta-db.
        when "sc-conta-for" then c-value = RowObject.sc-conta-for.
        when "serie" then c-value = RowObject.serie.
        when "serie-ant" then c-value = RowObject.serie-ant.
        when "serie-vinc" then c-value = RowObject.serie-vinc.
        when "titulo-banco" then c-value = RowObject.titulo-banco.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "cotacao-dia" then c-value = RowObject.cotacao-dia.
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "diversos" then c-value = RowObject.diversos.
        when "diversos-me" then c-value = RowObject.diversos-me.
        when "frete" then c-value = RowObject.frete.
        when "frete-me" then c-value = RowObject.frete-me.
        when "ip-aliquota" then c-value = RowObject.ip-aliquota.
        when "jur-dia-fasb" then c-value = RowObject.jur-dia-fasb.
        when "nr-cheque" then c-value = RowObject.nr-cheque.
        when "perc-juros" then c-value = RowObject.perc-juros.
        when "perc-mora" then c-value = RowObject.perc-mora.
        when "perc-multa" then c-value = RowObject.perc-multa.
        when "saldo-isr" then c-value = RowObject.saldo-isr.
        when "taxa-emis-anbid" then c-value = RowObject.taxa-emis-anbid.
        when "taxa-emis-cmi" then c-value = RowObject.taxa-emis-cmi.
        when "taxa-emis-fasb" then c-value = RowObject.taxa-emis-fasb.
        when "taxa-vencto-fasb" then c-value = RowObject.taxa-vencto-fasb.
        when "valor-ir" then c-value = RowObject.valor-ir.
        when "valor-saldo" then c-value = RowObject.valor-saldo.
        when "vl-desc-conf" then c-value = RowObject.vl-desc-conf.
        when "vl-desc-fasb" then c-value = RowObject.vl-desc-fasb.
        when "vl-desconto" then c-value = RowObject.vl-desconto.
        when "vl-desconto-me" then c-value = RowObject.vl-desconto-me.
        when "vl-dif-camb" then c-value = RowObject.vl-dif-camb.
        when "vl-fluxo" then c-value = RowObject.vl-fluxo.
        when "vl-imposto" then c-value = RowObject.vl-imposto.
        when "vl-ir-antec" then c-value = RowObject.vl-ir-antec.
        when "vl-isr" then c-value = RowObject.vl-isr.
        when "vl-juros-conf" then c-value = RowObject.vl-juros-conf.
        when "vl-juros-dia" then c-value = RowObject.vl-juros-dia.
        when "vl-juros-dia-me" then c-value = RowObject.vl-juros-dia-me.
        when "vl-liquido" then c-value = RowObject.vl-liquido.
        when "vl-liquido-me" then c-value = RowObject.vl-liquido-me.
        when "vl-orig-fasb" then c-value = RowObject.vl-orig-fasb.
        when "vl-orig-me" then c-value = RowObject.vl-orig-me.
        when "vl-original" then c-value = RowObject.vl-original.
        when "vl-sal-fasb" then c-value = RowObject.vl-sal-fasb.
        when "vl-saldo-me" then c-value = RowObject.vl-saldo-me.
        when "vl-taxa" then c-value = RowObject.vl-taxa.
        when "vl-taxa-me" then c-value = RowObject.vl-taxa-me.
        when "vl-var-monet" then c-value = RowObject.vl-var-monet.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "autorizacao" then c-value = RowObject.autorizacao.
        when "cod-banco" then c-value = RowObject.cod-banco.
        when "cod-fornec" then c-value = RowObject.cod-fornec.
        when "cod-impto-ret" then c-value = RowObject.cod-impto-ret.
        when "cod-retencao" then c-value = RowObject.cod-retencao.
        when "cod-tax" then c-value = RowObject.cod-tax.
        when "cond-pagto" then c-value = RowObject.cond-pagto.
        when "dias-atraso" then c-value = RowObject.dias-atraso.
        when "docum-est" then c-value = RowObject.docum-est.
        &IF "{&mguni_version}" < "2.07A" &THEN
            when "ep-codigo" then c-value = RowObject.ep-codigo.
        &ENDIF
        when "estado" then c-value = RowObject.estado.
        when "fornec-vinc" then c-value = RowObject.fornec-vinc.
        when "ins-banc[1]" then c-value = RowObject.ins-banc[1].
        when "ins-banc[2]" then c-value = RowObject.ins-banc[2].
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "lancamento" then c-value = RowObject.lancamento.
        when "matriz" then c-value = RowObject.matriz.
        when "modalidade" then c-value = RowObject.modalidade.
        when "moeda" then c-value = RowObject.moeda.
        when "moeda-org" then c-value = RowObject.moeda-org.
        when "nr-bordero" then c-value = RowObject.nr-bordero.
        when "nr-fluxo" then c-value = RowObject.nr-fluxo.
        when "nr-invoice" then c-value = RowObject.nr-invoice.
        when "num-ord-inv" then c-value = RowObject.num-ord-inv.
        when "origem" then c-value = RowObject.origem.
        when "portador" then c-value = RowObject.portador.
        when "sit-receb" then c-value = RowObject.sit-receb.
        when "tipo" then c-value = RowObject.tipo.
        when "tipo-mercad" then c-value = RowObject.tipo-mercad.
        when "tp-codigo" then c-value = RowObject.tp-codigo.
        when "tp-pagto" then c-value = RowObject.tp-pagto.
        when "transacao" then c-value = RowObject.transacao.
        when "ult-seq" then c-value = RowObject.ult-seq.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "dt-desc-conf" then c-value = RowObject.dt-desc-conf.
        when "dt-desconto" then c-value = RowObject.dt-desconto.
        when "dt-emissao" then c-value = RowObject.dt-emissao.
        when "dt-fluxo" then c-value = RowObject.dt-fluxo.
        when "dt-liq" then c-value = RowObject.dt-liq.
        when "dt-prev-pag" then c-value = RowObject.dt-prev-pag.
        when "dt-transacao" then c-value = RowObject.dt-transacao.
        when "dt-ult-pagto" then c-value = RowObject.dt-ult-pagto.
        when "dt-vecto-orig" then c-value = RowObject.dt-vecto-orig.
        when "dt-vencimen" then c-value = RowObject.dt-vencimen.
        when "dt-vencto-ori" then c-value = RowObject.dt-vencto-ori.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "atualiza-bor" then c-value = RowObject.atualiza-bor.
        when "calcula-cmi" then c-value = RowObject.calcula-cmi.
        when "calcula-fasb" then c-value = RowObject.calcula-fasb.
        when "emissao-bord" then c-value = RowObject.emissao-bord.
        when "emitiu" then c-value = RowObject.emitiu.
        when "enviado" then c-value = RowObject.enviado.
        when "ind-ir" then c-value = RowObject.ind-ir.
        when "ir-antec" then c-value = RowObject.ir-antec.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        when "tem-credito" then c-value = RowObject.tem-credito.
        otherwise return error.
    end case.
end procedure.
 
procedure findPriTitAp :
/*
**  Localiza registro pelo rowid e nao retorna o registro do tit-ap - 
**  Documentos do Contas a Pagar.
*/
    define input parameter r-chave as rowid no-undo.
    define output parameter table for RowObject.


    define  buffer b-mov-ap for mov-ap.

    find mov-ap where
          rowid(mov-ap) = r-chave
    	   no-lock no-error.

   if can-find(first tit-ap
                 where tit-ap.ep-codigo   = mov-ap.ep-codigo
                 and   tit-ap.cod-estabel = mov-ap.cod-estabel
                 and   tit-ap.cod-fornec  = mov-ap.cod-fornec
                 and   tit-ap.cod-esp     = mov-ap.cod-esp
                 and   tit-ap.nr-docto    = mov-ap.nr-docto
                 and   tit-ap.parcela     = mov-ap.parcela
                 and   tit-ap.serie       = mov-ap.serie
                 and   (tit-ap.tipo = 1 or  tit-ap.tipo = 2)) then do: 
    
        find first {&TABLE-NAME} no-lock  
             where {&TABLE-NAME}.ep-codigo   = mov-ap.ep-codigo
             and   {&TABLE-NAME}.cod-estabel = mov-ap.cod-estabel
             and   {&TABLE-NAME}.cod-fornec  = mov-ap.fornec-ant
             and   {&TABLE-NAME}.cod-esp     = mov-ap.esp-ant
             and   {&TABLE-NAME}.serie       = mov-ap.serie-ant
             and   {&TABLE-NAME}.nr-docto    = mov-ap.docto-ant
             and   {&TABLE-NAME}.parcela     = mov-ap.parc-ant
             and  ({&TABLE-NAME}.tipo        = 4
             or    {&TABLE-NAME}.tipo        = 5) no-error.
            run setCurrent.
    end.

    if can-find(first tit-ap
            where tit-ap.ep-codigo   = mov-ap.ep-codigo
            and   tit-ap.cod-estabel = mov-ap.cod-estabel
            and   tit-ap.cod-fornec  = mov-ap.cod-fornec
            and   tit-ap.cod-esp     = mov-ap.cod-esp
            and   tit-ap.nr-docto    = mov-ap.nr-docto
            and   tit-ap.parcela     = mov-ap.parcela
            and   tit-ap.serie       = mov-ap.serie
            and   (tit-ap.tipo = 4 or tit-ap.tipo = 5)) then do: 

       find first b-mov-ap
            where b-mov-ap.ep-codigo   = mov-ap.ep-codigo
            and   b-mov-ap.cod-estabel = mov-ap.cod-estabel
            and   b-mov-ap.cod-fornec  = mov-ap.cod-fornec
            and   b-mov-ap.esp-ant     = mov-ap.cod-esp
            and   b-mov-ap.docto-ant   = mov-ap.nr-docto
            and   b-mov-ap.parc-ant    = mov-ap.parcela
            and   b-mov-ap.serie-ant   = mov-ap.serie no-lock.

       if avail b-mov-ap then do:
          find first tit-ap
               where tit-ap.ep-codigo   = b-mov-ap.ep-codigo
               and   tit-ap.cod-estabel = b-mov-ap.cod-estabel
               and   tit-ap.cod-fornec  = b-mov-ap.cod-fornec   
               and   tit-ap.cod-esp     = b-mov-ap.cod-esp
               and   tit-ap.nr-docto    = b-mov-ap.nr-docto
               and   tit-ap.parcela     = b-mov-ap.parcela
               and   tit-ap.serie       = b-mov-ap.serie
               no-lock no-error.
           run setCurrent.
       end.
    end.

end procedure.
procedure calcFasbTitAp :
/* Calcula valor e saldo FASB do tit-ap
   - Documentos do Contas a Pagar
   Parametros : 
   ipar1 : p-empresa       : C¢digo da Empresa Corrente 
   ipar2 : r-tit-ap        : Rowid tabela Tit-ap
   opar3 : de-vl-sal-fasb  : Valor Calculado do FASB
   opar4 : de-vl-orig-fasb : Valor Original do FASB
*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  parameter p-empresa       LIKE empresa.ep-codigo no-undo.
&ELSE
    def input  parameter p-empresa       as integer no-undo.
&ENDIF
    def input  parameter r-tit-ap        as rowid   no-undo.
    def output parameter de-vl-sal-fasb  as decimal no-undo.
    def output parameter de-vl-orig-fasb as decimal no-undo.
    define buffer b-mov-ap for mov-ap.
    define var de-dolar as decimal no-undo.
     
    find param-fasb where 
         param-fasb.ep-codigo = p-empresa 
    	  no-lock no-error.
    find tit-ap where
    	rowid(tit-ap) = r-tit-ap
    	no-lock no-error.
    if avail param-fasb then do:
        if avail tit-ap then do:
            if  tit-ap.tipo = 2 then do:
                assign de-dolar = tit-ap.vl-sal-fasb / 100.
            end.
            else do:
                if param-fasb.tipo-calculo = 0 then do:
                    {cdp/cd9600.i "param-fasb.moeda-fasb"
                                  "tit-ap.dt-emissao" 
                                  "de-dolar"
                                  " "
                                  "msg"}
                    assign de-dolar = de-dolar * (tit-ap.vl-sal-fasb / tit-ap.vl-orig-fasb).
                end.
                else
                    assign de-dolar = tit-ap.vl-sal-fasb / 100.
            end.
        end.
    end.
    if avail tit-ap then do:
        assign de-vl-sal-fasb  = tit-ap.valor-saldo / de-dolar
               de-vl-orig-fasb = tit-ap.vl-original / de-dolar.
        find first b-mov-ap where 
                   b-mov-ap.ep-codigo  = tit-ap.ep-codigo  and   
                   b-mov-ap.cod-estabel    = tit-ap.cod-estabel    and   
                   b-mov-ap.cod-esp    = tit-ap.cod-esp    and   
                   b-mov-ap.serie      = tit-ap.serie      and   
                   b-mov-ap.nr-docto   = tit-ap.nr-docto   and   
                   b-mov-ap.parcela    = tit-ap.parcela    and   
                   b-mov-ap.cod-fornec = tit-ap.cod-fornec and   
                   b-mov-ap.transacao  = 1
                   no-lock no-error.
        if avail b-mov-ap then
            assign de-vl-orig-fasb = b-mov-ap.vl-mov-fasb.

            if de-vl-sal-fasb  = ? then assign de-vl-sal-fasb  = 0.
            if de-vl-orig-fasb = ? then assign de-vl-orig-fasb = 0.   
    end.
end.


procedure retornaMensTitAp :
def output param table  for tt-bo-erro.
 
      run utp/ut-msgs.p (input "msg",
                         input 17568,
                         input return-value).
      create tt-bo-erro.
      assign tt-bo-erro.i-sequen     = 0
             tt-bo-erro.cd-erro      = 17568
             tt-bo-erro.mensagem     = return-value.

end procedure.

/*procedure findEmpresa :
 * 
&IF "{&mguni_version}" >= "2.07A" &THEN
 * def input parameter p-empresa LIKE empresa.ep-codigo no-undo.
&ELSE
 * def input parameter p-empresa as int no-undo.
&ENDIF
 * def output parameter table tt-bo-erro.
 *  
 *     find first rowObject
 *         no-lock no-error.
 * /*    if rowObject.ep-codigo = "" then do:
 *  *         assign i-seq-erro = i-seq-erro + 1.
 *  *         {utp/ut-field.i mgadm {&TABLE-NAME} cod-estabel 1}
 *  *         run utp/ut-msgs.p (input "msg",
 *  *                            input 265,
 *  *                            input return-value).
 *  *         create tt-bo-erro.
 *  *         assign tt-bo-erro.i-sequen     = i-seq-erro
 *  *                tt-bo-erro.cd-erro      = 265
 *  *                tt-bo-erro.mensagem     = return-value.
 *  *     end.
 *  *     else */
 *       if not can-find(empresa where empresa.ep-codigo = rowObject.ep-codigo) then do:
 *              assign i-seq-erro = i-seq-erro + 1.
 *              {utp/ut-table.i mguni empresa 1}
 *              run utp/ut-msgs.p (input "msg",
 *                                 input 2,
 *                                 input return-value).
 *              create tt-bo-erro.
 *              assign tt-bo-erro.i-sequen = i-seq-erro
 *                     tt-bo-erro.cd-erro  = 2
 *                     tt-bo-erro.mensagem = return-value.     
 *          end.
 * 
 *  end.*/


PROCEDURE findFirstTitAp:
   DEFINE INPUT PARAMETER p-bordero   AS INT.
   DEFINE INPUT PARAMETER p-portador  AS INT.
   &IF "{&mguni_version}" >= "2.07A" &THEN
   DEFINE INPUT PARAMETER p-ep-codigo like empresa.ep-codigo.
   &ELSE
   DEFINE INPUT PARAMETER p-ep-codigo AS INT.
   &ENDIF
   DEFINE OUTPUT PARAMETER p-return AS CHAR.

   find first tit-ap no-lock
        where tit-ap.ep-codigo  = p-ep-codigo
          and tit-ap.nr-bordero = p-bordero
          and tit-ap.portador   = p-portador no-error.
   IF NOT AVAIL tit-ap THEN
      ASSIGN p-return = "NOK":U.
   ELSE
      ASSIGN p-return = "OK":U.  

END PROCEDURE.

/***********************************************************************************************/
/*Novas procedures para a consulta de Bordero wap0812*/
PROCEDURE piCreateTTDocto:
&IF "{&mguni_version}" >= "2.07A" &THEN
   DEFINE INPUT  PARAMETER i-ep-codigo-usuario LIKE empresa.ep-codigo.
&ELSE
   DEFINE INPUT  PARAMETER i-ep-codigo-usuario AS INTEGER.
&ENDIF
   DEFINE INPUT  PARAMETER l-filtro-bordero    AS LOGICAL.
   DEFINE INPUT  PARAMETER l-vl-pago-bord      AS LOGICAL.
   DEFINE INPUT  PARAMETER p-bordero           AS INTEGER.
   DEFINE INPUT  PARAMETER p-portador          AS INTEGER.
   DEFINE INPUT  PARAMETER p-bord-pagto        AS INTEGER.
   DEFINE OUTPUT PARAMETER TABLE FOR tt-documento.
   
   DEF VAR l-verifica AS LOGICAL INITIAL NO.

   for each tt-documento:
       delete tt-documento.
   end.
      
   IF l-filtro-bordero = YES THEN DO:
       /********************************************
       ** Dentro deste bloco, as procedures sÆo chamadas
       ** para atender a funcao "spp-filtro-bordero" e
       ** "spp-vl-pago-bord". A Leitura dos registro,
       ** ora ‚ feito em tit-ap , ora em mov-ap.
       **
       ** Explicacao: Quando 2 titulos (sendo um pgto 
       ** parcial e outro pagto total), sÆo colocados no mesmo 
       ** bordero, a consulta era feita de forma incorreta
       ** por estar lendo sempre os registro de tit-ap,
       ** onde a chave (ep-codigo, nr-bordero e portador)
       ** fosse igual ao digitado na selecao.
       ** Por‚m o £nico registro mostrado seria o t¡tulo 
       ** que foi pago totalmente, pois seu numero de bordero
       ** permaneceria int cto, o mesmo nÆo ocorria com o
       ** titulo pago parcialmente, que tem seu nro.bordero
       ** zerado no momento do pagamento.
       ********************************************/

       /********************************************
       ** Essa Procedure tem por funcao verificar se 
       ** os titulos do bordero estao mesclados entre
       ** Pagto Parcial ou Pagto Total.
       ********************************************/
       RUN piVerificaTitapMovap (INPUT i-ep-codigo-usuario,
                                 INPUT p-bordero,
                                 INPUT p-portador,
                                 OUTPUT l-verifica).
       /*******************************************/
       IF l-verifica = YES THEN DO: 
          /*tem pago total e parcial*/
          RUN piCriarTTDocumento2 (INPUT i-ep-codigo-usuario,
                                   INPUT l-filtro-bordero,
                                   INPUT l-vl-pago-bord,
                                   INPUT p-bordero,
                                   INPUT p-portador,
                                   INPUT p-bord-pagto,
                                   OUTPUT TABLE tt-documento).
       END.
       ELSE DO:
            FIND FIRST tit-ap NO-LOCK
                 WHERE tit-ap.ep-codigo  = i-ep-codigo-usuario
                   AND tit-ap.nr-bordero = p-bordero
                   AND tit-ap.portador   = p-portador NO-ERROR .
            IF AVAIL tit-ap THEN DO:                 
               RUN piCriarTTDocumento1 (INPUT i-ep-codigo-usuario,
                                        INPUT l-filtro-bordero,
                                        INPUT l-vl-pago-bord,
                                        INPUT p-bordero,
                                        INPUT p-portador,
                                        INPUT p-bord-pagto,
                                        OUTPUT TABLE tt-documento).
            END. /* IF AVAIL TIT-AP / MOV-AP */
            ELSE DO:           
                 FIND FIRST mov-ap NO-LOCK
                      WHERE mov-ap.ep-codigo  = i-ep-codigo-usuario
                        AND mov-ap.nr-bordero = p-bordero
                        AND mov-ap.portador   = p-portador no-error.
                 IF AVAIL mov-ap THEN DO:                 
                    run piCriarTTDocumento2 (INPUT i-ep-codigo-usuario,
                                             INPUT l-filtro-bordero,
                                             INPUT l-vl-pago-bord,
                                             INPUT p-bordero,
                                             INPUT p-portador,
                                             INPUT p-bord-pagto,
                                             OUTPUT TABLE tt-documento).
                 END.
            END.
       END.
   END. /*l-filtro-bordero*/
   ELSE DO:
       /* 
       ** Mostra os valores do titulo
       */
       RUN piCriarTTDocumento3 (INPUT i-ep-codigo-usuario,
                                INPUT l-filtro-bordero,
                                INPUT l-vl-pago-bord,
                                INPUT p-bordero,
                                INPUT p-portador,
                                INPUT p-bord-pagto,
                                OUTPUT TABLE tt-documento). 
   END.
   

END PROCEDURE.

PROCEDURE piVerificaTitapMovap :

&IF "{&mguni_version}" >= "2.07A" &THEN
    DEFINE INPUT  PARAMETER i-ep-codigo-usuario LIKE empresa.ep-codigo.
&ELSE
    DEFINE INPUT  PARAMETER i-ep-codigo-usuario AS INTEGER.
&ENDIF
    DEFINE INPUT  PARAMETER p-bordero           AS INTEGER.
    DEFINE INPUT  PARAMETER p-portador          AS INTEGER.
    DEFINE OUTPUT PARAMETER l-mesclado AS LOG.

    DEF VAR i-nr-zero   AS INT INIT 0.
    DEF VAR i-tot-outro AS INT INIT 0.
    FOR EACH mov-ap WHERE 
        mov-ap.ep-codigo  = i-ep-codigo-usuario AND
        mov-ap.nr-bordero = p-bordero AND
        mov-ap.portador   = p-portador 
        &if  "{&mgadm_version}" >= "2.04" &then
             USE-INDEX bordero 
        &endif   
        NO-LOCK:
        FIND FIRST tit-ap NO-LOCK WHERE
                   tit-ap.ep-codigo   = mov-ap.ep-codigo   AND
                   tit-ap.cod-fornec  = mov-ap.cod-fornec  AND
                   tit-ap.cod-estabel = mov-ap.cod-estabel AND
                   tit-ap.cod-esp     = mov-ap.cod-esp     AND
                   tit-ap.serie       = mov-ap.serie       AND
                   tit-ap.nr-docto    = mov-ap.nr-docto    AND
                   tit-ap.parcela     = mov-ap.parcela USE-INDEX codigo NO-ERROR.
        IF AVAIL tit-ap THEN DO: 
           IF tit-ap.nr-bordero = 0 THEN
              ASSIGN i-nr-zero = i-nr-zero + 1.
           ELSE
              ASSIGN i-tot-outro = i-tot-outro + 1.
        END.
    END.
    IF i-nr-zero > 0   AND
       i-tot-outro > 0 THEN 
       ASSIGN l-mesclado = YES.
    ELSE
       ASSIGN l-mesclado = NO.

END PROCEDURE.


PROCEDURE piCriarTTDocumento1:
&IF "{&mguni_version}" >= "2.07A" &THEN
    DEFINE INPUT PARAMETER i-ep-codigo-usuario LIKE empresa.ep-codigo.
&ELSE
    DEFINE INPUT PARAMETER i-ep-codigo-usuario AS INTEGER.
&ENDIF
    DEFINE INPUT PARAMETER l-filtro-bordero    AS LOGICAL.
    DEFINE INPUT PARAMETER l-vl-pago-bord      AS LOGICAL.
    DEFINE INPUT PARAMETER p-bordero           AS INTEGER.
    DEFINE INPUT PARAMETER p-portador          AS INTEGER.
    DEFINE INPUT PARAMETER p-bord-pagto        AS INTEGER.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-documento.
    
    DEFINE BUFFER b-mov-ap FOR mov-ap.

    for each  mov-ap
        where mov-ap.ep-codigo  = i-ep-codigo-usuario
        and   mov-ap.nr-bordero = p-bordero 
        and   mov-ap.portador   = p-portador
        AND   mov-ap.transacao  = 1
        &if  "{&mgadm_version}" >= "2.04" &then
             USE-INDEX bordero 
        &endif   
        NO-LOCK:

        FIND FIRST tit-ap NO-LOCK WHERE
                   tit-ap.ep-codigo   = mov-ap.ep-codigo   AND
                   tit-ap.cod-fornec  = mov-ap.cod-fornec  AND
                   tit-ap.cod-estabel = mov-ap.cod-estabel AND
                   tit-ap.cod-esp     = mov-ap.cod-esp     AND
                   tit-ap.serie       = mov-ap.serie       AND
                   tit-ap.nr-docto    = mov-ap.nr-docto    AND
                   tit-ap.parcela     = mov-ap.parcela USE-INDEX codigo NO-ERROR.

        if (l-filtro-bordero = no)    /* Cliente sem a fun‡Æo */
        or (l-filtro-bordero = yes   /* Cliente com a fun‡Æo */
        and (p-bord-pagto = 3    /* Todos */
            or (p-bord-pagto = 1 /* Pagos */
            and tit-ap.valor-saldo = 0) 
            or (p-bord-pagto = 2 /* NÆo Pagos */
            and tit-ap.valor-saldo <> 0))) then do:
            
            create tt-documento.
            assign tt-documento.cod-estabel      = tit-ap.cod-estabel
                   tt-documento.cod-esp          = tit-ap.cod-esp
                   tt-documento.serie            = tit-ap.serie
                   tt-documento.nr-docto         = tit-ap.nr-docto
                   tt-documento.parcela          = tit-ap.parcela
                   tt-documento.cod-fornec       = tit-ap.cod-fornec
                   tt-documento.referencia       = tit-ap.referencia
                   tt-documento.dt-transacao     = tit-ap.dt-transacao 
                   tt-documento.valor-saldo      = tit-ap.valor-saldo
                   tt-documento.vl-original      = tit-ap.vl-original
                   tt-documento.vl-juros-dia     = tit-ap.vl-juros-dia
                   &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                   tt-documento.vl-multa         = tit-ap.vl-multa-tot
                   tt-documento.vl-abatimento    = tit-ap.vl-abatimento-tot
                   &endif
                   tt-documento.portador         = tit-ap.portador
                   tt-documento.lancamento       = tit-ap.lancamento
                   tt-documento.nome-abrev       = tit-ap.nome-abrev.
        
            IF l-filtro-bordero = yes          /* Cliente possui as opcoes "pagos", "Nao Pagos" e "Todos" no filtro*/
               and l-vl-pago-bord = yes        /* Cliente possue a funcao de valor pago do bordero */
               and (p-bord-pagto = 1 or
                    p-bord-pagto = 3) then do:  /* A opcao escolhida foi "Pagos" */
                find first b-mov-ap no-lock
                     where b-mov-ap.ep-codigo   = tit-ap.ep-codigo
                       and b-mov-ap.cod-fornec  = tit-ap.cod-fornec
                       and b-mov-ap.cod-estabel = tit-ap.cod-estabel
                       and b-mov-ap.cod-esp     = tit-ap.cod-esp
                       and b-mov-ap.serie       = tit-ap.serie
                       and b-mov-ap.nr-docto    = tit-ap.nr-docto
                       and b-mov-ap.parcela     = tit-ap.parcela
                       and b-mov-ap.nr-bordero  = p-bordero
                       and b-mov-ap.transacao   = 2 /* Baixa */  no-error.
                If avail b-mov-ap then do:
                   if p-bord-pagto = 3 then /* TODOS */
                      assign tt-documento.valor-saldo = if tit-ap.valor-saldo = 0 then
                                                           b-mov-ap.valor-mov
                                                        else  
                                                           tit-ap.valor-saldo.
                   if p-bord-pagto = 1 then /* PAGOS */ 
                      assign tt-documento.valor-saldo = mov-ap.valor-mov.

                end.   
                else
                   assign tt-documento.valor-saldo    = tit-ap.valor-saldo.
            END.
            
            /* VERSAO >= 2.02 */    
            &if  "{&mgadm_version}" >= "2.02" &then    
                find bord-tit use-index codigo where
                     bord-tit.ep-codigo   = tit-ap.ep-codigo and
                     bord-tit.cod-estabel = tit-ap.cod-estabel and
                     bord-tit.cod-esp     = tit-ap.cod-esp and
                     bord-tit.cod-fornec  = tit-ap.cod-fornec and
                     bord-tit.serie       = tit-ap.serie and
                     bord-tit.nr-docto    = tit-ap.nr-docto and
                     bord-tit.parcela     = tit-ap.parcela and
                     bord-tit.portador    = tit-ap.portador and
                     bord-tit.nr-bordero  = tit-ap.nr-bordero 
                     no-lock no-error.
                if  avail bord-tit then
                    assign tt-documento.valor-saldo = bord-tit.vl-saldo.
            &endif
        end.
    end.
END PROCEDURE.

PROCEDURE piCriarTTDocumento2:
&IF "{&mguni_version}" >= "2.07A" &THEN
    DEFINE INPUT PARAMETER i-ep-codigo-usuario LIKE empresa.ep-codigo.
&ELSE
    DEFINE INPUT PARAMETER i-ep-codigo-usuario AS INTEGER.
&ENDIF
    DEFINE INPUT PARAMETER l-filtro-bordero    AS LOGICAL.
    DEFINE INPUT PARAMETER l-vl-pago-bord      AS LOGICAL.
    DEFINE INPUT PARAMETER p-bordero           AS INTEGER.
    DEFINE INPUT PARAMETER p-portador          AS INTEGER.
    DEFINE INPUT PARAMETER p-bord-pagto        AS INTEGER.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-documento.
    
    DEFINE BUFFER b-mov-ap FOR mov-ap.

    FOR EACH mov-ap 
       WHERE mov-ap.ep-codigo  = i-ep-codigo-usuario
         AND mov-ap.nr-bordero = p-bordero
         AND mov-ap.portador   = p-portador 
         AND mov-ap.transacao  = 2 
         &if  "{&mgadm_version}" >= "2.04" &then
             USE-INDEX bordero 
        &endif   
        NO-LOCK:
    
         FIND FIRST tit-ap NO-LOCK WHERE
                    tit-ap.ep-codigo   = mov-ap.ep-codigo   AND
                    tit-ap.cod-fornec  = mov-ap.cod-fornec  AND
                    tit-ap.cod-estabel = mov-ap.cod-estabel AND
                    tit-ap.cod-esp     = mov-ap.cod-esp     AND
                    tit-ap.serie       = mov-ap.serie       AND
                    tit-ap.nr-docto    = mov-ap.nr-docto    AND
                    tit-ap.parcela     = mov-ap.parcela USE-INDEX codigo NO-ERROR.

        if (l-filtro-bordero = no)   /* Cliente sem a fun‡Æo */
        or (l-filtro-bordero = yes   /* Cliente com a fun‡Æo */
            and (p-bord-pagto = 3 OR /* Todos */ p-bord-pagto = 1 /* Pagos */)) then do:
            
            create tt-documento.
            assign tt-documento.cod-estabel      = tit-ap.cod-estabel
                   tt-documento.cod-esp          = tit-ap.cod-esp
                   tt-documento.serie            = tit-ap.serie
                   tt-documento.nr-docto         = tit-ap.nr-docto
                   tt-documento.parcela          = tit-ap.parcela
                   tt-documento.cod-fornec       = tit-ap.cod-fornec
                   tt-documento.referencia       = tit-ap.referencia
                   tt-documento.dt-transacao     = tit-ap.dt-transacao 
                   tt-documento.valor-saldo      = tit-ap.valor-saldo
                   tt-documento.vl-original      = tit-ap.vl-original
                   tt-documento.vl-juros-dia     = tit-ap.vl-juros-dia
                   &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                   tt-documento.vl-multa         = tit-ap.vl-multa-tot
                   tt-documento.vl-abatimento    = tit-ap.vl-abatimento-tot
                   &endif
                   tt-documento.portador         = tit-ap.portador
                   tt-documento.lancamento       = tit-ap.lancamento
                   tt-documento.nome-abrev       = tit-ap.nome-abrev.
            
            IF l-filtro-bordero = yes          /* Cliente possui as opcoes "pagos", "Nao Pagos" e "Todos" no filtro*/
               and l-vl-pago-bord = yes        /* Cliente possue a funcao de valor pago do bordero */
               and (p-bord-pagto = 1 or
                    p-bord-pagto = 3) then do:  /* A opcao escolhida foi "Pagos" */
                find first b-mov-ap no-lock
                     where b-mov-ap.ep-codigo   = tit-ap.ep-codigo
                       and b-mov-ap.cod-fornec  = tit-ap.cod-fornec
                       and b-mov-ap.cod-estabel = tit-ap.cod-estabel
                       and b-mov-ap.cod-esp     = tit-ap.cod-esp
                       and b-mov-ap.serie       = tit-ap.serie
                       and b-mov-ap.nr-docto    = tit-ap.nr-docto
                       and b-mov-ap.parcela     = tit-ap.parcela
                       and b-mov-ap.nr-bordero  = p-bordero
                       and b-mov-ap.transacao   = 2 /* Baixa */  no-error.
                If avail b-mov-ap then do:
                   if p-bord-pagto = 1 OR 
                      p-bord-pagto = 3 then /* TODOS */
                      assign tt-documento.valor-saldo = b-mov-ap.valor-mov.
                end.   
                else
                   assign tt-documento.valor-saldo    = tit-ap.valor-saldo.
            END.
            
            /* VERSAO >= 2.02 */    
            &if  "{&mgadm_version}" >= "2.02" &then    
                find bord-tit use-index codigo where
                     bord-tit.ep-codigo   = tit-ap.ep-codigo and
                     bord-tit.cod-estabel = tit-ap.cod-estabel and
                     bord-tit.cod-esp     = tit-ap.cod-esp and
                     bord-tit.cod-fornec  = tit-ap.cod-fornec and
                     bord-tit.serie       = tit-ap.serie and
                     bord-tit.nr-docto    = tit-ap.nr-docto and
                     bord-tit.parcela     = tit-ap.parcela and
                     bord-tit.portador    = tit-ap.portador and
                     bord-tit.nr-bordero  = tit-ap.nr-bordero 
                     no-lock no-error.
                if  avail bord-tit then
                    assign tt-documento.valor-saldo = bord-tit.vl-saldo.
            &endif
        end.
    END. /*mov-ap*/
END PROCEDURE.

PROCEDURE piCriarTTDocumento3:
&IF "{&mguni_version}" >= "2.07A" &THEN
    DEFINE INPUT PARAMETER i-ep-codigo-usuario LIKE empresa.ep-codigo.
&ELSE
    DEFINE INPUT PARAMETER i-ep-codigo-usuario AS INTEGER.
&ENDIF
    DEFINE INPUT PARAMETER l-filtro-bordero    AS LOGICAL.
    DEFINE INPUT PARAMETER l-vl-pago-bord      AS LOGICAL.
    DEFINE INPUT PARAMETER p-bordero           AS INTEGER.
    DEFINE INPUT PARAMETER p-portador          AS INTEGER.
    DEFINE INPUT PARAMETER p-bord-pagto        AS INTEGER.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-documento.
    
    DEFINE BUFFER b-mov-ap FOR mov-ap.
    
    FOR EACH mov-ap 
        WHERE mov-ap.ep-codigo  = i-ep-codigo-usuario
          AND mov-ap.nr-bordero = p-bordero
          AND mov-ap.portador   = p-portador
          AND mov-ap.transacao  = 1 
          &if  "{&mgadm_version}" >= "2.04" &then
             USE-INDEX bordero 
          &endif   
          NO-LOCK:
          FIND FIRST tit-ap NO-LOCK WHERE
                     tit-ap.ep-codigo   = mov-ap.ep-codigo   AND
                     tit-ap.cod-fornec  = mov-ap.cod-fornec  AND
                     tit-ap.cod-estabel = mov-ap.cod-estabel AND
                     tit-ap.cod-esp     = mov-ap.cod-esp     AND
                     tit-ap.serie       = mov-ap.serie       AND
                     tit-ap.nr-docto    = mov-ap.nr-docto    AND
                     tit-ap.parcela     = mov-ap.parcela USE-INDEX codigo NO-ERROR.

          create tt-documento.
          assign tt-documento.cod-estabel      = tit-ap.cod-estabel
                 tt-documento.cod-esp          = tit-ap.cod-esp
                 tt-documento.serie            = tit-ap.serie
                 tt-documento.nr-docto         = tit-ap.nr-docto
                 tt-documento.parcela          = tit-ap.parcela
                 tt-documento.cod-fornec       = tit-ap.cod-fornec
                 tt-documento.referencia       = tit-ap.referencia
                 tt-documento.dt-transacao     = tit-ap.dt-transacao 
                 tt-documento.valor-saldo      = tit-ap.valor-saldo
                 tt-documento.vl-original      = tit-ap.vl-original
                 tt-documento.vl-juros-dia     = tit-ap.vl-juros-dia
                 &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                 tt-documento.vl-multa         = tit-ap.vl-multa-tot
                 tt-documento.vl-abatimento    = tit-ap.vl-abatimento-tot
                 &endif
                 tt-documento.portador         = tit-ap.portador
                 tt-documento.lancamento       = tit-ap.lancamento
                 tt-documento.nome-abrev       = tit-ap.nome-abrev.


          /* VERSAO >= 2.02 */    
          &if  "{&mgadm_version}" >= "2.02" &then    
               find bord-tit use-index codigo where
                    bord-tit.ep-codigo   = tit-ap.ep-codigo and
                    bord-tit.cod-estabel = tit-ap.cod-estabel and
                    bord-tit.cod-esp     = tit-ap.cod-esp and
                    bord-tit.cod-fornec  = tit-ap.cod-fornec and
                    bord-tit.serie       = tit-ap.serie and
                    bord-tit.nr-docto    = tit-ap.nr-docto and
                    bord-tit.parcela     = tit-ap.parcela and
                    bord-tit.portador    = tit-ap.portador and
                    bord-tit.nr-bordero  = tit-ap.nr-bordero 
                    no-lock no-error.
               if  avail bord-tit then
                   assign tt-documento.valor-saldo = bord-tit.vl-saldo.
          &endif
    END.
END PROCEDURE.



/***********************************************************************************************/
   
