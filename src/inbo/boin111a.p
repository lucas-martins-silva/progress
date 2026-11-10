/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN111A 2.00.01.007 } /*** "010107" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN111A MUT}
&ENDIF

/*
**  BOIN111a.P
**
**  Bo espec¡fica p/ a tabela de Estrutura - Arquivo de Estrutura
**
**  Ultima altera‡Æo : 07/01/2000 - GeraBO
***********************************************************************************************/
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY tt-estrutura
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-estrutura
 
{include/boini.i} 
 
{inbo/boin111a.i RowObject}

{inbo/boin111a.i tt-estrutura}

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

/****************** Vari veis utilizadas na open-query (locais) *************************/
define var de-quant-usada       like estrutura.quant-usada   no-undo.
define var de-quant-liq         as decimal                   no-undo.
define var c-refer-es           like ref-item.cod-refer      no-undo.
define var l-refer-incluida     as logical                   no-undo.
define var c-comp               as char format "x(1)"        no-undo.
define var c-fabr               as char format "x(1)"        no-undo.    
define var c-alt                as char format "x(1)"        no-undo.
define var c-refer              like ref-item.cod-refer      no-undo.
define var c-rowid              as char                      no-undo.
define var i-seq                as integer                   no-undo.
define var i-nivel              as integer                   no-undo.
define var c-it-codigo          like item.it-codigo          no-undo.

/********* defini‡äes de vari veis que vem tela de parƒmetro - wen0805a  - ************/
define var de-quantidade     as decimal                      no-undo.
define var i-niveis          as integer                      no-undo.
define var da-data-corte     as date                         no-undo. 
define var c-format          as char                         no-undo.


/********* defini‡äes de vari veis que vem tela de parƒmetro - wen0808  - ************/
define var c-refer-it        like referencia.cod-refer            no-undo.
define var de-quant-gerada     as decimal                         no-undo.
define var c-aux               as char                            no-undo.
define var c-nivel             as char                            no-undo.

DEFINE VARIABLE l-baixa-drb-internac AS LOGICAL INITIAL NO NO-UNDO.
define var      d-perc-item          as decimal            no-undo.
define var      d-perc-drb           as decimal            no-undo.
define var      d-qtd-baixa-drb     as decimal            no-undo.

DEFINE BUFFER  b-item  FOR   item.
                                                           
DEFINE TEMP-TABLE tt-item-aux
    field it-codigo    like item.it-codigo
    field niv-mais-bai like item.niv-mais-bai
    index codigo is primary unique
          it-codigo.


/*********************   Fim defini‡Æo wen0805  *********************/

procedure setConstraint1:
 
end procedure.
 
{inbo/boin111a.i1} /* procedure setConstraint2 */
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
    end case.    
    
    assign l-query = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
/* {include/bonav.i}
   {include/bofind.i}  
   {include/bosetcur.i} */
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
{include/boexeupt.i}
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}
 

/* M‚todos customizados */

procedure findRowid:
    /*
    **  Localiza registro pelo rowid e nao retorna o registro.
    */
    def input parameter r-chave as rowid no-undo.

    define buffer b-localiza for {&TABLE-NAME}.

    find b-localiza
	where b-localiza.r-rowid = r-chave
        no-lock no-error.
    if l-query then do:
        reposition {&QUERY-NAME}
            to rowid rowid(b-localiza) no-error.
            get next {&QUERY-NAME}
                no-lock no-wait.
    end.
    else
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = rowid(b-localiza)
            no-lock no-error.
    if avail {&TABLE-NAME} then RUN setCurrent.
end procedure.

procedure getRowid:
    def output parameter r-chave as rowid no-undo.
    if avail {&TABLE-NAME} then do:
        assign r-chave = {&TABLE-NAME}.r-rowid.
    end.
    else do:
       assign r-chave = ?.
    end.
end procedure.

procedure setCurrent:
    /*
    **  Seta registro corrente para a temp-table que sera devolvida.
    */
    for each RowObject:
        delete RowObject.
    end.
    if avail {&TABLE-NAME} then do:
        create RowObject.
        buffer-copy {&TABLE-NAME} to RowObject.
