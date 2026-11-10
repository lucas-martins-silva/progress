/*1.	Incluir a chamada das includes que definir∆o as vari†veis de trabalho do EMS.  
        Verificar se o seu programa n∆o possui estas chamadas.*/

/*2.	Incluir a chamada da Include lic/lic003.i1.*/


{lic/lic003.i1}

/*3.	Definir a vari†vel l-magnus:*/
def new global shared var l-magnus as logical no-undo init no.

/*4.	Alimentar as vari†veis abaixo conforme segue:*/
Assign cv-nome-prog = "MAF-LOG":
       cv-valor-prog = 0
       cv-contato = "servico.logistica@datasul.com.br":U
       cv-termo1 = yes
	   l-magnus = yes.
/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "A_combinar" *}
ASSIGN cv-valor-ext = TRIM(RETURN-VALUE).
{utp/ut-liter.i "efetuar_avaliaá‰es_dos_fornecedores" *}
ASSIGN cv-desc-prog = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Datasul_Log°stica" *}
ASSIGN cv-autor-prog = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Este_programa_Ç_de_uso_exclusivo_da_empresa_que_esta_adquirindo_o_pacote" *}
ASSIGN cv-termo-adic = TRIM(RETURN-VALUE) + ".".
	   

/*5.	Chamar o programa de avaliaá∆o de licenáa:*/
RUN lic/lic003c.p PERSISTENT SET H-VALIDACAO 
    (INPUT  cv-nome-prog,
     INPUT  cv-valor-prog,
     INPUT cv-valor-ext,
     INPUT  cv-desc-prog,
     INPUT  cv-autor-prog,
     INPUT  cv-contato,
     INPUT  cv-termo-adic,
     INPUT  cv-termo1,
     OUTPUT lv-erro).

/*6.	Verificar se houve erro de validaá∆o, em caso afirmativo, o seu programa n∆o poder† ser executado.*/
IF lv-erro = YES THEN do:
    &if proversion >= "8.0" &then
        DELETE OBJECT H-VALIDACAO. 
    &endif    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Processo_interrompido_por_problemas_na_validaá∆o" *}
    message RETURN-VALUE + " !!!" view-as alert-box.
    RETURN "NOK".
end. 

/*7.	Limpar programa persistent:*/
&if proversion >= "8.0" &then
    DELETE OBJECT H-VALIDACAO. /* Deletar Handle se n∆o houver erro */
&endif    




