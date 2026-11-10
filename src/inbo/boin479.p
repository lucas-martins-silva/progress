/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN479 2.00.00.024 } /*** "010024" 15/09/2026 09:10:13 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin479 MUT}
&ENDIF


/*
**  BOIN479.P
**
**  item-lista-compon - 
**
**  Ultima altera‡Æo : 24/06/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY item-lista-compon
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME item-lista-compon
 
{include/boini.i}
 
{cdp/cdcfgman.i} 

{inbo/boin479.i RowObject}

&IF DEFINED(bf_man_per_ppm) &THEN
    {cdp/cd0666.i}
&ENDIF

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:
 
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
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
/*{include/boexedel.i}*/
{include/bovalupt.i}
{include/bovaldel.i}
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure findOnde_se_usa:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-es-codigo as char no-undo.
    def input parameter c-cod-lista-compon as char no-undo.
    def output parameter c-return as char no-undo.
 
    find item-lista-compon where
        item-lista-compon.es-codigo = c-es-codigo
        and item-lista-compon.cod-lista-compon = c-cod-lista-compon
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
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-lista-compon = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-lista-compon 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.data-inicio = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} data-inicio 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.data-termino = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} data-termino 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.es-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} es-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.fantasma = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} fantasma 1}
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
    **  Valida cria‡Æo da tabela/duplicidade de registro.
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
        find item-lista-compon where
            item-lista-compon.es-codigo        = rowObject.es-codigo
        and item-lista-compon.cod-lista-compon = rowObject.cod-lista-compon
        and item-lista-compon.sequencia        = rowObject.sequencia
            no-lock no-error.
        if avail item-lista-compon then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgind {&TABLE-NAME} 1}
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
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-lista-compon" then c-value = RowObject.cod-lista-compon.
        when "es-codigo" then c-value = RowObject.es-codigo.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "fator-perda" then c-value = RowObject.fator-perda.
        when "proporcao" then c-value = RowObject.proporcao.
        when "qtd-compon" then c-value = RowObject.qtd-compon.
        when "qtd-lista" then c-value = RowObject.qtd-lista.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "sequencia" then c-value = RowObject.sequencia.
        when "tempo-reserv" then c-value = RowObject.tempo-reserv.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "data-inicio" then c-value = RowObject.data-inicio.
        when "data-termino" then c-value = RowObject.data-termino.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "fantasma" then c-value = RowObject.fantasma.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.

procedure executeDelete:

    find current item-lista-compon exclusive-lock no-error.
    
    for each estrutura use-index lista-compon exclusive-lock
       where estrutura.cod-lista-compon      = item-lista-compon.cod-lista-compon
         and estrutura.es-codigo             = item-lista-compon.es-codigo
         and substring(estrutura.char-1,1,5) = string(item-lista-compon.sequencia,">>>>9"):
        delete estrutura.
    end.

    for each  altern-lista-compon exclusive-lock
        where altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
          and altern-lista-compon.al-codigo        = item-lista-compon.es-codigo
          and altern-lista-compon.cod-ref-al       = item-lista-compon.cod-ref-es:
        delete altern-lista-compon.
    end.

    for each  altern-lista-compon exclusive-lock
        where altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
          and altern-lista-compon.es-codigo        = item-lista-compon.es-codigo
          and altern-lista-compon.cod-ref-es       = item-lista-compon.cod-ref-es:
        delete altern-lista-compon.
    end.
    
    delete {&TABLE-NAME}.
    validate {&TABLE-NAME}.
    
end procedure.

