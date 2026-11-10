/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0545F 2.00.00.009 } /*** "010009" 30/11/2023 13:57:57 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0545f MIM}
&ENDIF

/*******************************************************************************
**
**  IM0545F.P - Valida chamada para consulta dos t°tulos do embarque.
**
**  tit-ap - Titulos a Pagar
**
*******************************************************************************/
DEFINE INPUT PARAMETER p-rowid AS ROWID NO-UNDO.

{include/i_fncrowid.i}
{cdp/cdcfgmat.i} /* Integraá∆o Importacao */ 
{btb/btb009za.i} /* Temp-tables de comunicaá∆o api btb009za.p */
{cdp/cd4300.i3} /*Vari†veis que ser∆o utilizadas no cd4300.i4*/
{rep/re1001a.i50} /*Vari†veis do embarque*/


def var l-ems50         as logical no-undo init no.
def var l-erro-ems50    as logical no-undo init no.
def var l-emsbas        as logical no-undo init no.
def var l-emsfin        as logical no-undo init no.
def var l-emsuni        as logical no-undo init no.
def var i-seq-erro      as int     no-undo init 0.
def var i-msg           as int     no-undo.
def var c-msg           as char    no-undo.
def var c-char          as char    no-undo.
def var hShowMsg        as handle  no-undo.
def var c-titulo        as char    no-undo.
def var c-embarque-lbl  as char    no-undo.
def var c-return        as char    no-undo.
def var p_rec_tit_ap    as &IF {&ROWID_READY} = YES &THEN 
                            ROWID
                           &ELSE 
                            RECID format ">>>>>>9"
                           &ENDIF
                           no-undo.
def var p_num_id_tit_ap as integer format "9999999999" no-undo.
def var p_cod_matriz_trad_org_ext as character         no-undo.

def new global shared var rw-tit  as rowid   no-undo.

def new global shared var v_rec_tit_ap as &IF {&ROWID_READY} = YES &THEN 
                                            ROWID
                                          &ELSE 
                                            RECID format ">>>>>>9":U initial ?
                                          &ENDIF
                                          no-undo.

&if defined(bf-mat-comex) &then
    /*run posiciona-titulo.*/
    run imp/im0545d.w (input p-rowid).
&else
    
    {include/boerrtab.i}
    
    /**********************************************************************
    **      EMS - 5.0 Integraá∆o "On-line" Datasul-EMS 2.0
    **********************************************************************/
    if  can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00" and
        funcao.ativo = yes and
        funcao.log-1 = yes) then do:        
        RUN pi-conecta-bases-EMS5 (input 1).
        if return-value = "NOK":U and CAN-FIND(FIRST tt-bo-erro) THEN DO:
            IF NOT VALID-HANDLE(hShowMsg) THEN 
                RUN utp/showmessage.w PERSISTENT SET hShowMsg.
            ELSE
                DELETE PROCEDURE hShowMsg.                
            RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).          
            LEAVE.
        END.
        ELSE assign l-ems50 = yes.
    end.
    
    if not l-erro-ems50 and l-ems50 then do:
        run posiciona-titulo-ems5.
        run prgfin/apb/apb222aa.p.
    end.

    if  l-ems50 then
        run pi-conecta-bases-EMS5 (input 2).
    else do:
        run posiciona-titulo.
        run app/ap0804f.w.
        leave.
    end.

procedure pi-conecta-bases-EMS5:
    /*
    ** Conecta/Disconecta Bancos EMS 5
    */
    DEF input parameter p-conexao as integer no-undo. /* 1 - conex∆o, 2 - desconex∆o */
    
    DEF VAR h-btb009za AS HANDLE.
    
    if not avail param-global then
        find first param-global no-lock no-error.
    
    RUN btb/btb009za.p PERSISTENT SET h-btb009za.    
    run pi-conecta-bco IN h-btb009za (Input 1,
                                      Input p-conexao,
                                      Input param-global.empresa-prin,
                                      Input "all":U,
                                      Output Table tt_erros_conexao).    
    DELETE PROCEDURE h-btb009za.
    if return-value <> "OK":U then do:
        for each tt_erros_conexao:
            assign i-msg         = tt_erros_conexao.cd-erro
                   c-msg         = tt_erros_conexao.param-1
                   c-char        = "".
            run pi-gera-erro.
        end.
        find first tt_erros_conexao no-error.
        if avail tt_erros_conexao 
           and tt_erros_conexao.cd-erro <> 25821 
           and tt_erros_conexao.cd-erro <> 25822 then 
        RETURN "NOK":U.
    end.

end procedure.


procedure pi-gera-erro.
    assign i-seq-erro = i-seq-erro + 1.
    run utp/ut-msgs.p (input "msg",input i-msg,input c-msg).
    do transaction:    
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = i-msg
               tt-bo-erro.mensagem = return-value + c-char.
    end.
end procedure.


