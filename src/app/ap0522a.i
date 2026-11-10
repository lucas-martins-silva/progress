/************************************************************************
**  AP0522A.I - Apartir da Release 204 passa a replicar as informacoes
**              alteradas das Antecipacoes e PEFïs, para o multiplanta  
*************************************************************************/

def var l-replica-an-pef as logical initial no no-undo.

&IF DEFINED(BF_FIN_REPLICA_AN_PEF) &THEN
    assign l-replica-an-pef = yes.
&ELSE
    if can-find(first funcao where 
                      funcao.cd-funcao = "spp-repl_an_pef" and
                      funcao.ativo     = yes) then
       assign l-replica-an-pef = yes.
&ENDIF