/********************************************************************************
Procedure AtualizarItemListaCompon  (ex trigger write)
********************************************************************************/
procedure AtualizarItemListaCompon:

    def input parameter rw-item-lista-compon as rowid.
    
    DEFINE BUFFER b-estrutura   FOR estrutura.
    DEFINE BUFFER b-ref-estrut  FOR ref-estrut.
    DEFINE BUFFER bf-item       FOR ITEM.
   
    find first item-lista-compon
         where rowid(item-lista-compon) = rw-item-lista-compon no-lock no-error.
         
    find last param-en no-lock.

    DEF VAR ref-it-aux LIKE ref-item.cod-refer NO-UNDO.
    DEF VAR ref-es-aux LIKE ref-item.cod-refer NO-UNDO.

    for each  lista-compon-item
        where lista-compon-item.cod-lista-compon = item-lista-compon.cod-lista-compon NO-LOCK: 

        do transaction on error undo, next:
           
            FOR FIRST ITEM FIELDS(it-codigo ressup-fabri tipo-con-est cod-refer) NO-LOCK
                WHERE ITEM.it-codigo = lista-compon-item.it-codigo:
            END.
            find first estrutura use-index codigo exclusive-lock where
                       estrutura.it-codigo             = lista-compon-item.it-codigo        and 
                       estrutura.es-codigo             = item-lista-compon.es-codigo        and 
                       estrutura.cod-lista-compon      = item-lista-compon.cod-lista-compon and
                       substring(estrutura.char-1,1,5) = string(item-lista-compon.sequencia,">>>>9") no-error.
           
            if not avail estrutura then do:       
                find last  b-estrutura 
                     where b-estrutura.it-codigo = lista-compon-item.it-codigo no-lock no-error.
                create estrutura.
                assign estrutura.it-codigo             = lista-compon-item.it-codigo
                       estrutura.es-codigo             = item-lista-compon.es-codigo
                       estrutura.sequencia             = if avail b-estrutura then
                                                             b-estrutura.sequencia + param-en.num-var-estrutura
                                                         else param-en.num-var-estrutura
                       estrutura.cod-lista-compon      = item-lista-compon.cod-lista-compon
                       substring(estrutura.char-1,1,5) = string(item-lista-compon.sequencia,">>>>9").
            end.           
            assign estrutura.data-inicio      = max(item-lista-compon.data-inicio, lista-compon-item.data-inicio)
                   estrutura.data-termino     = min(item-lista-compon.data-termino, lista-compon-item.data-termino)
                   estrutura.fantasma         = item-lista-compon.fantasma
                   estrutura.fator-perda      = item-lista-compon.fator-perda
                   estrutura.log-quant-fix    = item-lista-compon.log-quant-fix
                   estrutura.op-codigo        = lista-compon-item.op-codigo
                   estrutura.cod-roteiro      = lista-compon-item.cod-roteiro
                   estrutura.prop-proc        = lista-compon-item.proporcao 
                   estrutura.proporcao        = item-lista-compon.proporcao
                   estrutura.qtd-item         = lista-compon-item.qtd-item.
                   /* D_MAN002 - Quantidade fixa para componentes de engenharia */
                   estrutura.qtd-compon       = if estrutura.log-quant-fix then item-lista-compon.qtd-compon
                                                else lista-compon-item.qtd-lista * item-lista-compon.qtd-compon
                                                   / item-lista-compon.qtd-lista.
            assign estrutura.quant-usada      = if estrutura.log-quant-fix then estrutura.qtd-compon
                                                else estrutura.qtd-compon / estrutura.qtd-item
                   estrutura.quant-liquid     = if estrutura.log-quant-fix then estrutura.qtd-compon
                                                else estrutura.qtd-compon * (100 - estrutura.fator-perda) / 100 
                   estrutura.tempo-reserv     = if (item-lista-compon.tempo-reserv = ? or
                                                    item.ressup-fabri = 0) then ?
                                                else min(item-lista-compon.tempo-reserv, item.ressup-fabri)
                   estrutura.tipo-sobra       = if item-lista-compon.qtd-compon >= 0
                                                then 4
                                                else item-lista-compon.int-1.

              find first ref-estrut 
                   where ref-estrut.it-codigo = lista-compon-item.it-codigo
                     and ref-estrut.es-codigo = item-lista-compon.es-codigo
                     and ref-estrut.sequencia = estrutura.sequencia
                  no-lock no-error.

              FOR FIRST bf-item FIELDS(it-codigo tipo-con-est) NO-LOCK
                  WHERE bf-item.it-codigo = item-lista-compon.es-codigo:
              END.
              if NOT AVAIL ref-estrut
              AND (     (AVAIL ITEM     AND ITEM.tipo-con-est    = 4)  // por referencia
                    OR  (AVAIL bf-item  AND bf-item.tipo-con-est = 4)) // por referencia
              then do:

                    find ref-item where
                         ref-item.it-codigo = lista-compon-item.it-codigo and
                         ref-item.cod-refer = item.cod-refer no-lock no-error.
                    if  available ref-item then assign ref-it-aux = ref-item.cod-refer.

                    find ref-item where
                         ref-item.it-codigo = item-lista-compon.es-codigo and
                         ref-item.cod-refer = item-lista-compon.cod-ref-es no-lock no-error.
                    if  available ref-item then assign ref-es-aux = ref-item.cod-refer.

                   IF (ref-it-aux <> "" OR ref-es-aux <> "")
                   THEN DO:
                       create ref-estrut.
                       assign ref-estrut.it-codigo  = lista-compon-item.it-codigo                         
                              ref-estrut.es-codigo  = item-lista-compon.es-codigo                        
                              ref-estrut.sequencia  = estrutura.sequencia
                              ref-estrut.cod-ref-it = ref-it-aux 
                              ref-estrut.cod-ref-es = ref-es-aux.
                   END.

              end.
            release estrutura.
        end.           
    end.                 
    
    if not item-lista-compon.log-compon-altern then do:
    
        for each  altern-lista-compon exclusive-lock
            where altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
              and altern-lista-compon.al-codigo        = item-lista-compon.es-codigo
              and altern-lista-compon.cod-ref-al       = item-lista-compon.cod-ref-es:
              
            delete altern-lista-compon.
        end.
    end.
    
    if item-lista-compon.log-compon-altern then do:

        for each  altern-lista-compon exclusive-lock
            where altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
              and altern-lista-compon.es-codigo        = item-lista-compon.es-codigo
              and altern-lista-compon.cod-ref-es       = item-lista-compon.cod-ref-es:
            delete altern-lista-compon.
        end.
    end.    

