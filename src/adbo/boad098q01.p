/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD098Q01 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD098Q01 MUT}
&ENDIF



/*liana
**  BOAD098Q01.P
**
**  emitente - Emitentes
**
**  Ultima alteraá∆o : 08/11/02 - GeraBO
*/

{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
{cdp/cdcfgdis.i} /* Include uso de pre-processadores para modulo BN*/

&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY emitente
&scoped-define QUERY-NAME qTable
/*&scoped-define TABLE-NAME emitente*/                           

&IF DEFINED(bf-mat-comex) &THEN
   /*&scoped-define TABLE-NAME tt-emitente*/
   &scoped-define TABLE-NAME emitente
&else   
   &scoped-define TABLE-NAME emitente
&ENDIF

{include/boini.i}

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se n∆o, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 

/*====================== FIM USO PRE-PROCESSADOR ==============================*/
/*
&IF DEFINED(bf-mat-comex) &THEN
    {adbo/boad098.i RowObject}
&else
    {adbo/boad098q01.i RowObject}
&ENDIF
*/

{adbo/boad098q01.i RowObject}

&IF DEFINED(bf-mat-comex) &THEN
   {adbo/boad098q01.i tt-emitente}
&ENDIF

&IF INTEGER(ENTRY(1,PROVERSION,".":U)) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

/* Definicao das variaveis para setContraint 17 e 18 */
def var i-cod-emit-ini   as int  format "999999999":U no-undo.
def var i-cod-emit-fim   as int  format "999999999":U no-undo.
def var c-nome-abrev-ini as char format "x(12)":U     no-undo.
def var c-nome-abrev-fim as char format "x(12)":U     no-undo.

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

procedure setConstraint18:
def input param p-cod-emit-ini   as int  format "999999999":U no-undo.
def input param p-cod-emit-fim   as int  format "999999999":U no-undo.
def input param p-nome-abrev-ini as char format "x(12)":U     no-undo.
def input param p-nome-abrev-fim as char format "x(12)":U     no-undo.

   assign i-cod-emit-ini   = p-cod-emit-ini  
          i-cod-emit-fim   = p-cod-emit-fim  
          c-nome-abrev-ini = p-nome-abrev-ini
          c-nome-abrev-fim = p-nome-abrev-fim.

end procedure.

procedure setConstraint19:
def input param p-cod-emit-ini   as int format "999999999":U no-undo.
def input param p-cod-emit-fim   as int format "999999999":U no-undo.

   assign i-cod-emit-ini   = p-cod-emit-ini  
          i-cod-emit-fim   = p-cod-emit-fim.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        /******************************ATENCAO*******************************************
         aqui dever∆o ser cadastradas openqueries utilizadas pelo EMS e pelo Magnus
        ********************************************************************************/                
        &IF DEFINED(bf-mat-comex) &THEN
          when 18 then 
            if i-cod-emit-ini = i-cod-emit-fim then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                  {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                  {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                  {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim NO-LOCK
                                                  BY nome-abrev INDEXED-REPOSITION.	
            else do:
                
                if c-nome-abrev-ini = c-nome-abrev-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini and
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim NO-LOCK
                                                      BY nome-abrev INDEXED-REPOSITION.	
                else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                      {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim NO-LOCK
                                                      BY nome-abrev INDEXED-REPOSITION.	
            end.                                      
        &else
            when 18 then 
                if i-cod-emit-ini = i-cod-emit-fim then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                      {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini   and
                                                      {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                      {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim 
                                                      no-lock BY {&TABLE-NAME}.nome-abrev {&v9indrep} .
                else do:
                    if c-nome-abrev-ini = c-nome-abrev-fim THEN 
                        open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                          {&TABLE-NAME}.nome-abrev    = c-nome-abrev-ini and
                                                          {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                          {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim 
                                                          NO-LOCK BY {&TABLE-NAME}.nome-abrev {&v9indrep}.	
                    else 
                        open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                                          {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                          {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim   and
                                                          {&TABLE-NAME}.nome-abrev   >= c-nome-abrev-ini and
                                                          {&TABLE-NAME}.nome-abrev   <= c-nome-abrev-fim 
                                                          NO-LOCK BY {&TABLE-NAME}.nome-abrev {&v9indrep}.	
                end.                                      
        &ENDIF
        when 19 then do:
            if i-cod-emit-ini = i-cod-emit-fim then
                open query {&QUERY-NAME} for each {&TABLE-NAME} USE-INDEX codigo where 
                                                  {&TABLE-NAME}.cod-emitente  = i-cod-emit-ini NO-LOCK  {&v9indrep}.
            else
                open query {&QUERY-NAME} for each {&TABLE-NAME} USE-INDEX codigo where 
                                                  {&TABLE-NAME}.cod-emitente >= i-cod-emit-ini   and
                                                  {&TABLE-NAME}.cod-emitente <= i-cod-emit-fim NO-LOCK  {&v9indrep}.						     
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

procedure NewServerSendRows :
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

    &IF DEFINED(bf-mat-comex) &THEN
        FOR EACH rowObject EXCLUSIVE-LOCK:
           DELETE rowObject.    
        END.
    &ELSE
        EMPTY TEMP-TABLE rowObject.    
    &ENDIF
    

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
        when "nr-copias-ped":U then c-value = RowObject.nr-copias-ped.
        when "nr-dias":U then c-value = RowObject.nr-dias.
        when "nr-dias-taxa":U then c-value = RowObject.nr-dias-taxa.
        when "nr-mesina":U then c-value = RowObject.nr-mesina.
        when "nr-peratr":U then c-value = RowObject.nr-peratr.
        when "nr-titulo":U then c-value = RowObject.nr-titulo.
        when "perc-fat-ped":U then c-value = RowObject.perc-fat-ped.
        when "port-prefer":U then c-value = RowObject.port-prefer.
        when "portador":U then c-value = RowObject.portador.
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