/*        assign rowObject.r-rowid = rowid({&TABLE-NAME}).*/
    end.
end procedure.

/* =============== */

/* ======== Customizado mas nÆo alterado ======== */

procedure findFirst:
    if l-query then
        get first {&QUERY-NAME}
            no-lock no-wait.
    else
        find first {&TABLE-NAME}
            no-lock no-error.
    run setCurrent.
end procedure.
procedure findPrev:
    def output parameter c-return as char.
    if l-query then
        get prev {&QUERY-NAME}
            no-lock no-wait.
    else
        find prev {&TABLE-NAME}
            no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7998,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.
end procedure.
procedure findNext:
    def output parameter c-return as char.
    if l-query then
        get next {&QUERY-NAME}
            no-lock no-wait.
    else
        find next {&TABLE-NAME}
            no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7999,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.  

end procedure.
procedure findLast:
    if l-query then
        get last {&QUERY-NAME}
            no-lock no-wait.
    else
        find last {&TABLE-NAME}
            no-lock no-error.
    run setCurrent.
end procedure.

/* =============== */

{inbo/boin111a.i2} /* procedure getTTestrutura / montaEstrutura */

/*--------------------------------------------------------------------------------------------------*/

{inbo/boin111a.i3} /* procedure getEstruturaFilho */

/*----------------------------------------------------------------------------------------------------------*/

PROCEDURE montaEstruturaTodeschini:

/*Procedimento específico para Todeschini.
 * Tem o mesmo funcionamento do procedimento montaEstrutura, mas só desce um nível.
 * */
 
  for each tt-estrutura:
      delete tt-estrutura.
  end.
     
  assign i-seq   = 1
         i-nivel = 1.
         
  find item where item.it-codigo = c-it-codigo no-lock.       
         
  for each estrutura fields (data-inicio data-termino es-codigo quant-usada
                             proporcao   fator-perda  it-codigo sequencia
                             fantasma log-quant-fix) of item no-lock:
                             
      if (estrutura.data-inicio  <= da-data-corte and
          estrutura.data-termino > da-data-corte) or da-data-corte = ? then do:
          for first b-item fields (it-codigo tipo-con-est compr-fabric) where 
                    b-item.it-codigo = estrutura.es-codigo no-lock: end.
          if not avail b-item then next.
          assign de-quant-usada = if estrutura.log-quant-fix then estrutura.quant-usada
                                  else estrutura.quant-usada * de-quantidade * 
                                      (estrutura.proporcao / 100)
                 de-quant-liq   = if estrutura.log-quant-fix then estrutura.quant-usada
                                  else (estrutura.quant-usada * de-quantidade 
                                      * estrutura.proporcao / 100) * (1 - (estrutura.fator-perda / 100)).             
          if estrutura.fantasma = yes then do:
             run geraEstruturaFilhoTodeschini(rowid(b-item), c-refer-es, de-quant-usada, de-quant-liq, i-nivel).
             next.
          end.
                             
          if b-item.tipo-con-est = 4 or 
              item.tipo-con-est = 4 then do:
                find first ref-estrut where 
                           ref-estrut.it-codigo  = estrutura.it-codigo and  
                           ref-estrut.es-codigo  = estrutura.es-codigo and
                           ref-estrut.sequencia  = estrutura.sequencia no-lock no-error.
                if not available ref-estrut then
                     assign c-refer-es       = ""
                            l-refer-incluida = yes.
                else do:
                     find first ref-estrut where 
                           ref-estrut.it-codigo  = estrutura.it-codigo and  
                           ref-estrut.cod-ref-it = c-refer and  
                           ref-estrut.es-codigo  = estrutura.es-codigo and
                           ref-estrut.sequencia  = estrutura.sequencia no-lock no-error.
                      if available ref-estrut then          
                         assign c-refer-es = ref-estrut.cod-ref-es
                                l-refer-incluida = yes.
                      else          
                         assign l-refer-incluida = no.
                end.         
         end.
         else
             assign l-refer-incluida = yes
                    c-refer-es       = ''.

         if l-refer-incluida then do:  
            create tt-estrutura.
            assign c-rowid                    = "0x0" + string(i-seq,"9999999")
                   tt-estrutura.seq           = i-seq
                   tt-estrutura.r-rowid       = to-rowid(c-rowid)
                   tt-estrutura.refer         = c-refer-es
                   tt-estrutura.it-codigo     = estrutura.es-codigo
                   tt-estrutura.proporcao     = estrutura.proporcao
                   tt-estrutura.fator-perda   = estrutura.fator-perda
                   tt-estrutura.quant-usada   = de-quant-usada
                   tt-estrutura.quant-liquid  = de-quant-liq
                   tt-estrutura.quantidade    = estrutura.quant-usada
                   tt-estrutura.data-inicio   = estrutura.data-inicio
                   tt-estrutura.data-termino  = estrutura.data-termino
                   i-seq                          = i-seq + 1.
        
            assign tt-estrutura.nivel = string('1','x(12)').

         end.
      end.  
  end.