end procedure.

/********************************************************************************
Procedure SubstituirComponenteLista 
********************************************************************************/
PROCEDURE SubstituirComponenteLista:

    def input param v-row-table     as rowid no-undo.
    def input param v-new-es-codigo as char  no-undo.
    def input param v-new-cod-ref-es as char  no-undo.  
    def input param v-log-elimina   as log   no-undo.
    def input param v-dat-termino   as date  no-undo.
    def input param v-fator-conv    as dec   no-undo.
  &IF DEFINED (bf_man_per_ppm) &THEN
    def input param v-veiculo       as log   no-undo.
    def input-output param table for tt-erro.
  &ENDIF
    
    def buffer b-item-lista-compon for item-lista-compon.
    def buffer b-altern-lista      for altern-lista-compon.
    
    find last param-en no-lock no-error.
    
    DEFINE VARIABLE v-new-sequence  AS INTEGER NO-UNDO.
    
    find item-lista-compon
        where rowid(item-lista-compon) = v-row-table NO-LOCK no-error.

    &IF DEFINED(bf_man_per_ppm) &THEN
    
        find first param-global no-lock.
        if param-global.modulo-per-ppm and
           v-veiculo then do:
        
            /*Projeto 346 - Controle de Potˆncia - Passa a permitir mais de um ve¡culo por estrutura.*/
