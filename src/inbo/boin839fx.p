/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i BOIN839FX 2.00.00.005} /*** "010005" 28/12/2023 20:57:25  ***/


/***************************************************************************
**
**       Programa: BOIN839FX.p
**
**       Objetivo: BO - Fabricantes de Medicamentos
**
****************************************************************************/

{cdp/cdcfgmat.i}

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no

{utp/ut-glob.i}

{method/dbofun.i}

{fch/fchmat/fchmatmaterialmanufacturer.i ttManufacturerVO} 
{fch/fchmat/fchmatenterquotations.i}  /* ttQuotations */
{fch/fchmat/fchmatstring.i ttItems}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemManufacturers DBOFunction 
PROCEDURE getItemManufacturers :

    /*****************************************************************************
    **       Objetivo: Busca fabricantes de medicamentos ativos para o item
    **
    **       Parƒmetro: Recebe lista com o c¢digo do Item
    **       Retorno: Retorna uma lista de medicamentos
    *****************************************************************************/
    
    DEF INPUT  PARAM table for ttItems.
	def output param table for ttManufacturerVO.
    DEF OUTPUT PARAM TABLE FOR Rowerrors.

	if can-find(first funcao where funcao.cd-funcao = "spp-integra-ems-his" and funcao.ativo = yes) then do:
        for each ttItems:
            create ttManufacturerVO.
    		assign ttManufacturerVO.manufacturerCode = 0
    			   ttManufacturerVO.manufacturerDescription = ""
                   ttManufacturerVO.item = ttItems.stringName.
            for each fab-medic-item 
                 where fab-medic-item.cod-item = ttItems.stringName
                   and fab-medic-item.log-ativo no-lock:
    			for first fab-medic 
                    where fab-medic.cdn-fabrican = fab-medic-item.cdn-fabrican no-lock:
    				create ttManufacturerVO.
    				assign ttManufacturerVO.manufacturerCode = fab-medic.cdn-fabrican
    					   ttManufacturerVO.manufacturerDescription = fab-medic.nom-fabrican
                           ttManufacturerVO.item = ttItems.stringName.
    			end.
    		end.
        end.
	end.

	RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInformationsManufacturer DBOFunction 
PROCEDURE getInformationsManufacturer :
    def input-output param table for ttQuotations.

    /*****************************************************************************
    **       Objetivo: Busca informa‡äes do fabricante Medicamentos(Se fun‡Æo est  ativa/ Descri‡Æo do Fabricante)
    **
    **       Parƒmetro: Recebe o c¢digo do Item
    **       Retorno: Retorna uma lista de fabricantes de medicamentos
    *****************************************************************************/

    if can-find(first funcao where funcao.cd-funcao = "spp-integra-ems-his" and funcao.ativo = yes) then do:    
        for each ttQuotations:
            assign ttQuotations.activeHisFunction = yes.
        
            for first fab-medic fields (nom-fabrican) 
                where fab-medic.cdn-fabrican = ttQuotations.manufacturer no-lock:
                assign ttQuotations.manufacturerDescription = nom-fabrican.
            end.
    	end.
    end.

	RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getManufacturersReport DBOFunction 
PROCEDURE getManufacturersReport :

    /*****************************************************************************
    **       Objetivo: Busca fabricantes de medicamentos ativos para o item
    **                 para ser apresentado no relat¢rio de solicita‡Æo de 
    **                 cota‡Æo
    **
    **       Parƒmetro: Recebe o c¢digo do Item
    **       Retorno: Retorna uma lista de fabricantes de medicamentos
    *****************************************************************************/
    
    DEF INPUT  PARAM pc-item like item.it-codigo no-undo.
	def output param table for ttManufacturerVO.
    DEF OUTPUT PARAM TABLE FOR Rowerrors.

    EMPTY TEMP-TABLE ttManufacturerVO.
    if can-find(first funcao where funcao.cd-funcao = "spp-integra-ems-his" and funcao.ativo = yes) then do:
        for each fab-medic-item 
             where fab-medic-item.cod-item = pc-item
               and fab-medic-item.log-ativo no-lock:
        	for first fab-medic 
                where fab-medic.cdn-fabrican = fab-medic-item.cdn-fabrican no-lock:
        		create ttManufacturerVO.
        		assign ttManufacturerVO.manufacturerCode = fab-medic.cdn-fabrican
        			   ttManufacturerVO.manufacturerDescription = fab-medic.nom-fabrican
                       ttManufacturerVO.item = pc-item.
        	end.
        end.
    end.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
