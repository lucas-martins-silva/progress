/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD098 2.00.00.080 } /*** "010080" 14/10/2025 14:44:16 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD098 MUT}
&ENDIF

/*
**  BOAD098.P
**
**  emitente - Emitentes
**
**  Ultima alteraá∆o : 02/04/99 - GeraBO
*/
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY emitente
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME emitente
&scoped-define PARENT-TABLE repres

/** tt-bo-erro **/
{include/boini.i}

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se n∆o, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
{cdp/cdcfgdis.i} /* Include uso de pre-processadores para modulo BN*/

/*================ ATENÄ«O : Uso de PRE-PROCESSADOR ==========================*/    
/* Esse pre-processador Ç em virtude da existància de uma release nova de dicio-
   n†rio, a 2.02, que contÇm a tabela dist-emitente, enquanto a release anterior
   n∆o tem. A l¢gica abaixo ser† inclu°da no .r dependendo  das  informaá‰es que 
   est∆o na include {cdp/cdcfgdis.i}.d£vidas, verifique Manual TÇcnica do UIB.
 *******************************************************************************/
&if defined (bf_dis_desc_bonif) &then  /* pre-processador */   
 def var h-bo as handle no-undo.
 {dibo/bodi275.i "rowObject-ext" } 
&endif /* preprocessador */

/*====================== FIM USO PRE-PROCESSADOR ==============================*/
{adbo/boad098.i RowObject}

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

/*definaá∆o de temp-table para procedure validaCampos*/
def temp-table tt-param 
    field cod-estab-ini  as char
    field cod-estab-fim  as char
    field cod-esp-ini    as char
    field cod-esp-fim    as char
    field cod-port-ini   as int
    field cod-port-fim   as int
    field dt-emissao-ini as date
    field dt-emissao-fim as date.

/* Definiá∆o de vari†veis para setConstraint2 */  
DEFINE VAR i-cod-emit as integer no-undo.
def var i-cod-repres as integer no-undo.

/* Definiá∆o de vari†veis para setConstraint3 */
def var c-inicial as integer no-undo . 
def var c-inicial2 as integer no-undo .

/* Definiá∆o de vari†veis e temp-tables para setConstraint4 */
{adbo/boad229.i {&PARENT-TABLE}}
def var i-cod-rep-pai as int         no-undo.
def var r-chave-pai         as rowid no-undo.
def var h-boad229           as handle no-undo.
def var c-cliente-ini as char    no-undo.
def var c-cliente-fim as char    no-undo. 
def var c-estabel-ini as char    no-undo. 
def var c-estabel-fim as char    no-undo. 

/* Definiá∆o de vari†veis para setConstraint5 */
def var c-nome-abrev as char  no-undo.

/* Definiá∆o de vari†veis para setConstraint10 */
def var v-ext-perfil-usuar      as char no-undo.
def var v-ext-perfil-identific  as int no-undo.

/* Definiá∆o de vari†veis para setConstraint12 */
 def var i-codigo as integer no-undo . 
 def var c-nome as char no-undo .
  
/* Definiá∆o das vari†veis para setConstraint15 */
def var i-cod-cli      as int no-undo.
def var i-cod-emit-ini as int no-undo.
def var i-cod-emit-fin as int no-undo.
def var i-identific    as int no-undo.	
DEF VAR c-identific    AS CHAR NO-UNDO.

/* Definiá∆o das vair†veis para setContraint 17 e 18 */
def var i-cod-emit-fim   as int  no-undo.
def var c-nome-abrev-ini as char no-undo.
def var c-nome-abrev-fim as char no-undo.

/* Definiá∆o das vari†veis para setContraint22 */
def var i-cod-gr-cli  as integer  no-undo.

/*Definicao das variaveis para a setConstraint24*/
def var i-cod-emitente-ini  as integer no-undo.
def var i-cod-emitente-fim  as integer no-undo.
def var c-nome-emit-ini     as char no-undo.
def var c-nome-emit-fim     as char no-undo.
def var c-cgc-ini           as char no-undo.
def var c-cgc-fim           as char no-undo.
def var i-ordena            as integer no-undo.

/*Definicao das variaveis para a setConstraint27*/
def var i-cod-fornec        as int no-undo.

/*Definicao das variaveis para a setConstraint28*/
def var i-cod-gr-forn-ini  as integer no-undo.
def var i-cod-gr-forn-fim  as integer no-undo.
def var c-nome-matriz-ini  as char no-undo.
def var c-nome-matriz-fim  as char no-undo.

/*Definicao das variaveis para a setConstraint29*/
def var i-cod-repre  as integer no-undo.

/** Bloqueio de fornecedores - 205 **/
&if defined (bf_mat_bloqueio_fornec) &then

    def var l-mostra-ativos                 as log  initial yes   no-undo.
    def var l-mostra-restr-compras          as log  initial yes   no-undo.
    def var l-mostra-restr-compras-recebim  as log  initial yes   no-undo.
    def var l-mostra-inativos               as log  initial yes   no-undo.
    def var da-data-restricao               as date initial today no-undo.
    def var l-modulo-cc                     as log  initial yes   no-undo.
    def var l-modulo-cn                     as log  initial yes   no-undo.
    def var l-modulo-re                     as log  initial yes   no-undo.
    def var h-boin682                       as handle             no-undo.

&endif

{utils/parseStringToInteger.i}

procedure setConstraint1:
end procedure.

procedure setConstraint2:    
   def input param p-cod-emit as char no-undo.
   def input param p-cod-repres as char no-undo.
   
   assign i-cod-emit = int(p-cod-emit)
          i-cod-repres = integer(p-cod-repres).
end procedure.

procedure setConstraint3:
/*** Carrega vari·veis para o Open Query 3 ***/
  def input parameter p-inicial  as integer no-undo.
  def input parameter p-inicial2 as integer no-undo.  
   assign c-inicial  = p-inicial
          c-inicial2 = p-inicial2.				     
end procedure.
 
procedure setConstraint4:
  def input param p-chave-pai as char no-undo.
 
  assign r-chave-pai   = to-rowid(p-chave-pai).  
end procedure.

procedure setConstraint5:    
   def input param p-nome-abrev as char no-undo.
   assign c-nome-abrev = p-nome-abrev.
end procedure.

procedure setConstraint6:
end procedure.

procedure setConstraint7:
end procedure.

procedure setConstraint8:
end procedure.

procedure setConstraint9:
end procedure.

procedure setConstraint10:
   def input parameter p-ext-perfil-usuario as char no-undo.
   
   assign v-ext-perfil-usuar     = p-ext-perfil-usuario.
end procedure.

procedure setConstraint11:
end procedure.

procedure setConstraint12:    
   def input parameter p-codigo_inicial  as char no-undo.
   def input parameter p-nome_inicial as char no-undo.  

   assign i-codigo  = int(p-codigo_inicial)
          c-nome    = p-nome_inicial.
end procedure.

procedure setConstraint13:
end procedure.

procedure setConstraint14:
   def input param p-cod-emit as char no-undo.
   assign i-cod-emit = int(p-cod-emit).
end procedure.

def var i-cod-rep as int .
procedure setConstraint15:
  def input param p-cod-rep  as char no-undo.
  def input param p-cod-cli   as char no-undo.
  
  assign i-cod-rep   = int(p-cod-rep)
         i-cod-cli     = int(p-cod-cli).		  
end procedure.

procedure setConstraint16:
   def input param p-cod-emit-ini   as int no-undo.
   def input param p-cod-emit-fin   as int no-undo.
   def input param p-identific      as int no-undo.
   
   assign i-cod-emit-ini = p-cod-emit-ini
          i-cod-emit-fin = p-cod-emit-fin
          i-identific    = p-identific.
   &if defined(bf-mat-comex) &then
       IF i-identific = 1 THEN
           ASSIGN c-identific = "C":U.
       IF i-identific = 2 THEN 
           ASSIGN c-identific = "F":U.
       IF i-identific = 3 THEN 
           ASSIGN c-identific = "A":U.
   &endif

end procedure.

procedure setConstraint17:
def input param p-cod-emit-ini   as int no-undo.
def input param p-cod-emit-fim   as int no-undo.
def input param p-nome-abrev-ini as char no-undo.
def input param p-nome-abrev-fim as char no-undo.

   assign i-cod-emit-ini   = p-cod-emit-ini  
          i-cod-emit-fim   = p-cod-emit-fim  
          c-nome-abrev-ini = p-nome-abrev-ini
          c-nome-abrev-fim = p-nome-abrev-fim.
end procedure.

procedure setConstraint18:
def input param p-cod-emit-ini   as int no-undo.
def input param p-cod-emit-fim   as int no-undo.
def input param p-nome-abrev-ini as char no-undo.
def input param p-nome-abrev-fim as char no-undo.

   assign i-cod-emit-ini   = p-cod-emit-ini  
          i-cod-emit-fim   = p-cod-emit-fim  
          c-nome-abrev-ini = p-nome-abrev-ini
          c-nome-abrev-fim = p-nome-abrev-fim.
end procedure.

procedure setConstraint19:
def input param p-cod-emit-ini   as int no-undo.
def input param p-cod-emit-fim   as int no-undo.

   assign i-cod-emit-ini   = p-cod-emit-ini  
          i-cod-emit-fim   = p-cod-emit-fim.
end procedure.

procedure setConstraint20:
def input param p-cod-emit-ini   as int  no-undo.
def input param p-cod-emit-fim   as int  no-undo.
def input param p-nome-abrev-ini as char no-undo.
def input param p-nome-abrev-fim as char no-undo.
def input param p-cod-rep        as int  no-undo.

   assign i-cod-emit-ini   = p-cod-emit-ini  
          i-cod-emit-fim   = p-cod-emit-fim  
          c-nome-abrev-ini = p-nome-abrev-ini
          c-nome-abrev-fim = p-nome-abrev-fim
          i-cod-rep        = p-cod-rep.
end procedure.

procedure setConstraint21:
    def input parameter p-ext-perfil-usuario as char no-undo.
    def input parameter p-ext-perfil-identific as int no-undo.
   
    assign v-ext-perfil-usuar     = p-ext-perfil-usuario
           v-ext-perfil-identific = p-ext-perfil-identific.
end procedure.

procedure setConstraint22:
/*======== Suleyka Sterzo Cavalcanti ========*/
        /* programa => wpd0910a.w  */
   def input parameter p-i-cod-gr-cli   as integer      no-undo.

   assign i-cod-gr-cli = p-i-cod-gr-cli.
end procedure.

/***********************************************************/
define var i-ini   as char    no-undo.
define var c-ini   as char    no-undo.
define var c-ini2  as char    no-undo.
define var i-ini2  as char    no-undo.
define var c-ini3  as char    no-undo.

procedure setConstraint23:
def input param p-ini    as integer   no-undo.
def input param p-ini1   as char      no-undo.
def input param p-ini2   as char      no-undo.
def input param p-ini3   as integer   no-undo.
def input param p-ini4   as char      no-undo.

   assign i-ini  = string(p-ini)
          c-ini  = p-ini1
          c-ini2 = p-ini2
          i-ini2 = string(p-ini3)
          c-ini3 = p-ini4.
end procedure.
/***********************************************************/

procedure setConstraint24:
   def input parameter p-cod-emitente-ini     as int no-undo.
   def input parameter p-cod-emitente-fim     as int no-undo.
   def input parameter p-nome-abrev-ini       as char no-undo.
   def input parameter p-nome-abrev-fim       as char no-undo.
   def input parameter p-cgc-ini              as char no-undo.
   def input parameter p-cgc-fim              as char no-undo.
   def input parameter p-nome-emit-ini        as char no-undo.
   def input parameter p-nome-emit-fim        as char no-undo.
   def input parameter p-ordena               as int  no-undo.   

   assign  i-cod-emitente-ini   = p-cod-emitente-ini
           i-cod-emitente-fim   = p-cod-emitente-fim
           c-nome-abrev-ini     = p-nome-abrev-ini
           c-nome-abrev-fim     = p-nome-abrev-fim
           c-cgc-ini            = p-cgc-ini
           c-cgc-fim            = p-cgc-fim
           c-nome-emit-ini      = p-nome-emit-ini
           c-nome-emit-fim      = p-nome-emit-fim
           i-ordena             = p-ordena.