/*             IF CAN-FIND (FIRST b-item-lista-compon where                                                     */
/*                                b-item-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon and */
/*                                b-item-lista-compon.veiculo                                               and */
/*                                rowid(b-item-lista-compon) <> rowid(item-lista-compon)) THEN DO:              */
/*                                                                                                              */
/*                 run utp/ut-msgs.p (input "help":u,                                                           */
/*                                    input 27345,                                                              */
/*                                    input item-lista-compon.es-codigo + "~~" +                                */
/*                                          item-lista-compon.cod-lista-compon).                                */
/*                                                                                                              */
/*                 create tt-erro.                                                                              */
/*                 assign tt-erro.cd-erro  = 27345                                                              */
/*                        tt-erro.mensagem = RETURN-VALUE.                                                      */
/*                 return 'nok':u.                                                                              */
/*                                                                                                              */
/*             end.                                                                                             */
            
            for first altern-lista-compon no-lock where
                      altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon and
                      altern-lista-compon.es-codigo        = item-lista-compon.es-codigo,
                first item no-lock where
                      item.it-codigo     = altern-lista-compon.al-codigo and
                      item.tipo-formula <> 4:
                
                run utp/ut-msgs.p (input "help":u,
                                   input 27330,
                                   input item-lista-compon.es-codigo + "~~" + 
                                         item-lista-compon.cod-lista-compon).

                create tt-erro.
                assign tt-erro.cd-erro  = 27330
                       tt-erro.mensagem = RETURN-VALUE.
                return 'nok':u.
            
            end.
        end.
    &ENDIF

    if not can-find(first b-item-lista-compon
                    WHERE b-item-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
                      AND b-item-lista-compon.es-codigo        = v-new-es-codigo
                      AND b-item-lista-compon.sequencia        = item-lista-compon.sequencia) then do:
        
        create b-item-lista-compon.
        buffer-copy item-lista-compon except es-codigo to b-item-lista-compon 
        assign b-item-lista-compon.es-codigo    = v-new-es-codigo
               b-item-lista-compon.cod-ref-es   = v-new-cod-ref-es
               b-item-lista-compon.data-inicio  = v-dat-termino
             b-item-lista-compon.data-termino = date(12,31,9999)
             b-item-lista-compon.qtd-compon   = item-lista-compon.qtd-compon * v-fator-conv
        &IF DEFINED(bf_man_per_ppm) &THEN /*acima 205*/
                  b-item-lista-compon.veiculo = if param-global.modulo-per-ppm then v-veiculo
                                                                               else no.
           IF b-item-lista-compon.veiculo THEN
               ASSIGN 
                   &IF DEFINED(bf_man_207A) &THEN
                       b-item-lista-compon.val-perc-distrib-veic = 100.
                   &ELSE
                       OVERLAY(b-item-lista-compon.char-1,6,7) = "1000000":U.
                   &ENDIF
        &ELSE /*abaixo 205*/
                   .
        &ENDIF
        
        run AtualizarItemListaCompon (input rowid(b-item-lista-compon)).
       
        /* Executa novamente este find pois no retorno da pi acima o registro est  posicionado 
           no componente novo. */
           
        find item-lista-compon
            where rowid(item-lista-compon) = v-row-table NO-LOCK no-error.


        /* Atualiza os alternativos quando o componente alterado ‚ o pr¢prio alternativo */
        for each altern-lista-compon no-lock
            where altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
              and altern-lista-compon.al-codigo        = item-lista-compon.es-codigo
              and altern-lista-compon.cod-ref-al       = item-lista-compon.cod-ref-es:

            create b-altern-lista.
            buffer-copy altern-lista-compon except al-codigo to b-altern-lista 
            assign b-altern-lista.al-codigo  = v-new-es-codigo
                   b-altern-lista.cod-ref-es = v-new-cod-ref-es.
        end.

        /* Atualiza os alternativos quando o item alternativo ‚ o que possui alternativos */
        for each altern-lista-compon no-lock 
            where altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
              and altern-lista-compon.es-codigo        = item-lista-compon.es-codigo
              and altern-lista-compon.cod-ref-es       = item-lista-compon.cod-ref-es:

            create b-altern-lista.
            buffer-copy altern-lista-compon except es-codigo to b-altern-lista 
            assign b-altern-lista.es-codigo  = v-new-es-codigo
                   b-altern-lista.cod-ref-es = v-new-cod-ref-es.
        end.
    end.
    /*** Se componente existe pode que exista como componente desativado ou como
         componente alternativo ***/
    else do:
        assign v-new-sequence = item-lista-compon.sequencia + 1.
        
        CREATE b-item-lista-compon.
        buffer-copy item-lista-compon except es-codigo sequencia to b-item-lista-compon.
        assign b-item-lista-compon.sequencia    = v-new-sequence
               b-item-lista-compon.es-codigo    = v-new-es-codigo
               b-item-lista-compon.cod-ref-es   = v-new-cod-ref-es
               b-item-lista-compon.data-inicio  = v-dat-termino
             b-item-lista-compon.data-termino = date(12,31,9999)
             b-item-lista-compon.qtd-compon   = item-lista-compon.qtd-compon * v-fator-conv
        &IF DEFINED(bf_man_per_ppm) &THEN /*acima 205*/
                  b-item-lista-compon.veiculo = if param-global.modulo-per-ppm then v-veiculo
                                                                               else no.
           IF b-item-lista-compon.veiculo THEN
               ASSIGN 
                   &IF DEFINED(bf_man_207A) &THEN
                       b-item-lista-compon.val-perc-distrib-veic = 100.
                   &ELSE
                       OVERLAY(b-item-lista-compon.char-1,6,7) = "1000000":U.
                   &ENDIF
        &ELSE /*abaixo 205*/
                   .
        &ENDIF
        
        run AtualizarItemListaCompon (input rowid(b-item-lista-compon)).
        
        /*
        find first b-item-lista-compon
             where b-item-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
               and b-item-lista-compon.es-codigo        = v-new-es-codigo
               AND b-item-lista-compon.sequencia        = v-new-sequence EXCLUSIVE-LOCK no-error.
        
        assign b-item-lista-compon.data-termino = date(12,31,9999)
        &IF DEFINED(bf_man_per_ppm) &THEN /*acima 205*/
                  b-item-lista-compon.veiculo = if param-global.modulo-per-ppm then v-veiculo
                                                                               else no.
           IF b-item-lista-compon.veiculo THEN
               ASSIGN 
                   &IF DEFINED(bf_man_207A) &THEN
                       b-item-lista-compon.val-perc-distrib-veic = 100.
                   &ELSE
                       OVERLAY(b-item-lista-compon.char-1,6,7) = "1000000":U.
                   &ENDIF
        &ELSE /*abaixo 205*/
                   .
        &ENDIF
        */
        
        run AtualizarItemListaCompon (input rowid(b-item-lista-compon)).
        
        if  b-item-lista-compon.log-compon-altern then do:
            
            assign b-item-lista-compon.log-compon-altern = no.
              
            /*** Os alternativos do componente anterior pasam a ser alternativos do novo componente ***/
            for each altern-lista-compon no-lock
                where altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
                  and altern-lista-compon.es-codigo        = item-lista-compon.es-codigo
                  and altern-lista-compon.cod-ref-es       = item-lista-compon.cod-ref-es:
        
                if  altern-lista-compon.es-codigo <> v-new-es-codigo then do:
                    /*** Usar find antes para nÆo replicar registros ***/
                    create b-altern-lista.
                    buffer-copy altern-lista-compon except es-codigo to b-altern-lista.
                    ASSIGN b-altern-lista.es-codigo  = v-new-es-codigo
                           b-altern-lista.cod-ref-es = v-new-cod-ref-es.
                end.
            end.

            /*** O componente anterior perde os alternativos ***/
            for each altern-lista-compon exclusive-lock
                where altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
                  and altern-lista-compon.es-codigo        = item-lista-compon.es-codigo
                  and altern-lista-compon.cod-ref-es       = item-lista-compon.cod-ref-es:

                delete altern-lista-compon.
            end.
            
            if  can-find (first altern-lista-compon
                          where altern-lista-compon.cod-lista-compon = b-item-lista-compon.cod-lista-compon
                            and altern-lista-compon.al-codigo        = b-item-lista-compon.es-codigo
                            and altern-lista-compon.cod-ref-al       = b-item-lista-compon.cod-ref-es
                            and altern-lista-compon.es-codigo        = b-item-lista-compon.es-codigo
                            and altern-lista-compon.cod-ref-es       = b-item-lista-compon.cod-ref-es) then do:
                find current item-lista-compon exclusive-lock.
            assign item-lista-compon.log-compon-altern = yes.
            end.     
        end.
    end.        

    run findRowid (input v-row-table).
             
    if  v-log-elimina = yes then
        run executeDelete.
    else
        run DesativarComponenteLista (input v-dat-termino).

