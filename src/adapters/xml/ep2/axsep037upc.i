 
/*-------------------------------------------------
               AXSEP017UPC.i
-------------------------------------------------*/


PROCEDURE pi-executa-upc:
      
    FOR EACH tt-epc 
       WHERE tt-epc.cod-event = "AtualizaDadosNFe":U :
        DELETE tt-epc.
    END.

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttAdi":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttAdi:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttArma":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttArma:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttAutXML":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttAutXML:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttAvulsa":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttAvulsa:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttCobr":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttCobr:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttCOFINSAliq":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttCOFINSAliq:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttCOFINSNT":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttCOFINSNT:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttCOFINSOutr":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttCOFINSOutr:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttCOFINSQtde":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttCOFINSQtde:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttCOFINSST":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttCOFINSST:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMSUFDest":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMSUFDest:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttComb":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttComb:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttCompra":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttCompra:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttDest":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttDest:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttDet":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttDet:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttDetObsCont":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttDetObsCont:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttDetObsfisco":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttDetObsfisco:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttDetExport":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttDetExport:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttDI":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttDI:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttDup":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttDup:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttEmit":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttEmit:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttEntrega":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttEntrega:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttExporta":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttExporta:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS00":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS00:HANDLE).
    
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS02":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS02:HANDLE).
        
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS10":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS10:HANDLE).
        
   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
          tt-epc.cod-parameter = "ttICMS15":U
          tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS15:HANDLE).

   CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS20":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS20:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS30":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS30:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS40":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS40:HANDLE).
        
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS51":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS51:HANDLE).
        
   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
          tt-epc.cod-parameter = "ttICMS53":U
          tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS53:HANDLE).
       
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS60":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS60:HANDLE).
        
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS61":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS61:HANDLE).
        
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS70":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS70:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMS90":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMS90:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMSTot":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMSTot:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttIde":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttIde:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttII":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttII:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttImpostoDevol":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttImpostoDevol:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttInfAdic":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttInfAdic:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttIPI":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttIPI:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttISSQN":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttISSQN:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttISSQNtot":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttISSQNtot:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttLacres":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttLacres:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttMed":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttMed:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttNFe":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttNFe:HANDLE).
    
    /* enviar a ttrefNF com o nome novo e antigo para n∆o impactar nos espec°ficos dos clientes */
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttNFRef":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttrefNF:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttrefNF":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttrefNF:HANDLE).
    /* fim - enviar ttrefNF */

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttrefNFP":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttrefNFP:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttrefCTe":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttrefCTe:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttrefECF":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttrefECF:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttObsCont":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttObsCont:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttObsFisco":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttObsFisco:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttPISAliq":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttPISAliq:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttPISNT":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttPISNT:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttPISOutr":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttPISOutr:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttPISQtde":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttPISQtde:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttPISST":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttPISST:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttProcRef":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttProcRef:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttReboque":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttReboque:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttRetirada":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttRetirada:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttRetTrib":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttRetTrib:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttTransp":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttTransp:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttVeic":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttVeic:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttVol":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttVol:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMSPart":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMSPart:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMSST":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMSST:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMSSN101":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMSSN101:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMSSN102":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMSSN102:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMSSN201":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMSSN201:HANDLE).
    
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMSSN202":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMSSN202:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMSSN500":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMSSN500:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttICMSSN900":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttICMSSN900:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttCana":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttCana:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttForDia":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttForDia:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttDeduc":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttDeduc:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttRastro":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttRastro:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttPag":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttPag:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttInfIntermed":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttInfIntermed:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttDetPag":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttDetPag:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgCompraGov":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgCompraGov:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgPagAntecipado":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgPagAntecipado:HANDLE).
           
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttIBSCBS":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttIBSCBS:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttTribRT":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttTribRT:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgTribRegular":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgTribRegular:HANDLE).          

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgCredPresOper":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgCredPresOper:HANDLE).  
           
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgIBSCBSCredPres":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgIBSCBSCredPres:HANDLE).             

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgTribCompraGov":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgTribCompraGov:HANDLE).           

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgIBSCBSMono":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgIBSCBSMono:HANDLE).           

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgTransfCred":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgTransfCred:HANDLE).                  

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgAjusteCompet":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgAjusteCompet:HANDLE).                 

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgEstornoCred":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgEstornoCred:HANDLE).      
           
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttgCredPresIBSZFM":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttgCredPresIBSZFM:HANDLE).           
           
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttVB":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttVB:HANDLE).          

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttDFeReferenciado":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttDFeReferenciado:HANDLE).          
           
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "ttTotIBSCBSIS":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttTotIBSCBSIS:HANDLE).          
           
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDadosNFe":U
           tt-epc.cod-parameter = "handle":U
           tt-epc.val-parameter = STRING(THIS-PROCEDURE:HANDLE).
           
    {include/i-epc201.i "AtualizaDadosNFe"}

END PROCEDURE.
