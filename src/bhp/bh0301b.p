/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0301B 2.00.00.007} /*** "010007" 11/11/2025 11:26:20  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BH0301B MBH}
&ENDIF


/*******************************************************************************
**
**  BH0301B - Faz a transferencia do registro para o arquivo de historicos.
**
**            PRODUCAO 
**
*******************************************************************************/

def new global shared var c-arqtrans as character no-undo.

def input param c-nome-arq as character no-undo.
def input param r-arqmov   as rowid     no-undo.

{cdp/cdcfgmat.i}  /* Preprocessador bf_mat_conta_estab */
{cdp/cdcfgman.i}  /* Preprocessador bf_man_linha_estab */


DISABLE TRIGGERS FOR LOAD OF hisind.movto-mat.
DISABLE TRIGGERS FOR LOAD OF hisind.movto-dir.
DISABLE TRIGGERS FOR LOAD OF hisind.movto-ggf.
DISABLE TRIGGERS FOR LOAD OF hisind.cab-req-sum.
DISABLE TRIGGERS FOR LOAD OF hisind.req-sum.
DISABLE TRIGGERS FOR LOAD OF hisind.reservas.
DISABLE TRIGGERS FOR LOAD OF hisind.ref-ordem.
DISABLE TRIGGERS FOR LOAD OF hisind.oper-ord.
DISABLE TRIGGERS FOR LOAD OF hisind.ext-ord.
DISABLE TRIGGERS FOR LOAD OF hisind.ext-ord-per.
DISABLE TRIGGERS FOR LOAD OF hisind.ord-prod.
DISABLE TRIGGERS FOR LOAD OF hisind.pert-ordem.
DISABLE TRIGGERS FOR LOAD OF hisind.rep-oper.

DISABLE TRIGGERS FOR LOAD OF movind.req-sum.
DISABLE TRIGGERS FOR LOAD OF movind.movto-ggf.  
DISABLE TRIGGERS FOR LOAD OF movind.movto-dir. 
        