END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------------------*/

PROCEDURE geraEstruturaFilhoTodeschini:

/*Procedimento auxiliar, específico para Todeschini.
 *  Auxilia o procedimento montaEstruturaTodeschini*/

define input parameter v-row-item as rowid no-undo.
define input parameter p-refer as char no-undo.
define input parameter p-quantidade as decimal no-undo.
define input parameter p-quant-liq  as decimal no-undo.
define input parameter p-nivel as integer no-undo.

define buffer b1-item for item.
define buffer b2-item for item.
define buffer b-estrutura for estrutura.
define var de-quant-usada as decimal.
define var i as integer.


for first b1-item fields ( it-codigo tipo-con-est) where 
     rowid(b1-item) = v-row-item no-lock: end.

assign p-nivel = p-nivel + 1.

for each  b-estrutura fields (data-inicio data-termino es-codigo quant-usada
                             proporcao   fator-perda  it-codigo sequencia
                             fantasma log-quant-fix ) of b1-item no-lock:
   if (b-estrutura.data-inicio  <= da-data-corte and
       b-estrutura.data-termino >  da-data-corte) or da-data-corte = ? then do:
       for first b2-item fields (it-codigo tipo-con-est compr-fabric) where 
            b2-item.it-codigo = b-estrutura.es-codigo no-lock: end.
       if not avail b2-item then next.
       assign de-quant-usada =  if b-estrutura.log-quant-fix then b-estrutura.quant-usada
                                else b-estrutura.quant-usada * p-quantidade * 
                                    (b-estrutura.proporcao / 100)
              de-quant-liq   =  if b-estrutura.log-quant-fix then b-estrutura.quant-usada
                                else (b-estrutura.quant-usada * p-quantidade
                                    * b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).            
       if b-estrutura.fantasma = yes then do:
          run geraEstruturaFilhoTodeschini(rowid(b2-item), c-refer-es, de-quant-usada, de-quant-liq, p-nivel).
          next.
       end.

      if  b2-item.tipo-con-est = 4 or 
          b1-item.tipo-con-est = 4 then do:
            find first ref-estrut where 
                        ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                        ref-estrut.es-codigo  = b-estrutura.es-codigo and
                        ref-estrut.sequencia  = b-estrutura.sequencia no-lock no-error.
            
            if  not available ref-estrut then
                assign c-refer-es       = ""
                       l-refer-incluida = yes.
            else do:
                  find first ref-estrut where 
                       ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                       ref-estrut.cod-ref-it = p-refer and  
                       ref-estrut.es-codigo  = b-estrutura.es-codigo and
                       ref-estrut.sequencia  = b-estrutura.sequencia no-lock no-error.
                  
                  if available ref-estrut then
                     assign c-refer-es = ref-estrut.cod-ref-es
                            l-refer-incluida = yes.
                  else   
                      assign l-refer-incluida = no.
            end.          
      end.
      else
          assign l-refer-incluida = yes
                 c-refer-es       = ''.
      
      if  l-refer-incluida then do:
          create tt-estrutura.
          assign c-rowid                    = "0x0" + string(i-seq,"9999999")
                 tt-estrutura.seq           = i-seq
                 tt-estrutura.refer         = c-refer-es
                 tt-estrutura.r-rowid       = to-rowid(c-rowid)
                 tt-estrutura.proporcao     = b-estrutura.proporcao
                 tt-estrutura.it-codigo     = b-estrutura.es-codigo
                 tt-estrutura.fator-perda   = b-estrutura.fator-perda
                 tt-estrutura.quant-usada   = de-quant-usada
                 tt-estrutura.quant-liquid  = de-quant-liq
                 tt-estrutura.quantidade    = b-estrutura.quant-usada
                 tt-estrutura.data-inicio   = b-estrutura.data-inicio
                 tt-estrutura.data-termino  = b-estrutura.data-termino
                 i-seq                      = i-seq + 1.
      end.
   end.
