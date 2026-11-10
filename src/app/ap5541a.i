/********************************************************************************
***
*** app/ap5541a.i - Fun‡Æo Para Verifica‡Æo T¡tulos em Prepara‡Æo Border“.
***
********************************************************************************/

def var l-docto-prepar as logical init no no-undo.
        
&IF DEFINED(BF_FIN_DOCTO_PREPAR) &THEN
    assign l-docto-prepar = yes.
&ELSE
            
    if  can-find(first funcao 
                 where funcao.cd-funcao = 'spp-docto-prepar' 
                 and   funcao.ativo     = yes) then
                      
        assign l-docto-prepar = yes.
            
&ENDIF

/* Fim de Include */