PROCEDURE posiciona-titulo-ems5:
/* 
** Acha o primeiro titulo de um embarque e carrega a vari†vel global
** v_rec_tit_ap, para abrir o programa Consulta Titulos(apb222aa) do
** ems50 posicionado no primeiro titulo gerado para um determinado embarque 
*/  

find first param-global no-lock no-error.
find embarque-imp where rowid(embarque-imp) = p-rowid no-lock no-error.
if avail embarque-imp then
   find docum-est 
       where substring(docum-est.char-1,1,20) = embarque-imp.embarque
       no-lock no-error.
   if avail docum-est then do:

          /*Grava o valor do embarque na c-embarque*/
          {cdp/cd4300.i4 "yes" docum-est.char-1}
          {rep/re1001a.i51 "yes"}
          /*Grava o valor do embarque na c-embarque*/

      
       run prgint/ufn/ufn908za.py (Input 1, 
                                   Input "14",  /*"Recebimento 2.00",*/   
                                   output p_cod_matriz_trad_org_ext).

      find first dupli-apagar 
         where dupli-apagar.serie-docto  = docum-est.serie-docto  and
               dupli-apagar.nro-docto    = docum-est.nro-docto    and
               dupli-apagar.cod-emitente = docum-est.cod-emitente and
               dupli-apagar.nat-operacao = docum-est.nat-operacao
               no-lock no-error.
      if avail dupli-apagar then do:
         run prgfin/apb/apb788za.py ( input  0,
                                      input  "",
                                      input  docum-est.cod-estabel,
                                      input  p_cod_matriz_trad_org_ext,
                                      input  dupli-apagar.cod-esp,
                                      input  docum-est.cod-emitente,
                                      input  docum-est.serie-docto,
                                      input  c-embarque,
                                      input  dupli-apagar.parcela,
                                      output c-return,
                                      output p_rec_tit_ap,
                                      output p_num_id_tit_ap).

         if c-return = "OK" then 
            assign v_rec_tit_ap = p_rec_tit_ap.
      end.
      else do:
          find first dupli-apagar-cex 
               where dupli-apagar-cex.serie-docto  = docum-est.serie-docto           and
                     &if defined(bf-mat-comex) &then
                         dupli-apagar-cex.nro-docto    = string(docum-est.nro-docto) and
                     &else
                         dupli-apagar-cex.nro-docto    = docum-est.nro-docto         and
                     &endif                     
                     dupli-apagar-cex.cod-emitente = docum-est.cod-emitente          and
                     dupli-apagar-cex.nat-operacao = docum-est.nat-operacao
                     no-lock no-error.
           if avail dupli-apagar-cex then do:
                run prgfin/apb/apb788za.py ( input  0,
                                             input  "",
                                             input  docum-est.cod-estabel,
                                             input  p_cod_matriz_trad_org_ext,
                                             input  dupli-apagar-cex.cod-esp,
                                             input  docum-est.cod-emitente,
                                             input  docum-est.serie-docto,
                                             input  c-embarque,
                                             input  dupli-apagar-cex.parcela,
                                             output c-return,
                                             output p_rec_tit_ap,
                                             output p_num_id_tit_ap).
                if c-return = "OK" then
                    assign v_rec_tit_ap = p_rec_tit_ap.
                                           
            end.
            else do:
                  {utp/ut-liter.i "t°tulos"}
                   assign c-titulo = return-value.
                   {utp/ut-liter.i "embarque"}
                   assign c-embarque-lbl = return-value.
                  run utp/ut-msgs.p (input "show",
                                     input 25515,
                                     input c-titulo + "~~" + c-embarque-lbl).
            end.
      end.
   end.

END PROCEDURE.
&endif


PROCEDURE posiciona-titulo:
/* 
** Acha o primeiro titulo de um embarque e carrega a vari†vel global
** rw-tit, para abrir o programa Consulta Titulos(ap0804f) posicionado
** no primeiro titulo gerado para um determinado embarque 
*/
   
find first param-global no-lock no-error.
find embarque-imp where rowid(embarque-imp) = p-rowid no-lock no-error.
if avail embarque-imp then
    find first tit-ap 
        where tit-ap.ep-codigo   = param-global.empresa-prin and
              tit-ap.cod-estabel = embarque-imp.cod-estabel  and
              &if defined(bf-mat-comex) &then
                 tit-ap.nr-docto    = int(embarque-imp.embarque)
              &else
                 tit-ap.nr-docto    = embarque-imp.embarque
              &endif   
              no-lock no-error.
    if avail tit-ap then do:
         assign rw-tit = rowid(tit-ap).
    end.
    else do:
        {utp/ut-liter.i "t°tulos"}
        assign c-titulo = return-value.
        {utp/ut-liter.i "embarque"}
        assign c-embarque-lbl = return-value.
        run utp/ut-msgs.p (input "show",
                           input 25515,
                           input c-titulo + "~~" + c-embarque-lbl).
    end.

END PROCEDURE.