END PROCEDURE.

PROCEDURE DesativarComponenteLista:
    /* ATEN€ÇO: Antes de executar esta pi deve-se executar a pi findRowid para posicionar o registro 
                item-lista-compon */

    def input param v-dat-termino as date no-undo.

    find current item-lista-compon exclusive-lock no-error.

    for each estrutura use-index lista-compon exclusive-lock
       where estrutura.cod-lista-compon      = item-lista-compon.cod-lista-compon
         and estrutura.es-codigo             = item-lista-compon.es-codigo
         and substring(estrutura.char-1,1,5) = string(item-lista-compon.sequencia,">>>>9"):
       assign estrutura.data-termino = v-dat-termino.
    end.
    
    assign item-lista-compon.data-termino = v-dat-termino.
    
    /* Elimina os alternativos quando o componente alterado ‚ o pr¢prio alternativo */
    for each altern-lista-compon exclusive-lock
        where altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
          and altern-lista-compon.al-codigo        = item-lista-compon.es-codigo
          and altern-lista-compon.cod-ref-al       = item-lista-compon.cod-ref-es:

        delete altern-lista-compon.
    end.

    /* Elimina os alternativos quando o item alternativo ‚ o que possui alternativos */
    for each altern-lista-compon exclusive-lock
        where altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon
          and altern-lista-compon.es-codigo        = item-lista-compon.es-codigo
          and altern-lista-compon.cod-ref-es       = item-lista-compon.cod-ref-es:
        delete altern-lista-compon.
    end.
    
END PROCEDURE.