DO TRANS ON ERROR UNDO, RETURN "Nok":u:
    if  c-nome-arq = "ext-ord" then do:
        find movind.ext-ord where rowid(movind.ext-ord) = r-arqmov no-lock no-error.
        {bhp/bh9800.i &area=ind &arqmov=ext-ord}
    end.
    else
    if  c-nome-arq = "ext-ord-per" then do:
        find movind.ext-ord-per where rowid(movind.ext-ord-per) = r-arqmov no-lock no-error.
        {bhp/bh9800.i &area=ind &arqmov=ext-ord-per}
    end.
    else
    if  c-nome-arq = "movto-mat" then do:
        find movind.movto-mat where rowid(movind.movto-mat) = r-arqmov no-lock no-error.
        {bhp/bh9800.i &area=ind &arqmov=movto-mat}
    end.
    else
    if  c-nome-arq = "movto-ggf" then do:
        DEF BUFFER b-movto-ggf FOR hisind.movto-ggf.
        
        find movind.movto-ggf where rowid(movind.movto-ggf) = r-arqmov no-lock no-error.

        
        FIND FIRST b-movto-ggf NO-LOCK
             WHERE b-movto-ggf.num-id-movto-ggf = movind.movto-ggf.num-id-movto-ggf NO-ERROR.
        IF AVAIL b-movto-ggf THEN
            FOR LAST b-movto-ggf NO-LOCK USE-INDEX token: END.
        
        create hisind.movto-ggf.
        buffer-copy  movind.movto-ggf to hisind.movto-ggf
            ASSIGN hisind.movto-ggf.num-id-movto-ggf = IF AVAIL b-movto-ggf 
                                                       THEN (b-movto-ggf.num-id-movto-ggf + 1)
                                                       ELSE (movind.movto-ggf.num-id-movto-ggf)
            
            .
    end.
    else
    if  c-nome-arq = "movto-dir" then do:
        DEF BUFFER b-movto-dir FOR hisind.movto-dir.
        
        find movind.movto-dir where rowid(movind.movto-dir) = r-arqmov no-lock no-error.

        FIND FIRST b-movto-dir NO-LOCK
             WHERE b-movto-dir.num-id-movto-dir = movind.movto-dir.num-id-movto-dir NO-ERROR.
        IF AVAIL b-movto-dir THEN
            FOR LAST b-movto-dir NO-LOCK USE-INDEX token: END.
        
        create hisind.movto-dir.
        buffer-copy  movind.movto-dir to hisind.movto-dir
            ASSIGN hisind.movto-dir.num-id-movto-dir = IF AVAIL b-movto-dir 
                                                       THEN (b-movto-dir.num-id-movto-dir + 1)
                                                       ELSE (movind.movto-dir.num-id-movto-dir)
            
            .
    end.
    else
    if  c-nome-arq = "oper-ord" then do:
        find movind.oper-ord where rowid(movind.oper-ord) = r-arqmov no-lock no-error.
        {bhp/bh9800.i &area=ind &arqmov=oper-ord}
    end.
    else
    if  c-nome-arq = "ord-prod" then do:
        find movind.ord-prod where rowid(movind.ord-prod) = r-arqmov no-lock no-error.
        {bhp/bh9800.i &area=ind &arqmov=ord-prod}
    end.
    else
    if  c-nome-arq = "pert-ordem" then do:
        find movind.pert-ordem where rowid(movind.pert-ordem) = r-arqmov no-lock no-error.
        {bhp/bh9800.i &area=ind &arqmov=pert-ordem}
    end.
    else
    if  c-nome-arq = "ref-ordem" then do:
        find movind.ref-ordem where rowid(movind.ref-ordem) = r-arqmov no-lock no-error.
        {bhp/bh9800.i &area=ind &arqmov=ref-ordem}
    end.
    else
    if  c-nome-arq = "req-sum" then do:
        find movind.req-sum where rowid(movind.req-sum) = r-arqmov no-lock no-error.



        FIND FIRST hisind.req-sum EXCLUSIVE-LOCK
             WHERE hisind.req-sum.nr-req-sum = movind.req-sum.nr-req-sum 
               AND hisind.req-sum.it-codigo  = movind.req-sum.it-codigo
               AND hisind.req-sum.cod-refer  = movind.req-sum.cod-refer NO-ERROR.
        IF NOT AVAIL hisind.req-sum THEN DO:
            create hisind.req-sum.
            buffer-copy movind.req-sum to hisind.req-sum.
        END.
        ELSE DO:
             ASSIGN hisind.req-sum.qt-atendida = hisind.req-sum.qt-atendida + movind.req-sum.qt-atendida
                    hisind.req-sum.qt-requis   = hisind.req-sum.qt-requis   + movind.req-sum.qt-requis  
                    hisind.req-sum.qt-solicit  = hisind.req-sum.qt-solicit  + movind.req-sum.qt-solicit 
                    hisind.req-sum.quant-aloc  = hisind.req-sum.quant-aloc  + movind.req-sum.quant-aloc.
        END.
        FIND CURRENT hisind.req-sum NO-LOCK NO-ERROR.
    end.
    else
    if  c-nome-arq = "reservas" then do:
        find movind.reservas where rowid(movind.reservas) = r-arqmov no-lock no-error.
        {bhp/bh9800.i &area=ind &arqmov=reservas}
    end.
    else
    if  c-nome-arq = "cab-req-sum" then do:
        find movind.cab-req-sum where rowid(movind.cab-req-sum) = r-arqmov no-lock no-error.
        {bhp/bh9800.i &area=ind &arqmov=cab-req-sum}
    end.
    else
    if  c-nome-arq = "rep-oper" then do:
        find movind.rep-oper where rowid(movind.rep-oper) = r-arqmov no-lock no-error.
        {bhp/bh9800.i &area=ind &arqmov=rep-oper}    
    end.
    else do:
        run utp/ut-msgs.p (input "msg",
                           input 2590,
                           input c-nome-arq).
    end. 

END.

RETURN "Ok":u.