end.

END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------------------*/

PROCEDURE geraOndeSeUsaPai:

/*Procedimento utilizado para montar estrutura a partir
 * de um item comprado ou semi acabado. Sobe a estrutrura nivel-a-nivel,
 * mostrando os itens pai do item passado como parâmetro.*/

   define input param p-item  as rowid.
   define input param p-nivel           as integer.
   define input param p-refer         like ref-item.cod-refer.
   define input param p-quantidade      as decimal.

   define buffer b1-item      for item.
   define buffer b2-item      for item.
   define buffer b-estrutura  for estrutura.
   define buffer b-ref-estrut for ref-estrut.

   find b1-item where rowid(b1-item) = p-item no-lock.

   for each  b-estrutura use-index onde-se-usa
       where b-estrutura.es-codigo = b1-item.it-codigo no-lock,
       first b2-item fields (it-codigo tipo-con-est niv-mais-bai)
             use-index codigo
       where b2-item.it-codigo = b-estrutura.it-codigo no-lock:   
    
      if (b-estrutura.data-inicio  <= da-data-corte and
          b-estrutura.data-termino >  da-data-corte) or da-data-corte = ? then do:   
       
          &IF DEFINED (bf_man_sfc_lc) &THEN
          /* D_MAN002 - Quantidade fixa para componentes de engenharia */
          assign de-quant-gerada = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                   else p-quantidade * b-estrutura.qtd-compon / b-estrutura.qtd-item * 
                                        (b-estrutura.proporcao / 100)
                 de-quant-liq    = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                   else p-quantidade * b-estrutura.qtd-compon / b-estrutura.qtd-item *
                                        ( 1 - (b-estrutura.fator-perda / 100)).
          &ELSE
          assign de-quant-gerada = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                   else p-quantidade * b-estrutura.quant-usada * 
                                        (b-estrutura.proporcao / 100)
                 de-quant-liq    = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                   else p-quantidade * b-estrutura.quant-usada *
                                        ( 1 - (b-estrutura.fator-perda / 100)).       
          &ENDIF
       
          if b2-item.tipo-con-est  = 4 or 
             b1-item.tipo-con-est = 4 then do:
             for each  b-ref-estrut fields (it-codigo   es-codigo   cod-ref-es
                                            sequencia   cod-ref-it)
                 where b-ref-estrut.it-codigo  = b-estrutura.it-codigo
                   and b-ref-estrut.es-codigo  = b-estrutura.es-codigo
                   and b-ref-estrut.cod-ref-es = p-refer
                   and b-ref-estrut.sequencia  = b-estrutura.sequencia no-lock:                
                  assign c-refer-it = b-ref-estrut.cod-ref-it.
                  run geraOndeSeUsa (buffer b2-item,
                                     buffer b-estrutura,
                                     p-nivel,
                                     b1-item.it-codigo).
             end.
          end.       
          else do:
               assign c-refer-it = "".
               run geraOndeSeUsa (buffer b2-item,
                                  buffer b-estrutura,
                                  p-nivel,
                                  b1-item.it-codigo).
          end.
      end.
   end.   

END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------------------*/

PROCEDURE geraOndeSeUsa:

/*Procedimento auxiliar do procedimento geraOndeSeUsaPai.
 * Ajuda na parte de recursividade da estrutura.*/

   define parameter buffer b-item          for item.
   define parameter buffer b-estrutura     for estrutura.
   define input parameter  p-nivel          as integer.
   define input parameter  p-item-inicio  like item.it-codigo.

   def var i     as integer.
   def var i-seq as integer initial 0.

   find tt-item-aux where 
        tt-item-aux.it-codigo = p-item-inicio no-error.
   if not avail tt-item-aux then do:
       for first item fields (it-codigo niv-mais-bai)
           use-index codigo
       where item.it-codigo = p-item-inicio no-lock. end.
       create tt-item-aux.
       assign tt-item-aux.it-codigo    = item.it-codigo
              tt-item-aux.niv-mais-bai = item.niv-mais-bai.
   end.
   
   if b-estrutura.fantasma then 
      assign c-aux = '#'.
   else
      assign c-aux = ' '. 
           
   if b-item.niv-mais-bai = 0 then           
      assign c-aux = c-aux +  '0'.
   else     
      assign c-aux = c-aux +  ' '. 
                  
   if can-find (first alternativo
                where alternativo.es-codigo = b-estrutura.es-codigo
                  and alternativo.it-codigo = b-estrutura.it-codigo
                  and alternativo.sequencia = b-estrutura.sequencia no-lock) then
      assign c-aux = c-aux +  c-alt.
   else   
      assign c-aux = c-aux +  ' '.
         
   if today >= b-estrutura.data-termino or today < b-estrutura.data-inicio then
      assign c-aux = c-aux +  '?'.
         
   assign c-nivel = string(tt-item-aux.niv-mais-bai - p-nivel)
          p-nivel = p-nivel - 1
          c-nivel = string(p-nivel).
   
   do i = 1 to p-nivel:
      assign c-nivel = ' ' + c-nivel.
      if i = 10 then leave.  
   end.     

   find last tt-estrutura no-error. 
   if available tt-estrutura then 
      assign i-seq = tt-estrutura.seq + 1.

   create tt-estrutura.
   assign c-rowid                    = "0x0" + string(i-seq,"9999999")
          tt-estrutura.seq           = i-seq
          tt-estrutura.it-codigo     = b-estrutura.it-codigo
          tt-estrutura.refer         = c-refer-it
          tt-estrutura.r-rowid       = to-rowid(c-rowid)
          tt-estrutura.quant-usada   = de-quant-gerada
          tt-estrutura.quant-liquid  = de-quant-liq
          tt-estrutura.nivel         = string(c-nivel, 'x(12)') + c-aux
          tt-estrutura.fator-perda   = b-estrutura.fator-perda
          tt-estrutura.data-inicio   = b-estrutura.data-inicio
          tt-estrutura.data-termino  = b-estrutura.data-termino.

   if i-niveis > p-nivel and
      p-nivel  < tt-item-aux.niv-mais-bai then do:
      run geraOndeSeUsaPai(rowid(b-item),
                           p-nivel,
                           c-refer-it,
                           de-quant-gerada).
   end.

END PROCEDURE.

/*--------------------------------------------------------------------------------------------------*/

procedure neutra:
   for each tt-estrutura:
       message "tt-estrutura.aux " tt-estrutura.seq tt-estrutura.it-codigo tt-estrutura.nivel.
   end.
end.

/*--------------------------------------------------------------------------------------------------*/

procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input  parameter i-sequencia as inte no-undo.
    def output parameter c-return    as char no-undo.
    
    find {&TABLE-NAME} where
         {&TABLE-NAME}.seq = i-sequencia
         no-lock no-error.

    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgind {&TABLE-NAME} 1}
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
  
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "it-codigo" then c-value = RowObject.it-codigo.
        when "refer"     then c-value = RowObject.refer.
        when "aux"       then c-value = RowObject.aux.
        when "nivel" then c-value = RowObject.nivel.        
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "fator-perda" then c-value = RowObject.fator-perda.
        when "proporcao" then c-value = RowObject.proporcao.
        when "quant-liquid" then c-value = RowObject.quant-liquid.
        when "quant-usada" then c-value = RowObject.quant-usada.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "seq" then c-value = RowObject.seq.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-inicio" then c-value = RowObject.data-inicio.
        when "data-termino" then c-value = RowObject.data-termino.
        otherwise return error.
    end case.
end procedure.

procedure isDrbInternacional:
    ASSIGN l-baixa-drb-internac = YES.
end procedure.

procedure limpaTtEstrutura:
    empty temp-table tt-estrutura.
end procedure.