end procedure.

def var i-repres   as char no-undo.
def var i-repres1  as char no-undo.
def var i-repres2  as char no-undo.
def var i-repres3  as char no-undo.
def var i-repres4  as char no-undo.
def var c-repres   as integer no-undo.
procedure setConstraint25:    
   def input param p-cod-emit   as integer no-undo.
   def input param p-cod-emit1  as char no-undo.
   def input param p-cod-emit2  as char no-undo.
   def input param p-cod-emit3  as integer no-undo.
   def input param p-cod-emit4  as char no-undo.
   def input param p-cod-repres as char no-undo.
           
   assign i-repres     = string(p-cod-emit)
          i-repres1    = p-cod-emit1
          i-repres2    = p-cod-emit2
          i-repres3    = string(p-cod-emit3)
          i-repres4    = p-cod-emit4          
          c-repres     = integer(p-cod-repres).
end procedure.

def var i-cliente   as char no-undo.
def var i-cliente1  as char no-undo.
def var i-cliente2  as char no-undo.
def var i-cliente3  as char no-undo.
def var i-cliente4  as char no-undo.
def var c-cli       as integer no-undo.
procedure setConstraint26:    
   def input param p-cod-emit   as integer no-undo.
   def input param p-cod-emit1  as char no-undo.
   def input param p-cod-emit2  as char no-undo.
   def input param p-cod-emit3  as integer no-undo.
   def input param p-cod-emit4  as char no-undo.
   def input param p-cli as char no-undo.
           
   assign i-cliente    = string(p-cod-emit)
          i-cliente1   = p-cod-emit1
          i-cliente2   = p-cod-emit2
          i-cliente3   = string(p-cod-emit3)
          i-cliente4   = p-cod-emit4          
          c-cli        = integer(p-cli).
end procedure.

procedure setConstraint27:    
   def input parameter pi-cod-fornec  as int no-undo.
   def input parameter pc-nome as char no-undo.  

   assign i-cod-fornec  = pi-cod-fornec
          c-nome        = pc-nome.
end procedure.

procedure setConstraint28:
   def input parameter p-cod-emitente-ini     as int no-undo.
   def input parameter p-cod-emitente-fim     as int no-undo.
   def input parameter p-nome-abrev-ini       as char no-undo.
   def input parameter p-nome-abrev-fim       as char no-undo.
   def input parameter p-cgc-ini              as char no-undo.
   def input parameter p-cgc-fim              as char no-undo.
   def input parameter p-nome-emit-ini        as char no-undo.
   def input parameter p-nome-emit-fim        as char no-undo.
   def input parameter p-cod-gr-forn-ini      as int no-undo.
   def input parameter p-cod-gr-forn-fim      as int no-undo.
   def input parameter p-nome-matriz-ini      as char no-undo.
   def input parameter p-nome-matriz-fim      as char no-undo.
   def input parameter p-ordena               as int  no-undo.   

   assign  i-cod-emitente-ini   = p-cod-emitente-ini
           i-cod-emitente-fim   = p-cod-emitente-fim
           c-nome-abrev-ini     = p-nome-abrev-ini
           c-nome-abrev-fim     = p-nome-abrev-fim
           c-cgc-ini            = p-cgc-ini
           c-cgc-fim            = p-cgc-fim
           c-nome-emit-ini      = p-nome-emit-ini
           c-nome-emit-fim      = p-nome-emit-fim
           i-cod-gr-forn-ini    = p-cod-gr-forn-ini
           i-cod-gr-forn-fim    = p-cod-gr-forn-fim
           c-nome-matriz-ini    = p-nome-matriz-ini
           c-nome-matriz-fim    = p-nome-matriz-fim
           i-ordena             = p-ordena.
end procedure.

procedure setConstraint29:
   def input parameter p-cod-emitente-ini     as int no-undo.
   def input parameter p-cod-emitente-fim     as int no-undo.
   def input parameter p-nome-abrev-ini       as char no-undo.
   def input parameter p-nome-abrev-fim       as char no-undo.
   def input parameter p-cgc-ini              as char no-undo.
   def input parameter p-cgc-fim              as char no-undo.
   def input parameter p-nome-emit-ini        as char no-undo.
   def input parameter p-nome-emit-fim        as char no-undo.
   def input parameter p-cod-gr-forn-ini      as int no-undo.
   def input parameter p-cod-gr-forn-fim      as int no-undo.
   def input parameter p-nome-matriz-ini      as char no-undo.
   def input parameter p-nome-matriz-fim      as char no-undo.
   def input parameter p-ordena               as int  no-undo.   
   def input parameter p-cod-repre            as int  no-undo.   

   assign  i-cod-emitente-ini   = p-cod-emitente-ini
           i-cod-emitente-fim   = p-cod-emitente-fim
           c-nome-abrev-ini     = p-nome-abrev-ini
           c-nome-abrev-fim     = p-nome-abrev-fim
           c-cgc-ini            = p-cgc-ini
           c-cgc-fim            = p-cgc-fim
           c-nome-emit-ini      = p-nome-emit-ini
           c-nome-emit-fim      = p-nome-emit-fim
           i-cod-gr-forn-ini    = p-cod-gr-forn-ini
           i-cod-gr-forn-fim    = p-cod-gr-forn-fim
           c-nome-matriz-ini    = p-nome-matriz-ini
           c-nome-matriz-fim    = p-nome-matriz-fim
           i-ordena             = p-ordena
           i-cod-repre          = p-cod-repre.
end procedure.

procedure setConstraint41:
  def input param p-cod-emitente as int no-undo.
  assign i-codigo = p-cod-emitente.
end procedure.

procedure setConstraint42:
  def input param p-identif as int no-undo.
  assign i-identific = p-identif.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        /******************************ATENCAO*******************************************
         aqui dever∆o ser cadastradas openqueries utilizadas pelo EMS e pelo Magnus
        ********************************************************************************/                
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock indexed-reposition.
        when 99 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                    where {&TABLE-NAME}.cod-emitente = int(v-ext-perfil-usuar) indexed-reposition.
        when 12 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                              {&TABLE-NAME}.cod-emitente >= i-codigo AND 
                                              {&TABLE-NAME}.nome-abrev >= c-nome NO-LOCK indexed-reposition. 	    
        when 18 then 
            if i-cod-emit-ini = i-cod-emit-fim then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim
                                                  NO-LOCK by nome-abrev indexed-reposition.	
            else do:
                if c-nome-abrev-ini = c-nome-abrev-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini and
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   
                                                      NO-LOCK by nome-abrev indexed-reposition.	
                else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim
                                                      NO-LOCK by nome-abrev indexed-reposition.	
            end.                                      
        when 19 then 
            if i-cod-emit-ini = i-cod-emit-fim then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini no-lock by {&TABLE-NAME}.cod-emitente indexed-reposition.						     
            else
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim no-lock by {&TABLE-NAME}.cod-emitente indexed-reposition.						     
        when 31 then  /*** Fornecedor Estrangeiro/Trading por C¢digo ***/
            if i-cod-emit-ini = i-cod-emit-fim then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                  &if defined(bf-mat-comex) &then
                                                     {&table-name}.identific    <> "C"           and
                                                     ({&TABLE-NAME}.natureza     = "E"           or
                                                     {&TABLE-NAME}.natureza      = "T")
                                                  &else
                                                     {&table-name}.identific    <> 1             and
                                                     ({&TABLE-NAME}.natureza     = 3             or
                                                     {&TABLE-NAME}.natureza      = 4)
                                                  &endif
                                                  NO-LOCK USE-INDEX codigo indexed-reposition.
            else    
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                  &if defined(bf-mat-comex) &then
                                                     {&table-name}.identific    <> "C"           and
                                                     ({&TABLE-NAME}.natureza     = "E"           or
                                                     {&TABLE-NAME}.natureza      = "T")
                                                  &else
                                                     {&table-name}.identific    <> 1             and
                                                     ({&TABLE-NAME}.natureza     = 3             or
                                                     {&TABLE-NAME}.natureza      = 4)
                                                  &endif
                                                  NO-LOCK USE-INDEX codigo indexed-reposition.
    	 when 32 then  /*** Fornecedor Estrangeiro/Trading por Nome ***/
    	     if  i-cod-emit-ini = i-cod-emit-fim then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                  &if defined(bf-mat-comex) &then
                                                     {&table-name}.identific    <> "C"           and
                                                     ({&TABLE-NAME}.natureza     = "E"           or
                                                     {&TABLE-NAME}.natureza      = "T")
                                                  &else
                                                     {&table-name}.identific    <> 1             and
                                                     ({&TABLE-NAME}.natureza     = 3             or
                                                     {&TABLE-NAME}.natureza      = 4)
                                                  &endif
                                                  NO-LOCK by nome-abrev indexed-reposition.
    	     else 
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                  &if defined(bf-mat-comex) &then
                                                     {&table-name}.identific    <> "C"           and
                                                     ({&TABLE-NAME}.natureza     = "E"           or
                                                     {&TABLE-NAME}.natureza      = "T")
                                                  &else
                                                     {&table-name}.identific    <> 1             and
                                                     ({&TABLE-NAME}.natureza     = 3             or
                                                     {&TABLE-NAME}.natureza      = 4)
                                                  &endif
                                                  NO-LOCK by nome-abrev indexed-reposition.
        &if defined(bf-mat-comex) &then            
           	when 29 then   /*** Fornecedor por C¢digo ***/
    	       if i-cod-emit-ini = i-cod-emit-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&table-name}.identific    <> "C"
                                                      NO-LOCK by {&TABLE-NAME}.cod-emitente indexed-reposition.
    	       else do:
    	         if c-nome-abrev-ini = c-nome-abrev-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini and
                                                      {&table-name}.identific    <> "C"
                                                      NO-LOCK by {&TABLE-NAME}.cod-emitente indexed-reposition.
    	         else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&table-name}.identific    <> "C"
                                                      NO-LOCK USE-INDEX codigo indexed-reposition.
               end.                                      
            when 30 then  /*** Fornecedor por Nome ***/
               if i-cod-emit-ini = i-cod-emit-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&table-name}.identific    <> "C"
                                                      NO-LOCK by {&TABLE-NAME}.nome-abrev indexed-reposition.            
               else
                   if c-nome-abrev-ini = c-nome-abrev-fim then
                        open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                          {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                          {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                          {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini and
                                                          {&table-name}.identific    <> "C"
                                                          NO-LOCK by {&TABLE-NAME}.nome-abrev indexed-reposition.               
                   else
                        open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                          {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                          {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                          {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                          {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                          {&table-name}.identific    <> "C"
                                                          NO-LOCK by {&TABLE-NAME}.nome-abrev indexed-reposition.
                    

            when 34 then 
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                  {&table-name}.identific <> "F" and 
                                                  (emitente.natureza = "E" or emitente.natureza = "T")
                                                  NO-LOCK by {&TABLE-NAME}.nome-abrev
       					            by {&TABLE-NAME}.cod-emitente indexed-reposition.	
            when 35 then 
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim and
                                                  {&table-name}.identific <> "F" and 
                                                  (emitente.natureza =  "E" or emitente.natureza = "T") no-lock 
    						     by {&TABLE-NAME}.cod-emitente
    						     by {&TABLE-NAME}.nome-abrev indexed-reposition. 
            when 36 then 
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                  {&table-name}.identific <> "F" and 
                                                  (emitente.natureza = "E" or emitente.natureza = "T")
                                                  NO-LOCK by {&TABLE-NAME}.nome-abrev
       					            by {&TABLE-NAME}.nome-abrev indexed-reposition.
        
        &else
            /******************************ATENCAO*******************************************
             aqui dever∆o ser cadastradas openqueries somente utilizadas pelo EMS, ou seja,
              o Magnus n∆o utiliza 
            ********************************************************************************/            
            when 2 then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  emitente.cod-emitente >= i-cod-emit AND 
                                                  emitente.identific    <> 1 indexed-reposition.
            when 3 then
                open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where 
                                                  emitente.portador   = c-inicial AND 
                                                  emitente.modalidade = c-inicial2
                                                  by emitente.nome-emit indexed-reposition.
            when 4 then do:
                /* Posiciona no registro do pai */
                if not valid-handle (h-boad229) then 
                    run adbo/boad229.p persistent set h-boad229.
                run findRowid  in h-boad229 (input r-chave-pai).
                run getCurrent in h-boad229 (output table {&PARENT-TABLE}).
                if valid-handle (h-boad229) then do:
                    delete procedure h-boad229.		
                                     h-boad229 = ?.
                end.

                for first {&PARENT-TABLE} fields(cod-rep) no-lock: end.
                if avail {&PARENT-TABLE} then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 			
                                                      {&TABLE-NAME}.cod-rep = {&PARENT-TABLE}.cod-rep and 
                                                      {&table-name}.identific <> 2
                                                      no-lock indexed-reposition.      
    	    end.
            when 5 then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  emitente.nome-abrev >= c-nome-abrev and 
                                                  (emitente.natureza   =  3 or emitente.natureza = 4) no-lock indexed-reposition.
            when 6 then 
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  emitente.identific <> 1 NO-LOCK indexed-reposition.   
            when 7 then 
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  {&table-name}.identific <> 2 NO-LOCK indexed-reposition.
            when 8 then  
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  {&TABLE-NAME}.nome-matriz = c-nome-abrev NO-LOCK indexed-reposition.
            when 9 then 
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente >= i-cod-emit and
                                                  {&table-name}.identific <> 2 NO-LOCK indexed-reposition.
            when 10 then 
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-rep    = int(v-ext-perfil-usuar) AND
                                                  {&table-name}.identific <> 2 NO-LOCK indexed-reposition.
            when 11 then 
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente >= i-cod-emit and
                                                  {&table-name}.identific    <> 2          and 
                                                  {&TABLE-NAME}.cod-rep   = i-cod-repres NO-LOCK
                                                  BY {&table-name}.nome-abrev  indexed-reposition.
           when 13 then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome     and
                                                  {&TABLE-NAME}.cod-emitente >= i-codigo   and 
                                                  {&table-name}.identific    <> 1 indexed-reposition.
           when 14 then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente = int(i-cod-emit) AND
                                                  {&table-name}.identific <> 2 NO-LOCK
                                                  BY {&table-name}.nome-abrev  indexed-reposition.
            when 15 then 
    	     open query {&QUERY-NAME} for each {&TABLE-NAME} where 	
                                                  {&TABLE-NAME}.cod-rep = i-cod-rep and 
                                                  {&TABLE-NAME}.cod-emitente = i-cod-cli NO-LOCK indexed-reposition.
            when 16 then 
                if i-cod-emit-ini = i-cod-emit-fin then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini and
                                                      {&table-name}.identific    =  i-identific    NO-LOCK indexed-reposition.	                
                else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fin and
                                                      {&table-name}.identific    =  i-identific    NO-LOCK indexed-reposition.	
            when 17 then 
                if i-cod-emit-ini = i-cod-emit-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and 
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim 
                                                      NO-LOCK USE-INDEX codigo indexed-reposition.	                
                else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and 
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim 
                                                      NO-LOCK USE-INDEX codigo indexed-reposition.	
            when 20 then 
                if i-cod-emit-ini = i-cod-emit-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and 
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&TABLE-NAME}.cod-rep       =  i-cod-rep
                                                      NO-LOCK by {&TABLE-NAME}.cod-emitente indexed-reposition.	
                else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and 
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&TABLE-NAME}.cod-rep       = i-cod-rep
                                                      NO-LOCK by {&TABLE-NAME}.cod-emitente indexed-reposition.	
            when 21 then 
                if i-cod-emit-ini = i-cod-emit-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&TABLE-NAME}.cod-rep       =  i-cod-rep
                                                      NO-LOCK by {&TABLE-NAME}.nome-abrev indexed-reposition.                         
                else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&TABLE-NAME}.cod-rep       =  i-cod-rep
                                                      NO-LOCK by {&TABLE-NAME}.nome-abrev indexed-reposition.                         
            when 22 then
                if i-cod-emit-ini = i-cod-emit-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and ~
                                                      {&table-name}.identific <> 2 and ~
                                                      (emitente.natureza   =  3 or emitente.natureza = 4) no-lock indexed-reposition.                
                else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and ~
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and ~
                                                      {&table-name}.identific <> 2 and ~
                                                      (emitente.natureza   =  3 or emitente.natureza = 4) no-lock indexed-reposition.
            when 23 then 
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente  = int(v-ext-perfil-usuar) AND
                                                  {&table-name}.identific <>  v-ext-perfil-identific NO-LOCK indexed-reposition.    
            when 24 then
                open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                            where {&TABLE-NAME}.cod-gr-cli = i-cod-gr-cli no-lock
                                            BY {&table-name}.nome-abrev  indexed-reposition.
            when 25 then do:               
                if i-ini <> "0" then            
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.cod-emitente >= int(i-ini)
                          and emitente.identific <> 2 no-lock BY emitente.cod-emitente indexed-reposition.    
                                 
                if c-ini <> "" then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.nome-abrev >= c-ini
                          and emitente.identific <> 2 no-lock BY emitente.nome-abrev indexed-reposition. 
                          
                if c-ini2 <> "" then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.cgc       >= c-ini2
                          and emitente.identific <> 2 no-lock BY emitente.cgc indexed-reposition.
                          
                if i-ini2 <> "0" then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.cod-gr-cli >= int(i-ini2)
                          and emitente.identific <> 2 no-lock BY emitente.cod-gr-cli indexed-reposition.
                          
                if c-ini3 <> "" then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.nome-emit >= c-ini3
                          and emitente.identific <> 2  no-lock BY emitente.nome-emit indexed-reposition. 
                                    
                if i-ini = "0" and c-ini = "" and c-ini2 = "" and i-ini2 = "0" and c-ini3 = "" then                 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                                                     
                              emitente.identific <> 2 no-lock BY emitente.cod-emitente indexed-reposition.
    	end. 
           when 26 then do:
                if i-ordena = 1 then do:
                   if i-cod-emitente-ini = i-cod-emitente-fim then
                        open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                    where {&TABLE-NAME}.cod-emitente  = i-cod-emitente-ini   and
                                                          {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                          {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                          {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                          {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                          {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                          {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                          {&table-name}.identific    <> 1 no-lock
                                                          by {&TABLE-NAME}.cod-emitente indexed-reposition.  
                   else do:
                       if c-nome-abrev-ini = c-nome-abrev-fim then
                            open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                        where {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini     and
                                                              {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                              {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                              {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                              {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                              {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                              {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                              {&table-name}.identific    <> 1 no-lock
                                                              by {&TABLE-NAME}.cod-emitente indexed-reposition.  
                       else do:
                            if c-cgc-ini = c-cgc-fim then
                                open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                            where {&TABLE-NAME}.cgc           = c-cgc-ini            and
                                                                  {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and                                                                  
                                                                  {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                                  {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                                  {&table-name}.identific    <> 1 no-lock
                                                                  by {&TABLE-NAME}.cod-emitente indexed-reposition.  
                            else
                                open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                            where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                                  {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                                  {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                                  {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                                  {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                                  {&table-name}.identific    <> 1 no-lock
                                                                  by {&TABLE-NAME}.cod-emitente indexed-reposition.  
                       end.                               
                   end.                                   
                end.   
    	         if i-ordena = 2 then do:
    	            if i-cod-emitente-ini = i-cod-emitente-fim then  
                        open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                    where {&TABLE-NAME}.cod-emitente  = i-cod-emitente-ini   and
                                                          {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                          {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                          {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                          {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                          {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                          {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                          {&table-name}.identific    <> 1 no-lock
                                                          by nome-abrev indexed-reposition.	
    	            else do:
    	               if c-nome-abrev-ini = c-nome-abrev-fim then
                            open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                        where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                              {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                              {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini     and
                                                              {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                              {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                              {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                              {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                              {&table-name}.identific    <> 1 no-lock
                                                              by nome-abrev indexed-reposition.	
    	               else do:
    	                  if c-cgc-ini = c-cgc-fim then
                            open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                        where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                              {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                              {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                              {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                              {&TABLE-NAME}.cgc           = c-cgc-ini            and
                                                              {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                              {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                              {&table-name}.identific    <> 1 no-lock
                                                              by {&TABLE-NAME}.nome-abrev indexed-reposition.	
                         else
                            open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                        where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                              {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                              {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                              {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                              {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                              {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                              {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                              {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                              {&table-name}.identific    <> 1 no-lock
                                                              by {&TABLE-NAME}.nome-abrev indexed-reposition.	
                      end.                                
                   end.                                    
                end.                                      
                if i-ordena = 3 then do:
                   if i-cod-emitente-ini = i-cod-emitente-fim then
                        open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                    where {&TABLE-NAME}.cod-emitente  = i-cod-emitente-ini   and
                                                          {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                          {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                          {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                          {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                          {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                          {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                          {&table-name}.identific    <> 1 no-lock
                                                          by cgc indexed-reposition.
                   else do:
                      if c-nome-abrev-ini = c-nome-abrev-fim then
                          open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                      where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                            {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                            {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini     and
                                                            {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                            {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                            {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                            {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                            {&table-name}.identific    <> 1 no-lock
                                                            by cgc indexed-reposition.
                      
                      else do:
                         if c-cgc-ini = c-cgc-fim then
                            open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                        where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                              {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                              {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                              {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                              {&TABLE-NAME}.cgc           = c-cgc-ini            and
                                                              {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                              {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                              {&table-name}.identific    <> 1 no-lock
                                                              by cgc indexed-reposition.
                         
                         else
                            open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                        where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                              {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                              {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                              {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                              {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                              {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                              {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                              {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                              {&table-name}.identific    <> 1 no-lock
                                                              by cgc indexed-reposition.
                      end.
                   end.   
                end.                                      
                if i-ordena = 4 then do: 
                   if i-cod-emitente-ini = i-cod-emitente-fim then
                        open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                    where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                          {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                          {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                          {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                          {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                          {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                          {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                          {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                          {&table-name}.identific    <> 1 no-lock
                                                          by nome-emit indexed-reposition.                                            
                   else do:
                       if c-nome-abrev-ini = c-nome-abrev-fim then 
                            open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                        where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                              {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                              {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini     and
                                                              {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                              {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                              {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                              {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                              {&table-name}.identific    <> 1 no-lock
                                                              by nome-emit indexed-reposition.                                            
                       else do:
                           if c-cgc-ini = c-cgc-fim then
                                open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                            where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                                  {&TABLE-NAME}.cgc           = c-cgc-ini            and
                                                                  {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                                  {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                                  {&table-name}.identific    <> 1 no-lock
                                                                  by nome-emit indexed-reposition.                                            
                           else 
                                open query {&QUERY-NAME} for each {&TABLE-NAME}  
                                                            where {&TABLE-NAME}.cod-emitente >= i-cod-emitente-ini   and
                                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emitente-fim   and
                                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini     and
                                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim     and
                                                                  {&TABLE-NAME}.cgc          >= c-cgc-ini            and
                                                                  {&TABLE-NAME}.cgc          <= c-cgc-fim            and
                                                                  {&TABLE-NAME}.nome-emit    >= c-nome-emit-ini      and
                                                                  {&TABLE-NAME}.nome-emit    <= c-nome-emit-fim      and 
                                                                  {&table-name}.identific    <> 1 no-lock
                                                                  by nome-emit indexed-reposition.                                            
                       end.                                      
                   end.
                end.
           end.  /*when 26*/
           when 27 then do:               
                if i-repres <> "0" then            
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.cod-emitente >= int(i-repres)
                          and emitente.cod-rep       = c-repres    
                          and emitente.identific    <> 2 no-lock BY emitente.cod-emitente indexed-reposition.    
                                 
                if i-repres1 <> "" then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.nome-abrev >= i-repres1
                          and emitente.cod-rep     = c-repres
                          and emitente.identific   <> 2 no-lock BY emitente.nome-abrev indexed-reposition. 
                          
                if i-repres2 <> "" then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.cgc       >= i-repres2
                          and emitente.cod-rep    = c-repres    
                          and emitente.identific <> 2 no-lock BY emitente.cgc indexed-reposition.
                          
                if i-repres3 <> "0" then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.cod-gr-cli >= int(i-repres3)
                          and emitente.cod-rep     = c-repres    
                          and emitente.identific  <> 2 no-lock BY emitente.cod-gr-cli indexed-reposition.
                          
                if i-repres4 <> "" then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.nome-emit >= i-repres4
                          and emitente.cod-rep    = c-repres    
                          and emitente.identific <> 2  no-lock BY emitente.nome-emit indexed-reposition. 
                                    
                if i-repres = "0" and i-repres1 = "" and i-repres2 = "" and i-repres3 = "0" and i-repres4 = "" then                 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                                                     
                              emitente.cod-rep       = c-repres
                          and emitente.identific <> 2 no-lock BY cod-emitente indexed-reposition.
    	end. 	
    	when 28 then do:               
                if i-cliente <> "0":U then            
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.cod-emitente >= int(i-cliente)
                          and emitente.cod-emitente  = c-cli    
                          and emitente.identific   <> 2 no-lock BY emitente.cod-emitente indexed-reposition.    
                if i-cliente1 <> "":U then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.nome-abrev   >= i-cliente1
                          and emitente.cod-emitente  = c-cli
                          and emitente.identific   <> 2 no-lock BY emitente.nome-abrev indexed-reposition. 
                if i-cliente2 <> "":U then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.cgc          >= i-cliente2
                          and emitente.cod-emitente  = c-cli    
                          and emitente.identific    <> 2 no-lock BY emitente.cgc indexed-reposition.
                if i-cliente3 <> "0":U then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.cod-gr-cli   >= int(i-cliente3)
                          and emitente.cod-emitente  = c-cli    
                          and emitente.identific    <> 2 no-lock BY emitente.cod-gr-cli indexed-reposition.
                if i-cliente4 <> "":U then 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                              emitente.nome-emit    >= i-cliente4
                          and emitente.cod-emitente  = c-cli    
                          and emitente.identific    <> 2  no-lock BY emitente.nome-emit indexed-reposition. 
                if i-cliente = "0" and i-cliente1 = "" and i-cliente2= "" and i-cliente3 = "0" and i-cliente4 = "" then                 
                   open query {&QUERY-NAME} for each {&TABLE-NAME} where                                                     
                              emitente.cod-emitente  = c-cli
                          and emitente.identific    <> 2 no-lock BY cod-emitente indexed-reposition.
    	end. 	
    	when 29 then   /*** Fornecedor por C¢digo ***/
    	     if i-cod-emit-ini = i-cod-emit-fim then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                  {&table-name}.identific    <> 1
                                                  NO-LOCK USE-INDEX codigo {&v9indrep}.
    	     else do:
    	         if c-nome-abrev-ini = c-nome-abrev-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini and
                                                      {&table-name}.identific    <> 1
                                                      NO-LOCK USE-INDEX codigo {&v9indrep}.
    	         else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&table-name}.identific    <> 1
                                                      NO-LOCK USE-INDEX codigo {&v9indrep}.
            end.                                      
       when 30 then  /*** Fornecedor por Nome ***/
            if i-cod-emit-ini = i-cod-emit-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&table-name}.identific    <> 1
                                                      NO-LOCK USE-INDEX nome {&v9indrep}.
            else
               if c-nome-abrev-ini = c-nome-abrev-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini and
                                                      {&table-name}.identific    <> 1
                                                      NO-LOCK USE-INDEX nome {&v9indrep}.
               else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&table-name}.identific    <> 1
                                                      NO-LOCK USE-INDEX nome {&v9indrep} .
       when 33 then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente = i-cod-fornec and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome NO-LOCK indexed-reposition.
       when 34 then 
            if i-cod-emit-ini = i-cod-emit-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                      {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                      (emitente.natureza   =  3 or emitente.natureza = 4)and
                                                      &IF ("&emsdbtype") <> "Progress"  &THEN
                                                          (({&TABLE-NAME}.nome-abrev   > c-nome-abrev-ini) or
                                                          ({&TABLE-NAME}.nome-abrev   = c-nome-abrev-ini)) and
                                                          (({&TABLE-NAME}.nome-abrev   < c-nome-abrev-fim) or
                                                          ({&TABLE-NAME}.nome-abrev   = c-nome-abrev-fim)) and
                                                          {&table-name}.identific <> 2
                                                      NO-LOCK USE-INDEX nome. 
                                                      &else
                                                          {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                          {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                          {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                          {&table-name}.identific <> 2                                       
                                                      NO-LOCK USE-INDEX nome {&v9indrep}.
                                                      &endif
            else do:
                if c-nome-abrev-ini = c-nome-abrev-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini and
                                                      {&table-name}.identific <> 2 and 
                                                      (emitente.natureza   =  3 or emitente.natureza = 4) and
                                                       &IF ("&emsdbtype") <> "Progress"  &THEN
                                                           (({&TABLE-NAME}.cod-emitente > i-cod-emit-ini) or
                                                           ({&TABLE-NAME}.cod-emitente = i-cod-emit-ini)) and
                                                           (({&TABLE-NAME}.cod-emitente < i-cod-emit-fim) or 
                                                           ({&TABLE-NAME}.cod-emitente = i-cod-emit-fim))
                                                       NO-LOCK USE-INDEX nome.
                                                       &else
                                                           {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                           {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim
                                                       NO-LOCK USE-INDEX nome {&v9indrep}.	  
                                                       &endif
                else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&table-name}.identific <> 2 and 
                                                      (emitente.natureza   =  3 or emitente.natureza = 4) and
                                                      &IF ("&emsdbtype") <> "Progress"  &THEN
                                                         (({&TABLE-NAME}.cod-emitente > i-cod-emit-ini)   or
                                                         ({&TABLE-NAME}.cod-emitente = i-cod-emit-ini))   and
                                                         (({&TABLE-NAME}.cod-emitente < i-cod-emit-fim)   or
                                                         ({&TABLE-NAME}.cod-emitente = i-cod-emit-fim))   and
                                                         (({&TABLE-NAME}.nome-abrev   > c-nome-abrev-ini) or
                                                         ({&TABLE-NAME}.nome-abrev   = c-nome-abrev-ini)) and
                                                         (({&TABLE-NAME}.nome-abrev   < c-nome-abrev-fim) or
                                                         ({&TABLE-NAME}.nome-abrev   = c-nome-abrev-fim))
                                                      NO-LOCK use-index nome.	
                                                      &else
                                                         {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                         {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                         {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                         {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim 
                                                      NO-LOCK USE-INDEX nome {&v9indrep}.
                                                      &endif.
            end.     			                
       when 35 then 
            if i-cod-emit-ini = i-cod-emit-fim then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente = i-cod-emit-ini  and
                                                  {&table-name}.identific <> 2 and 
                                                  (emitente.natureza   =  3 or emitente.natureza = 4) no-lock 
    						                      USE-INDEX codigo {&v9indrep}.
            else
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&table-name}.identific <> 2 and 
                                                      (emitente.natureza   =  3 or emitente.natureza = 4) and
                                                  &IF ("&emsdbtype") <> "Progress"  &THEN
                                                      (({&TABLE-NAME}.cod-emitente > i-cod-emit-ini) or
                                                      ({&TABLE-NAME}.cod-emitente = i-cod-emit-ini)) and
                                                      (({&TABLE-NAME}.cod-emitente < i-cod-emit-fim) or
                                                      ({&TABLE-NAME}.cod-emitente = i-cod-emit-fim))
                                                      no-lock USE-INDEX codigo {&v9indrep}. 
                                                  &else
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim                        
                                                      no-lock USE-INDEX codigo {&v9indrep}.
                                                  &endif
       when 36 or
          when 38 then do:     
          if i-abertura = 36 then 
                assign  i-identific = 1.
            else if i-abertura = 38 then
                 assign i-identific = 2.
               
            run pi-abertura-36.     
        end.  /*when 36*/  /*when 38*/
        
        when 37 then do: 
            run pi-abertura-37.
        end.  /*when 37*/
        
        when 39 then   /*** Cliente por C¢digo ***/
             if i-cod-emit-ini = i-cod-emit-fim then do:
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                  {&table-name}.identific    <> 2
                                                  NO-LOCK by {&TABLE-NAME}.cod-emitente indexed-reposition.             
             end.
             else do:
                 if c-nome-abrev-ini = c-nome-abrev-fim then do:
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini and
                                                      {&table-name}.identific    <> 2
                                                      NO-LOCK by {&TABLE-NAME}.cod-emitente indexed-reposition.                 
                 end.
                 else do:
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&table-name}.identific    <> 2
                                                      NO-LOCK by {&TABLE-NAME}.cod-emitente indexed-reposition.
                 end.
             end.
        when 40 then  /*** Cliente por Nome ***/
             if i-cod-emit-ini = i-cod-emit-fim then do:
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                  {&table-name}.identific    <> 2
                                                  NO-LOCK by {&TABLE-NAME}.nome-abrev indexed-reposition.   
             end.
             else do:
                if c-nome-abrev-ini = c-nome-abrev-fim then do:
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini and
                                                      {&table-name}.identific    <> 2
                                                      NO-LOCK by {&TABLE-NAME}.nome-abrev indexed-reposition.   
                end.
                else do:
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim and
                                                      {&table-name}.identific    <> 2
                                                      NO-LOCK by {&TABLE-NAME}.nome-abrev indexed-reposition.   
                end.
            end.    
      when 41 then do:
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                            {&TABLE-NAME}.cod-emitente =  i-codigo and
                                            {&table-name}.identific    <> 2   NO-LOCK USE-INDEX codigo indexed-reposition.
      end.
      when 42 then do:
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                            {&table-name}.identific      <> 1
                                             NO-LOCK USE-INDEX codigo indexed-reposition.
      end. 
      when 43 then do: 
           run pi-abertura-43.
      end.  /*when 43*/
      when 44 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where 
                                                  emitente.portador   = c-inicial  AND 
                                                  emitente.modalidade = c-inicial2 AND
                                                  emitente.identific <> 2
                                                  by emitente.nome-emit indexed-reposition.  
      &endif     
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

/** Bloqueio de fornecedores - 205 **/
&if defined (bf_mat_bloqueio_fornec) &then

    if not valid-handle (h-boin682) then
        run inbo/boin682.p persistent set h-boin682.

    run openQueryStatic in h-boin682 (input "Main":U) no-error.
    run findFirst       in h-boin682.
    run getLogField     in h-boin682 (input "modulo-cc":U, output l-modulo-cc).
    run getLogField     in h-boin682 (input "modulo-cn":U, output l-modulo-cn).
    run getLogField     in h-boin682 (input "modulo-re":U, output l-modulo-re).

    procedure serverSendRows :
    /*
    **  Disponivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    */
        define input  parameter piStartRow     as  integer   no-undo.
        define input  parameter pcRowIdent     as  character no-undo.
        define input  parameter plNext         as  logical   no-undo.
        define input  parameter piRowsToReturn as  integer   no-undo.
        define output parameter piRowsReturned as  integer   no-undo.
        define output parameter table          for RowObject.
    
        define variable hQuery        as handle    no-undo.
        define variable hBuffer       as handle    no-undo.
        define variable hRowObject    as handle    no-undo.
        define variable hDataQuery    as handle    no-undo.
        define variable cRowIdent     as character no-undo.
        define variable rRowIDs       as rowid     extent 10 no-undo.
        define variable lOK           as logical   no-undo.
        define variable iRow          as integer   no-undo.
    
        if  l-modulo-re = yes
        or  l-modulo-cc = yes
        or  l-modulo-cn = yes then do:

            for each rowObject:
                delete rowObject.
            end.
            
            if true then do:
                if pcRowIdent ne ? and pcRowIdent ne "":U then do:
                    rRowIDs = ?.
                    reposition {&query-name} to rowid to-rowid(pcRowIdent) no-error.
                    get next {&query-name}.
                end.
                else if piStartRow ne ? and piStartRow ne 0 then do:
                    reposition  {&query-name} to row piStartRow no-error.
                    get next {&query-name}.
                end.
                if plNext then
                    get next {&query-name}.
                do while available({&first-table-in-query}) :
                    if piRowsToReturn <> 0 and piRowsReturned >= piRowsToReturn then do:
                       leave.
                    end.
                    
                    for first dist-emitente fields (cod-emitente       idi-sit-fornec
                                                    dat-vigenc-inicial dat-vigenc-final)
                         where dist-emitente.cod-emitente = emitente.cod-emitente no-lock: end.
    
                    /* Se n∆o existir a tabela dist-emitente relacionada ao emitente, 
                       o registro dever† ser criado normalmente */
                    if  not avail dist-emitente then do:
    
                        /* Grava a situacao do Emitente */
                        create rowObject.
                        buffer-copy {&table-name} to rowObject.
                        assign rowObject.r-rowid = rowid({&table-name})
                               rowObject.char-1  = "Desconhecido".
                        get next {&query-name}.
                        piRowsReturned = piRowsReturned + 1.
                        next.
    
                    end.
    
                    /* Se o emitente estiver ativo,  */
                    if  dist-emitente.idi-sit-fornec = 1 
                    and l-mostra-ativos then do:
    
                        /* Grava a situacao do Emitente */
                        create rowObject.
                        buffer-copy {&table-name} to rowObject.
                        assign rowObject.r-rowid = rowid({&table-name})
                               rowObject.char-1  = "Ativo".
                        get next {&query-name}.
                        piRowsReturned = piRowsReturned + 1.
                        next.
    
                    end.
    
                    /* Verifica se existe alguma restricao em vigor para a data em questao*/
                    if  dist-emitente.dat-vigenc-inicial <= da-data-restricao and
                        dist-emitente.dat-vigenc-final   >= da-data-restricao then do:  
    
                        if  dist-emitente.idi-sit-fornec = 2 /* Restricao em Compras */
                        and l-mostra-restr-compras then do:
    
                            /* Grava a situacao do Emitente */
                            create rowObject.
                            buffer-copy {&table-name} to rowObject.
                            assign rowObject.r-rowid = rowid({&table-name})
                                   rowObject.char-1  = "Restriá∆o para Compras".
                            get next {&query-name}.
                            piRowsReturned = piRowsReturned + 1.
                            next.
    
                        end.
    
                        if  dist-emitente.idi-sit-fornec = 3 /* Restricao em compras e recebimento */
                        and l-mostra-restr-compras-recebim then do:
    
                            /*Grava a situacao do Emitente */
                            create rowObject.
                            buffer-copy {&table-name} to rowObject.
                            assign rowObject.r-rowid = rowid({&table-name})
                                   rowObject.char-1  = "Restriá∆o para Compras e Recebimento".
                            get next {&query-name}.
                            piRowsReturned = piRowsReturned + 1.
                            next.
    
                        end.
    
                        if  dist-emitente.idi-sit-fornec = 4 /* Inativos */
                        and l-mostra-inativos then do:
    
                            /* Grava a situacao do Emitente */
                            create rowObject.
                            buffer-copy {&table-name} to rowObject.
                            assign rowObject.r-rowid = rowid({&table-name})
                                   rowObject.char-1  = "Inativo".
                            get next {&query-name}.
                            piRowsReturned = piRowsReturned + 1.
                            next.
    
                        end.
    
                    end.
                    else if l-mostra-ativos then do:
    
                        /* Grava a situacao do Emitente */
                        create rowObject.
                        buffer-copy {&table-name} to rowObject.
                        assign rowObject.r-rowid = rowid({&table-name})
                               rowObject.char-1  = "Ativo".
                        get next {&query-name}.
                        piRowsReturned = piRowsReturned + 1.
                        next.
    
                    end.
    
                    get next {&query-name}.
    
                END.
                IF piRowsReturned > 0 THEN DO:
                    RUN openQuery(i-bo-query).
                    IF piStartRow = ? OR piStartRow = 0 THEN DO:
                        get first {&query-name}.
                        get prev {&query-name}.
                    END.
                    ELSE
                        REPOSITION  {&query-name} TO ROW (piStartRow) no-error.
                END.
            END.
            RETURN.                                                
        end.
        else 
            run NewServerSendRows (input piStartRow,      
                                   input pcRowIdent,      
                                   input plNext,          
                                   input piRowsToReturn,  
                                   output piRowsReturned,
                                   output table RowObject).
    end.

    if valid-handle (h-boin682) then do:
        delete procedure h-boin682.
                         h-boin682 = ?.
    end.

&else

    procedure serverSendRows :                                                     
    /*                                                                             
    **  Disponivel no smart data object da V9, e foi reimplementado dentro         
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,       
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query        
    **  e facilitara a migracao destes programas para os Smart Data Objects.       
    */                                                                             
        define input  parameter piStartRow     as  integer   no-undo.
        define input  parameter pcRowIdent     as  character no-undo.
        define input  parameter plNext         as  logical   no-undo.
        define input  parameter piRowsToReturn as  integer   no-undo.
        define output parameter piRowsReturned as  integer   no-undo.
        define output parameter table          for RowObject.
                                                                                   
        run NewServerSendRows (input piStartRow,      
                               input pcRowIdent,      
                               input plNext,          
                               input piRowsToReturn,  
                               output piRowsReturned,
                               output table RowObject).

    end procedure.                                                                 

&endif

{include/boprebro.i}
{include/boexecre.i}
{include/boexeupt.i}
{include/boexedel.i}
{include/bovalupt.i}
/*{include/bovaldel.i}*/
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade":U).
 
    run endMethod   ("initializeValidade":U).
end procedure.
 
{adbo/boad098.i1} /* procedure findCodigo e findNome - utilizada pelo Magnus e pelo EMS */

&if defined(bf-mat-comex) &then            
&else

    
    procedure findEmitente:
        /*
        **  Procura pelo indice, caso nao ache,
        **  retorna mensagem de erro padrao do EMS.
        */
        run startMethod ("find":U).
        def input parameter i-cod-emitente as inte no-undo.
        def output parameter c-return as char no-undo.
    
        find emitente where
            emitente.cod-emitente = i-cod-emitente
            and emitente.identific <> 2
            no-lock no-error.
        if not avail {&TABLE-NAME} then do:
            {utp/ut-table.i mgadm {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign c-return = return-value.
        end.
        else do:
           run setCurrent.
        end.
        run endMethod ("find":U).
    end procedure.

    /*Procura por emitentes com identificaá∆o diferente de 1*/
    procedure findEmitente2:
        /*
        **  Procura pelo indice, caso nao ache,
        **  retorna mensagem de erro padrao do EMS.
        */
        run startMethod ("find":U).
        def input parameter i-cod-emitente as inte no-undo.
        def output parameter c-return as char no-undo.
    
        find emitente where
            emitente.cod-emitente = i-cod-emitente
            and emitente.identific <> 1
            no-lock no-error.
        if not avail {&TABLE-NAME} then do:
            {utp/ut-table.i mgadm {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            assign c-return = return-value.
        end.
        else do:
           run setCurrent.
        end.
        run endMethod ("find":U).
    end procedure.

    procedure validateFields:
        {adbo/boad098.i4}
    end procedure.

    /**********************************************************************
     * MÇtodo para validaá∆o dos campos de seleá∆o/parÉmetros do programa *
     * wap0804as.w. Este mÇtodo valida se os valores iniciais s∆o maiores *
     * que os valores finais e se s∆o campos requeridos.                  *
     **********************************************************************/
    procedure validaCampos:
    
    def input parameter table for tt-param.
    def output parameter table for tt-bo-erro.
    
        find first tt-param no-lock no-error.
        if avail tt-param then do:
            if tt-param.cod-estab-ini > tt-param.cod-estab-fim then do:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 285,
                                   input "").
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 285
                       tt-bo-erro.mensagem     = return-value.
            end. 
            if tt-param.cod-esp-ini > tt-param.cod-esp-fim then do:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 338,
                                   input "").
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 338
                       tt-bo-erro.mensagem     = return-value.
            end. 
            if tt-param.cod-port-ini > tt-param.cod-port-fim then do:   
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 342,
                                   input "").
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 342
                       tt-bo-erro.mensagem     = return-value.
            end. 
            if tt-param.dt-emissao-ini > tt-param.dt-emissao-fim then do:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 1168,
                                   input "").
    
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 1168
                       tt-bo-erro.mensagem     = return-value.
            end.
        end.
    end.    

 
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
     
        find first rowObject
            no-lock no-error.
        if rowObject.agencia = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} agencia 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.atividade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} atividade 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.bairro = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} bairro 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.bairro-cob = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} bairro-cob 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.bonificacao = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} bonificacao 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.bx-acatada = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} bx-acatada 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.caixa-postal = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} caixa-postal 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.calcula-multa = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} calcula-multa 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.categoria = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} categoria 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        /* valida somente se nao for estrageiro */
        IF rowObject.natureza NE 3 THEN DO:
            if rowObject.cep = ? then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgadm {&TABLE-NAME} cep 1}
                run utp/ut-msgs.p (input "msg",
                                   input 265,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 265
                       tt-bo-erro.mensagem     = return-value.
            end.
        END.
     
        if rowObject.cgc-cob = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cgc-cob 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cidade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cidade 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cidade-cob = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cidade-cob 1}
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
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-banco 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.cod-cacex = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-cacex 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.cod-emitente = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-emitente 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cod-gr-cli = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-gr-cli 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.cod-mensagem = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-mensagem 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cod-rep = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-rep 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.cod-suframa = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-suframa 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cod-transp = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-transp 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.conta-corren = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} conta-corren 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.contato[01] = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} contato 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.contato[02] = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} contato 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.cx-post-cob = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cx-post-cob 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.data-implant = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} data-implant 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.emite-etiq = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} emite-etiq 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.end-cobranca = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} end-cobranca 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.endereco = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} endereco 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.endereco-cob = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} endereco-cob 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.esp-pd-venda = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} esp-pd-venda 1}
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
            {utp/ut-field.i mgadm {&TABLE-NAME} estado 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.estado-cob = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} estado-cob 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.forn-exp = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} forn-exp 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.gera-ad = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} gera-ad 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.gera-difer = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} gera-difer 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.identific = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} identific 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.ind-apr-cred = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ind-apr-cred 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ind-atraso = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ind-atraso 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.ind-aval = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ind-aval 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ind-cre-cli = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ind-cre-cli 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.ind-dif-atrs-1 = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ind-dif-atrs-1 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ind-dif-atrs-2 = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ind-dif-atrs-2 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.ind-div-atraso = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ind-div-atraso 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ind-fat-par = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ind-fat-par 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.ins-est-cob = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ins-est-cob 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ins-estadual = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ins-estadual 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.ins-municipal = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ins-municipal 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.istr = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} istr 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.lim-credito = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} lim-credito 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.linha-produt = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} linha-produt 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.mod-prefer = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} mod-prefer 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.modalidade = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} modalidade 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.nat-operacao = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nat-operacao 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.natureza = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} natureza 1}
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
            {utp/ut-field.i mgadm {&TABLE-NAME} nome-abrev 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.nome-emit = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nome-emit 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.nome-matriz = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nome-matriz 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.nr-copias-ped = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nr-copias-ped 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.nr-mesina = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nr-mesina 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.nr-peratr = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nr-peratr 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.nr-tabpre = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nr-tabpre 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.observacoes = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} observacoes 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.pais = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} pais 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.per-max-canc = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} per-max-canc 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.perc-fat-ped = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} perc-fat-ped 1}
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
            {utp/ut-field.i mgadm {&TABLE-NAME} portador 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.prox-ad = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} prox-ad 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.ramal[01] = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ramal 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ramal[02] = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ramal 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.resumo-mp = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} resumo-mp 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.taxa-financ = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} taxa-financ 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.telefax = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} telefax 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telefone[01] = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} telefone 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.telefone[02] = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} telefone 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.telex = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} telex 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.tp-qt-prg = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} tp-qt-prg 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.tr-ar-valor = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} tr-ar-valor 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.user-libcre = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} user-libcre 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ven-domingo = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ven-domingo 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
 
        if rowObject.ven-sabado = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ven-sabado 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:

            find emitente where
                emitente.cod-emitente = rowObject.cod-emitente no-lock no-error.
            if avail emitente then do:

                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-table.i mgadm {&TABLE-NAME} 1}
                run utp/ut-msgs.p (input "msg",
                                   input 8,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 8
                       tt-bo-erro.mensagem     = return-value.

            end.

        end.
 
        
        IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:

            run validateFields.

            IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
               run executeCreate.
               assign r-chave = to-rowid(return-value).
            END.

        END.
     
        FINALLY:
            run endMethod ("validateCreate":U).
        END.
    end procedure.

    procedure validateDelete:
        /*
        **  Valida Delete
        */
        def input-output parameter r-chave as rowid.
        def output parameter table for tt-bo-erro.
     
        run InitializeValidate.
         
        find first rowObject no-lock no-error.   
        
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave
            exclusive-lock no-error.
        if avail {&TABLE-NAME} then do:
    
    
    
           /***** ATENCAO - Uso de Pre-processador *******/
           &if defined (bf_dis_desc_bonif) &then  /* pre-processador */   
               run verificarRelacoesEliminarEmitente.
           &endif /* preprocessador */
           /***** fim - Uso de Pre-processador *******/
    
           find first tt-bo-erro no-lock no-error.
           if not avail tt-bo-erro then
    
              /*================ ATENÄ«O : Uso de PRE-PROCESSADOR ==========================*/    
              /* Esse pre-processador Ç em virtude da existància de uma release nova de dicio-
                n†rio, a 2.02, que contÇm a tabela dist-emitente, enquanto a release anterior
                n∆o tem. A l¢gica abaixo ser† inclu°da no .r dependendo  das  informaá‰es que 
                est∆o na include {cdp/cdcfgdis.i}.d£vidas, verifique Manual TÇcnica do UIB.
                 
                Ser† excluido o registro correspondente da tabela de extens∆o do emitente,  a
                dist-emitente. 
              *******************************************************************************/
              &if defined (bf_dis_desc_bonif) &then  /* pre-processador */   
              find first dist-emitente exclusive-lock where
                         dist-emitente.cod-emitente = emitente.cod-emitente no-error.
              if avail dist-emitente then 
                 delete dist-emitente.
              &endif /* preprocessador */
              /*====================== FIM USO PRE-PROCESSADOR ==============================*/    
    
    
              run executeDelete.
    
        end.
     
        if l-query then
            get next {&QUERY-NAME}
                no-lock no-wait.
        else
            find next {&TABLE-NAME}
                no-lock no-error.
    
        if not avail {&TABLE-NAME} then do:
           if l-query then
               get prev {&QUERY-NAME}
                   no-lock no-wait.
           else
               find prev {&TABLE-NAME}
                   no-lock no-error.
        end.
        assign r-chave = rowid({&TABLE-NAME}).
        return "".
    end procedure.  
    Procedure getRowidEmitente :
    
        /*
         Acha o rowid do emitente de acordo com  o relacionamento
         item x fornecedor.
         Parametros:
         ipar1 : r-item-fornec : rowid do do relacionamento item x fornecedor
         opar2 : r-emitente    : rowid do emitente (fornecedor)
        */
        
        def input  param r-item-fornec as rowid no-undo.
        def output param r-emitente    as rowid no-undo.
        
        find item-fornec where
             rowid(item-fornec) = r-item-fornec 
             no-lock no-error.
    
        find first emitente where 
                   emitente.cod-emitente = item-fornec.cod-emitente
                   no-lock no-error.
                   
        if avail emitente then
           assign r-emitente = rowid(emitente).           
    
    end.    
&endif    
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "agencia":U then c-value = RowObject.agencia.
        when "atividade":U then c-value = RowObject.atividade.
        when "bairro":U then c-value = RowObject.bairro.
        when "bairro-cob":U then c-value = RowObject.bairro-cob.
        when "caixa-postal":U then c-value = RowObject.caixa-postal.
        when "categoria":U then c-value = RowObject.categoria.
        when "cgc":U then c-value = RowObject.cgc.
        when "cgc-cob":U then c-value = RowObject.cgc-cob.
        when "char-1":U then c-value = RowObject.char-1.
        when "char-2":U then c-value = RowObject.char-2.
        when "cidade":U then c-value = RowObject.cidade.
        when "cidade-cob":U then c-value = RowObject.cidade-cob.
        when "cod-cacex":U then c-value = RowObject.cod-cacex.
        when "cod-suframa":U then c-value = RowObject.cod-suframa.
        
        when "conta-corren":U then c-value = RowObject.conta-corren.
        when "contato[1]":U then c-value = RowObject.contato[1].
        when "contato[2]":U then c-value = RowObject.contato[2].
        when "cx-post-cob":U then c-value = RowObject.cx-post-cob.
        when "endereco":U then c-value = RowObject.endereco.
        when "endereco-cob":U then c-value = RowObject.endereco-cob.
        when "estado":U then c-value = RowObject.estado.
        when "estado-cob":U then c-value = RowObject.estado-cob.
        when "inf-complementar":U then c-value = RowObject.inf-complementar.
        when "ins-est-cob":U then c-value = RowObject.ins-est-cob.
        when "ins-estadual":U then c-value = RowObject.ins-estadual.
        when "ins-municipal":U then c-value = RowObject.ins-municipal.
        when "insc-subs-trib":U then c-value = RowObject.insc-subs-trib.
        when "linha-produt":U then c-value = RowObject.linha-produt.
        when "nat-ope-ext":U then c-value = RowObject.nat-ope-ext.
        when "nat-operacao":U then c-value = RowObject.nat-operacao.
        when "nome-abrev":U then c-value = RowObject.nome-abrev.
        when "nome-emit":U then c-value = RowObject.nome-emit.
        when "nome-matriz":U then c-value = RowObject.nome-matriz.
        when "nome-mic-reg":U then c-value = RowObject.nome-mic-reg.
        when "nome-tr-red":U then c-value = RowObject.nome-tr-red.
        when "nr-tabpre":U then c-value = RowObject.nr-tabpre.
        when "pais":U then c-value = RowObject.pais.
        when "pais-cob":U then c-value = RowObject.pais-cob.
        when "ramal[1]":U then c-value = RowObject.ramal[1].
        when "ramal[2]":U then c-value = RowObject.ramal[2].
        when "ramal-fac":U then c-value = RowObject.ramal-fac.
        when "ramal-fax":U then c-value = RowObject.ramal-fax.
        when "ramal-modem":U then c-value = RowObject.ramal-modem.
        when "telef-fac":U then c-value = RowObject.telef-fac.
        when "telef-modem":U then c-value = RowObject.telef-modem.
        when "telefax":U then c-value = RowObject.telefax.
        when "telefone[1]":U then c-value = RowObject.telefone[1].
        when "telefone[2]":U then c-value = RowObject.telefone[2].
        when "telex":U then c-value = RowObject.telex.
        when "user-libcre":U then c-value = RowObject.user-libcre.
        when "zip-cob-code":U then c-value = RowObject.zip-cob-code.
        when "zip-code":U then c-value = RowObject.zip-code.        
        &if defined(bf-mat-comex) &then            
            when "obs-entrega[1]":U then c-value = RowObject.obs-entrega[1].
            when "obs-entrega[2]":U then c-value = RowObject.obs-entrega[2].        
            when "observacoes[1]":U then c-value = RowObject.observacoes[1].
            when "observacoes[2]":U then c-value = RowObject.observacoes[2].  
            when "emissao-ped":U then c-value = RowObject.emissao-ped.        
            when "identific":U then c-value = RowObject.identific.        
            when "natureza":U then c-value = RowObject.natureza.        
            when "tp-pagto":U then c-value = RowObject.tp-pagto.                
            when "u-char-1":U then c-value = RowObject.u-char-1.        
            when "u-char-2":U then c-value = RowObject.u-char-2.                    
        &else        
            when "cep":U then c-value = RowObject.cep.        
            when "cep-cob":U then c-value = RowObject.cep-cob.            
            when "check-sum":U then c-value = RowObject.check-sum.            
            when "cn-codigo":U then c-value = RowObject.cn-codigo.            
            when "cod-entrega":U then c-value = RowObject.cod-entrega.            
            when "e-mail":U then c-value = RowObject.e-mail.            
            when "endereco2":U then c-value = RowObject.endereco2.            
            when "home-page":U then c-value = RowObject.home-page.            
            when "obs-entrega":U then c-value = RowObject.obs-entrega.            
            when "observacoes":U then c-value = RowObject.observacoes.            
        &endif
        
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "bonificacao":U then c-value = RowObject.bonificacao.
        when "compr-period":U then c-value = RowObject.compr-period.
        when "dec-1":U then c-value = RowObject.dec-1.
        when "dec-2":U then c-value = RowObject.dec-2.
        when "lim-adicional":U then c-value = RowObject.lim-adicional.
        when "lim-credito":U then c-value = RowObject.lim-credito.
        when "per-max-canc":U then c-value = RowObject.per-max-canc.
        when "per-minfat":U then c-value = RowObject.per-minfat.
        when "taxa-financ":U then c-value = RowObject.taxa-financ.
        when "vl-min-ad":U then c-value = RowObject.vl-min-ad.
        &if defined(bf-mat-comex) &then            
            when "u-dec-1":U then c-value = RowObject.u-dec-1.
            when "u-dec-2":U then c-value = RowObject.u-dec-2.        
        &else        
            when "val-quota-media":U then c-value = RowObject.val-quota-media.        
            when "valor-minimo":U then c-value = RowObject.valor-minimo.            
            when "vl-max-devol":U then c-value = RowObject.vl-max-devol.            
        &endif
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "bx-acatada":U then c-value = RowObject.bx-acatada.
        when "cod-banco":U then c-value = RowObject.cod-banco.
        when "cod-cond-pag":U then c-value = RowObject.cod-cond-pag.
        when "cod-emitente":U then c-value = RowObject.cod-emitente.
        when "cod-gr-cli":U then c-value = RowObject.cod-gr-cli.
        when "cod-gr-forn":U then c-value = RowObject.cod-gr-forn.
        when "cod-mensagem":U then c-value = RowObject.cod-mensagem.
        when "cod-rep":U then c-value = RowObject.cod-rep.
        when "cod-tip-ent":U then c-value = RowObject.cod-tip-ent.
        when "cod-transp":U then c-value = RowObject.cod-transp.
        when "end-cobranca":U then c-value = RowObject.end-cobranca.
        when "esp-pd-venda":U then c-value = RowObject.esp-pd-venda.
        when "gera-difer":U then c-value = RowObject.gera-difer.
        when "hora-fim":U then c-value = RowObject.hora-fim.
        when "hora-ini":U then c-value = RowObject.hora-ini.
        when "ind-atraso":U then c-value = RowObject.ind-atraso.
        when "ind-cre-cli":U then c-value = RowObject.ind-cre-cli.
        when "ind-dif-atrs-1":U then c-value = RowObject.ind-dif-atrs-1.
        when "ind-dif-atrs-2":U then c-value = RowObject.ind-dif-atrs-2.
        when "ind-div-atraso":U then c-value = RowObject.ind-div-atraso.
        when "ind-moeda-tit":U then c-value = RowObject.ind-moeda-tit.
        when "ins-banc[1]":U then c-value = RowObject.ins-banc[1].
        when "ins-banc[2]":U then c-value = RowObject.ins-banc[2].
        when "int-1":U then c-value = RowObject.int-1.
        when "int-2":U then c-value = RowObject.int-2.
        when "istr":U then c-value = RowObject.istr.
        when "mod-prefer":U then c-value = RowObject.mod-prefer.
        when "modalidade":U then c-value = RowObject.modalidade.
        &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
            when "modalidade-ap":U then c-value = RowObject.modalidade-ap.
        &ENDIF
        when "nr-copias-ped":U then c-value = RowObject.nr-copias-ped.
        when "nr-dias":U then c-value = RowObject.nr-dias.
        when "nr-dias-taxa":U then c-value = RowObject.nr-dias-taxa.
        when "nr-mesina":U then c-value = RowObject.nr-mesina.
        when "nr-peratr":U then c-value = RowObject.nr-peratr.
        when "nr-titulo":U then c-value = RowObject.nr-titulo.
        when "perc-fat-ped":U then c-value = RowObject.perc-fat-ped.
        when "port-prefer":U then c-value = RowObject.port-prefer.
        when "portador":U then c-value = RowObject.portador.
        &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
            when "portador-ap":U then c-value = RowObject.portador-ap.
        &ENDIF
        when "prox-ad":U then c-value = RowObject.prox-ad.
        when "tip-cob-desp":U then c-value = RowObject.tip-cob-desp.
        when "tp-desp-padrao":U then c-value = RowObject.tp-desp-padrao.
        when "tp-inspecao":U then c-value = RowObject.tp-inspecao.
        when "tp-qt-prg":U then c-value = RowObject.tp-qt-prg.
        when "tp-rec-padrao":U then c-value = RowObject.tp-rec-padrao.
        when "ven-domingo":U then c-value = RowObject.ven-domingo.
        when "ven-feriado":U then c-value = RowObject.ven-feriado.
        when "ven-sabado":U then c-value = RowObject.ven-sabado.
        &if defined(bf-mat-comex) &then        
            when "ind-aval[1]":U then c-value = RowObject.ind-aval[1].
            when "ind-aval[2]":U then c-value = RowObject.ind-aval[2].       
            when "cep":U then c-value = RowObject.cep.        
            when "cep-cob":U then c-value = RowObject.cep-cob.
            when "u-int-1":U then c-value = RowObject.u-int-1.        
            when "u-int-2":U then c-value = RowObject.u-int-2.            
        &else        
            when "cod-canal-venda":U then c-value = RowObject.cod-canal-venda.        
            when "cod-classif-cliente":U then c-value = RowObject.cod-classif-cliente.            
            when "cod-classif-fornec":U then c-value = RowObject.cod-classif-fornec.            
            when "cod-isencao":U then c-value = RowObject.cod-isencao.                
            when "cod-parceiro-edi":U then c-value = RowObject.cod-parceiro-edi.            
            when "cod-tax":U then c-value = RowObject.cod-tax.            
            when "dias-comp":U then c-value = RowObject.dias-comp.            
            when "emissao-ped":U then c-value = RowObject.emissao-ped.            
            when "estoque":U then c-value = RowObject.estoque.            
            when "flag-pag":U then c-value = RowObject.flag-pag.            
            when "identific":U then c-value = RowObject.identific.            
            when "ind-abrange-aval":U then c-value = RowObject.ind-abrange-aval.            
            when "ind-aval":U then c-value = RowObject.ind-aval.            
            when "ind-aval-embarque":U then c-value = RowObject.ind-aval-embarque.            
            when "ind-emit-retencao":U then c-value = RowObject.ind-emit-retencao.            
            when "ind-sit-emitente":U then c-value = RowObject.ind-sit-emitente.            
            when "moeda-libcre":U then c-value = RowObject.moeda-libcre.                        
            when "natureza":U then c-value = RowObject.natureza.            
            when "nr-cheque-devol":U then c-value = RowObject.nr-cheque-devol.            
            when "nr-dias-atraso":U then c-value = RowObject.nr-dias-atraso.            
            when "nr-tab-progr":U then c-value = RowObject.nr-tab-progr.            
            when "periodo-devol":U then c-value = RowObject.periodo-devol.            
            when "resumo-mp":U then c-value = RowObject.resumo-mp.            
            when "tp-pagto":U then c-value = RowObject.tp-pagto.            
            when "tr-ar-valor":U then c-value = RowObject.tr-ar-valor.            
        &endif
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-implant":U then c-value = RowObject.data-implant.
        when "data-taxa":U then c-value = RowObject.data-taxa.
        when "dt-fim-cred":U then c-value = RowObject.dt-fim-cred.
        when "dt-lim-cred":U then c-value = RowObject.dt-lim-cred.
        when "dt-ult-venda":U then c-value = RowObject.dt-ult-venda.
        &if defined(bf-mat-comex) &then            
        &else        
            when "data-1":U then c-value = RowObject.data-1.        
            when "data-2":U then c-value = RowObject.data-2.            
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "contrib-icms":U then c-value = RowObject.contrib-icms.
        when "emite-bloq":U then c-value = RowObject.emite-bloq.
        when "emite-etiq":U then c-value = RowObject.emite-etiq.
        when "forn-exp":U then c-value = RowObject.forn-exp.
        when "gera-ad":U then c-value = RowObject.gera-ad.
        when "ind-apr-cred":U then c-value = RowObject.ind-apr-cred.
        when "ind-cred-abat":U then c-value = RowObject.ind-cred-abat.
        when "ind-fat-par":U then c-value = RowObject.ind-fat-par.
        when "ind-lib-estoque":U then c-value = RowObject.ind-lib-estoque.
        when "ind-rendiment":U then c-value = RowObject.ind-rendiment.
        when "log-1":U then c-value = RowObject.log-1.
        when "log-2":U then c-value = RowObject.log-2.
        &if defined(bf-mat-comex) &then            
            when "resumo-mp":U then c-value = RowObject.resumo-mp.        
            when "tr-ar-valor":U then c-value = RowObject.tr-ar-valor.       
            when "u-log-1":U then c-value = RowObject.u-log-1.       
            when "u-log-2":U then c-value = RowObject.u-log-2.               
        &else        
            when "agente-retencao":U then c-value = RowObject.agente-retencao.        
            when "calcula-multa":U then c-value = RowObject.calcula-multa.            
            when "ind-licenciador":U then c-value = RowObject.ind-licenciador.                    
            when "item-cli":U then c-value = RowObject.item-cli.            
            when "percepcao":U then c-value = RowObject.percepcao.            
            when "prog-emit":U then c-value = RowObject.prog-emit.            
            when "recebe-inf-sci":U then c-value = RowObject.recebe-inf-sci.            
        &endif        
        otherwise return error.
    end case.
end procedure.

/***** ATENCAO - Uso de Pre-processador *******/
&if defined (bf_dis_desc_bonif) &then  /* pre-processador */   

    procedure verificarRelacoesEliminarEmitente:
    /*
    MÇtodo implementado para realizar a validaá∆o na  eliminaá∆o da tabela emitente e verificar se 
    o emitente est† sendo usado nas tabelas desconto, canal-cliente, desconto-valor,
    tem-bonif-cliente .
    */
    
        def var c-texto       as char extent 2 no-undo.


        find first param-global
            no-lock no-error.
    
        if param-global.modulo-09 then do: /* modulo BN */ 
            if can-find (first desconto where 
                               desconto.cod-emitente = emitente.cod-emitente) then do:         
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm {&TABLE-NAME} 1}
               assign c-texto[1] = return-value.
               {utp/ut-table.i mgdis desconto 1}
               assign c-texto[2] = return-value.     
               run utp/ut-msgs.p (input "msg",
                                  input 5,          /* Emitente possui relacionamentos ativos com desconto.*/
                                  input c-texto[1] + "~~" + c-texto[2]).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 5
                      tt-bo-erro.mensagem     = return-value.  
               assign tt-bo-erro.parametros   = c-texto[1] + "~~" + c-texto[2].
            end.    
    
            if can-find (first desconto where 
                               desconto.cdn-cliente-matriz = emitente.cod-emitente) then do:         
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm {&TABLE-NAME} 1}
               assign c-texto[1] = return-value.
               {utp/ut-table.i mgdis desconto 1}
               assign c-texto[2] = return-value.     
               run utp/ut-msgs.p (input "msg",
                                  input 5,          /* Emitente possui relacionamentos ativos com desconto.*/
                                  input c-texto[1] + "~~" + c-texto[2]).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 5
                      tt-bo-erro.mensagem     = return-value.  
               assign tt-bo-erro.parametros   = c-texto[1] + "~~" + c-texto[2].
            end.    
    
            if can-find (first canal-cliente where 
                               canal-cliente.cod-emitente = emitente.cod-emitente) then do:         
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm {&TABLE-NAME} 1}
               assign c-texto[1] = return-value.
               {utp/ut-table.i mgdis canal-cliente 1}
               assign c-texto[2] = return-value.     
               run utp/ut-msgs.p (input "msg",
                                  input 5,        /* Emitente possui relacionamentos ativos com Canal Cli. */
                                  input c-texto[1] + "~~" + c-texto[2]).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 5
                      tt-bo-erro.mensagem     = return-value.          
               assign tt-bo-erro.parametros   = c-texto[1] + "~~" + c-texto[2].
                      
            end.

            if can-find (first desconto-valor where 
                               desconto-valor.cdn-cliente = emitente.cod-emitente) then do:         
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm {&TABLE-NAME} 1}
               assign c-texto[1] = return-value.
               {utp/ut-table.i mgdis desconto-valor 1}
               assign c-texto[2] = return-value.     
               run utp/ut-msgs.p (input "msg",
                                  input 5,        /* Emitente valor possui relacionamentos ativos com Desconto Valor. */
                                  input c-texto[1] + "~~" + c-texto[2]).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 5
                      tt-bo-erro.mensagem     = return-value.          
               assign tt-bo-erro.parametros   = c-texto[1] + "~~" + c-texto[2].
                      
            end.

            if can-find (first item-bonif-cliente where 
                               item-bonif-cliente.cdn-cliente = emitente.cod-emitente) then do:         
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm {&TABLE-NAME} 1}
               assign c-texto[1] = return-value.
               {utp/ut-table.i mgdis item-bonif-cliente 1}
               assign c-texto[2] = return-value.     
               run utp/ut-msgs.p (input "msg",
                                  input 5,        /* Item Bonif Cliente possui relacionamentos ativos com Desconto Valor. */
                                  input c-texto[1] + "~~" + c-texto[2]).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 5
                      tt-bo-erro.mensagem     = return-value.          
               assign tt-bo-erro.parametros   = c-texto[1] + "~~" + c-texto[2].
                      
            end.

        end. /* param-global */    
    end procedure.
    
&endif /* preprocessador */
/***** fim - Uso de Pre-processador *******/ 

procedure findCodigoEmitente:
    def input  param p-cod-emitente as int   no-undo.
    def output param c-rowid        as char no-undo.
    find first emitente 
         where emitente.cod-emitente = p-cod-emitente no-lock no-error.
    if  avail emitente then do:
        assign c-rowid = string(rowid(emitente)).
    end.     

end procedure.

procedure pi-abertura-37:
    if i-ordena = 1 then do:
       {adbo/boad098.i3 "cod-emitente"}
    end.
    if i-ordena = 2 then do:
       {adbo/boad098.i3 "nome-abrev"}    	     
    end.
    if i-ordena = 3 then do:
       {adbo/boad098.i3 "cgc"}            
    end.
    if i-ordena = 4 then do:
       {adbo/boad098.i3 "cod-gr-forn"}
    end.               
    if i-ordena = 5 then do:
       {adbo/boad098.i3 "nome-matriz"}            
    end. 
    if i-ordena = 6 then do:
       {adbo/boad098.i3 "nome-emit"}            
    end.
end.

procedure pi-abertura-36:
    if i-ordena = 1 then do:
        {adbo/boad098.i2 "cod-emitente"}
    end.    
    if i-ordena = 2 then do:
        {adbo/boad098.i2 "nome-abrev"}
    end.  
    if i-ordena = 3 then do:
        {adbo/boad098.i2 "cgc"}            
    end.
    if i-ordena = 4 then do:
        {adbo/boad098.i2 "cod-gr-forn"}            
    end.
    if i-ordena = 5 then do:
        {adbo/boad098.i2 "nome-matriz"}                        
    end.
    if i-ordena = 6 then do:
        {adbo/boad098.i2 "nome-emit"}            
    end.
end.

procedure pi-abertura-43:
    if i-ordena = 1 then do:
       {adbo/boad098.i5 "cod-emitente"}
    end.
    if i-ordena = 2 then do:
       {adbo/boad098.i5 "nome-abrev"}    	     
    end.
    if i-ordena = 3 then do:
       {adbo/boad098.i5 "cgc"}            
    end.
    if i-ordena = 4 then do:
       {adbo/boad098.i5 "cod-gr-forn"}
    end.               
    if i-ordena = 5 then do:
       {adbo/boad098.i5 "nome-matriz"}            
    end.
    if i-ordena = 6 then do:
       {adbo/boad098.i5 "nome-emit"}            
    end.
end.

PROCEDURE verifyOpenQuery:

    DEFINE INPUT PARAMETER pEmitenteIni AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pEmitenteFim AS INTEGER NO-UNDO.

    FIND FIRST emitente
         WHERE emitente.cod-emitente >= pEmitenteIni AND
               emitente.cod-emitente <= pEmitenteFim NO-LOCK NO-ERROR.
                
    IF AVAIL emitente THEN
        RETURN "OK":U.
    ELSE
        RETURN "NOK":U.

END PROCEDURE.

procedure NewServerSendRows :
/** Qndo o produto for menor que 205 ou nao estiverem implantados os 
    modulos de compras, contratos e recebimentos nao devera mostrar
    a situacao do fornecedor, gravada no campo char-1. Este recebera
    valor "" (branco).
**/

    define input  parameter piStartRow     as  integer   no-undo.
    define input  parameter pcRowIdent     as  character no-undo.
    define input  parameter plNext         as  logical   no-undo.
    define input  parameter piRowsToReturn as  integer   no-undo.
    define output parameter piRowsReturned as  integer   no-undo.
    define output parameter table          for RowObject.

    define variable hQuery        as handle    no-undo.
    define variable hBuffer       as handle    no-undo.
    define variable hRowObject    as handle    no-undo.
    define variable hDataQuery    as handle    no-undo.
    define variable cRowIdent     as character no-undo.
    define variable rRowIDs       as rowid     extent 10 no-undo.
    define variable lOK           as logical   no-undo.
    define variable iRow          as integer   no-undo.

    for each rowObject:
        delete rowObject.
    end.
    IF true THEN DO:
        IF pcRowIdent NE ? AND pcRowIdent NE "":U THEN DO:
            rRowIDs = ?.
            reposition {&query-name} to rowid to-rowid(pcRowIdent) no-error.
            get next {&query-name}.
        END.
        ELSE IF piStartRow NE ? AND piStartRow NE 0 THEN DO:
            REPOSITION  {&query-name} TO ROW piStartRow no-error.
            GET next {&query-name}.
        END.
        IF plNext THEN
            GET next {&query-name}.
        DO WHILE available({&first-table-in-query}) :
            if piRowsToReturn <> 0 and piRowsReturned >= piRowsToReturn then do:
               leave.
            end.

            create rowObject.
            buffer-copy {&table-name} to rowObject.
            assign rowObject.r-rowid = rowid({&table-name})
                   rowObject.char-1  = "":U.
            get next {&query-name}.
            piRowsReturned = piRowsReturned + 1.

        END.
        IF piRowsReturned > 0 THEN DO:
            RUN openQuery(i-bo-query).
            IF piStartRow = ? OR piStartRow = 0 THEN DO:
                get first {&query-name}.
                get prev {&query-name}.
            END.
            ELSE
                REPOSITION  {&query-name} TO ROW (piStartRow) no-error.
        END.
    END.
    RETURN.
end procedure.

procedure findNomeAbrev: /*Procura pelo nome abreviado com cod-emitente ou cgc*/
            //andy
    def input  param c-emitente   as char format 'x(19)' no-undo.
    def output param c-nome-abrev as char format 'x(19)' no-undo.

    for first emitente fields(nome-abrev)
        where emitente.nome-abrev = c-emitente no-lock:
        assign c-nome-abrev = emitente.nome-abrev.
        RETURN "OK":U.
    end.

    for first emitente fields(nome-abrev cod-emitente)
        where emitente.cod-emitente = parseStringToInteger(c-emitente) no-lock:
        assign c-nome-abrev = emitente.nome-abrev.
        return "OK":U.
    end.

    for first emitente fields(nome-abrev cgc)
        where emitente.cgc = c-emitente no-lock:
        assign c-nome-abrev = emitente.nome-abrev.
        return "OK":U.
    end.

    RETURN "NOK":U.

end procedure.

procedure findCodEmitente: /*Procura pelo nome abreviado com cod-emitente ou cgc*/

    def input  param c-emitente   as char format 'x(19)' no-undo.
    def output param i-cod-emitente as INT no-undo.

    for first emitente 
        where emitente.cod-emitente = parseStringToInteger(c-emitente) no-lock:
        assign i-cod-emitente = emitente.cod-emitente.
        return "OK":U.
    end.
                      
    for first emitente 
        where emitente.nome-abrev = c-emitente no-lock:
        assign i-cod-emitente = emitente.cod-emitente.
        RETURN "OK":U.
    end.              

    for first emitente 
        where emitente.cgc = c-emitente no-lock:
        assign i-cod-emitente = emitente.cod-emitente.
        return "OK":U.
    end.

    RETURN "NOK":U.
end procedure.

PROCEDURE ValidateCrmToEms:
    DEFINE INPUT PARAM piCodEmitente  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM pcCodUsuarResp AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pIdiNivAcess   AS INTEGER   NO-UNDO.

   FIND FIRST dist-emitente EXCLUSIVE-LOCK WHERE
        dist-emitente.cod-emitente = piCodEmitente NO-ERROR.
   IF NOT AVAIL dist-emitente THEN DO:
       CREATE dist-emitente.
       ASSIGN dist-emitente.cod-emitente      = piCodEmitente
              dist-emitente.cod-usuar-respons = pcCodUsuarResp
              dist-emitente.idi-niv-aces      = pIdiNivAcess.
   END.
   ELSE DO:
       ASSIGN dist-emitente.cod-usuar-respons = pcCodUsuarResp
              dist-emitente.idi-niv-aces      = pIdiNivAcess.
   END.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord Method-Library 
PROCEDURE beforeCreateRecord PRIVATE:

    DEFINE VARIABLE ie AS CHARACTER INITIAL ?   NO-UNDO.

    //busca e atualiza IE se necessario
    IF (RowObject.natureza EQ 2) AND //se for PJ
       (RowObject.ins-estadual EQ ? OR trim(RowObject.ins-estadual) EQ '') THEN DO:

        RUN getInscEstad IN THIS-PROCEDURE(INPUT RowObject.estado , INPUT RowObject.cgc , OUTPUT ie).
        
        IF ie NE ? THEN
            ASSIGN RowObject.ins-estadual = ie.

        IF (RowObject.cgc EQ RowObject.cgc-cob) AND 
           (RowObject.ins-est-cob EQ ? OR TRIM(RowObject.ins-est-cob) EQ '') THEN
            ASSIGN RowObject.ins-est-cob = RowObject.ins-estadual.        

    END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord Method-Library
PROCEDURE beforeUpdateRecord PRIVATE:

    DEFINE VARIABLE ie AS CHARACTER INITIAL ?   NO-UNDO.

    //busca e atualiza IE se necessario
    IF (RowObject.natureza EQ 2) AND //se for PJ
       (RowObject.ins-estadual EQ ? OR trim(RowObject.ins-estadual) EQ '') THEN DO:

        RUN getInscEstad IN THIS-PROCEDURE(INPUT RowObject.estado , INPUT RowObject.cgc , OUTPUT ie).
        
        IF ie NE ? THEN
            ASSIGN RowObject.ins-estadual = ie.

        IF (RowObject.cgc EQ RowObject.cgc-cob) AND 
           (RowObject.ins-est-cob EQ ? OR TRIM(RowObject.ins-est-cob) EQ '') THEN
            ASSIGN RowObject.ins-est-cob = RowObject.ins-estadual.        

    END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE getInscEstad:
    DEFINE INPUT  PARAMETER uf   AS CHARACTER FORMAT 'X(2)'   NO-UNDO.
    DEFINE INPUT  PARAMETER cnpj AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER ie   AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE h-api-sintegra AS HANDLE      NO-UNDO.

    RUN utils/api-tas.p PERSISTENT SET h-api-sintegra.
    RUN consutaNrInscrEstadual IN h-api-sintegra (INPUT uf, INPUT cnpj, OUTPUT ie).

    FINALLY:

        IF VALID-HANDLE(h-api-sintegra) THEN
            DELETE PROCEDURE h-api-sintegra NO-ERROR.

    END.
END PROCEDURE.

procedure atualizaParamCd9999:
/** Bloqueio de fornecedores - 205 **/
&if defined (bf_mat_bloqueio_fornec) &then

    define input parameter p-l-mostra-ativos                as log  no-undo.
    define input parameter p-l-mostra-restr-compras         as log  no-undo.
    define input parameter p-l-mostra-restr-compras-recebim as log  no-undo.
    define input parameter p-l-mostra-inativos              as log  no-undo.
    define input parameter p-da-data-restricao              as date no-undo.

    assign l-mostra-ativos                 = p-l-mostra-ativos               
           l-mostra-restr-compras          = p-l-mostra-restr-compras        
           l-mostra-restr-compras-recebim  = p-l-mostra-restr-compras-recebim 
           l-mostra-inativos               = p-l-mostra-inativos             
           da-data-restricao               = p-da-data-restricao.             

&endif
end.

PROCEDURE validateCnpjAlfanum:
    DEFINE INPUT  PARAMETER p-cnpj-validar             AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cnpj-valido              AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-result-validacao        AS CHARACTER   NO-UNDO  INITIAL 'OK'.
        
    DEFINE VARIABLE i-cont                            AS INTEGER     NO-UNDO.
        
    IF p-cnpj-validar = "" OR p-cnpj-validar = ? THEN
        ASSIGN p-result-validacao = "Vazio".
    ELSE DO:
        ASSIGN p-cnpj-validar = UPPER(REPLACE(REPLACE(REPLACE(p-cnpj-validar,'.',''),'-',''),'/','')).        
        DO i-cont = 1 to 14:            
            IF i-cont >= 13 THEN DO:     /* D°gito verificador n∆o aceita letras */                
                IF CAN-DO("0,1,2,3,4,5,6,7,8,9", substr(p-cnpj-validar,i-cont,1)) THEN
                    ASSIGN p-cnpj-valido = p-cnpj-valido + substr(p-cnpj-validar,i-cont,1).
                ELSE                    
                    ASSIGN p-result-validacao = "Invalido".
            END.
            ELSE DO:
                IF i-cont < 13                                  AND 
                   (ASC(SUBSTR(p-cnpj-validar,i-cont,1)) >= 48  AND       /*  48  = 0  */
                    ASC(SUBSTR(p-cnpj-validar,i-cont,1)) <= 57) OR        /*  57  = 9  */
                   (ASC(SUBSTR(p-cnpj-validar,i-cont,1)) >= 65  AND       /*  65  = A  */
                    ASC(SUBSTR(p-cnpj-validar,i-cont,1)) <= 90) THEN      /*  90  = Z  */ 
                    ASSIGN p-cnpj-valido = p-cnpj-valido + substr(p-cnpj-validar,i-cont,1).
                ELSE
                    ASSIGN p-result-validacao = "Invalido".
            END.
        END.
    END.
    
END PROCEDURE.
