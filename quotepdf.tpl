<?php
if(function_exists('RSThemeCAVars')){
$tplvars['templatefile'] = 'quotepdf';
$RSThemes = RSThemeCAVars($tplvars);
}
if(isset($RSThemes['RSThemes']['pages']['quotepdf'])){
require ROOTDIR.DS.$RSThemes['RSThemes']['pages']['quotepdf']['fullPath'];
} else {
# Logo
$logoFilename = 'placeholder.png';
if (file_exists(ROOTDIR . '/assets/img/logo.png')) {
    $logoFilename = 'logo.png';
} elseif (file_exists(ROOTDIR . '/assets/img/logo.jpg')) {
    $logoFilename = 'logo.jpg';
}
$pdf->Image(ROOTDIR . '/assets/img/' . $logoFilename, 15, 14, 52);

# Company Details
$pdf->SetXY(36,15);
$pdf->SetFont('freesans','B',11);
$pdf->Cell(160,6,trim($companyaddress[0]),0,1,'R');
$pdf->SetFont('freesans','',9);
for ( $i = 1; $i <= ((count($companyaddress)>6) ? count($companyaddress) : 6); $i += 1) {
	$pdf->Cell(180,4,trim($companyaddress[$i]),0,1,'R');
}
$pdf->Ln(6);

# Header Bar
$invoiceprefix = $_LANG["invoicenumber"];
/*
** This code should be uncommented for EU companies using the sequential invoice numbering so that when unpaid it is shown as a proforma invoice **
if ($status!="Paid") {
	$invoiceprefix = $_LANG["proformainvoicenumber"];
}
*/
$pdf->SetXY(15,50);
$pdf->SetFont('freesans','B',12);
$pdf->SetFillColor(539);
$quotenumber = "YD/Q/2024/" . $quotenumber;
$pdf->Cell(0,3,$_LANG["quotenumber"].': '.$quotenumber.'',0,1,'R','1');
$pdf->SetFont('freesans','',10);
$pdf->Cell(0,3,$_LANG["quotesubject"].': '.$subject.'',0,1,'R','1');
$pdf->Cell(0,3,$_LANG["quotedatecreated"].': '.$datecreated.'',0,1,'R','1');
$pdf->Cell(0,3,$_LANG["quotevaliduntil"].': '.$validuntil.'',0,1,'R','1');
$pdf->Ln(5);


$pdf->SetXY(15,50);
$pdf->SetFont($pdfFont,'B',10);
$pdf->Cell(0,4,$_LANG['quoterecipient'],0,1);
$pdf->SetFont($pdfFont,'',9);
if ($clientsdetails["companyname"]) {
	$pdf->Cell(0,4,$clientsdetails["companyname"],0,1,'L');
	$pdf->Cell(0,4,$_LANG["invoicesattn"].": ".$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L');
} else {
	$pdf->Cell(0,4,$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L');
}
$pdf->Cell(0,4,$clientsdetails["address1"].", ".$clientsdetails["city"].", ".$clientsdetails["postcode"],0,1,'L');
if ($clientsdetails["address2"]) {
	$pdf->Cell(0,4,$clientsdetails["address2"],0,1,'L');
}
$pdf->Cell(0,4,$clientsdetails["state"].", ".$clientsdetails["country"],0,1,'L');
if ($customfields) {
    $pdf->Ln();
    foreach ($customfields AS $customfield) {
        $pdf->Cell(0,4,$customfield['fieldname'].': '.$customfield['value'],0,1,'L');
    }
}
$pdf->Ln(10);

# Proposal Overview
$proposaloverview = "Proposal Overview";
$pdf->SetFont('freesans','B',12);
$pdf->Cell(0,4,$proposaloverview,0,1,'C');

$pdf->Ln(5);

if ($proposal) {
$pdf->SetFont($pdfFont,'',9);
$pdf->MultiCell(170,5,$proposal);
$pdf->Ln(5);
}

# Investment
$investment = "Investment Overview";
$pdf->SetFont('freesans','B',12);
$pdf->Cell(0,4,$investment,0,1,'C');
$pdf->Ln(5);

$pdf->SetDrawColor(200);
$pdf->SetFillColor(239);

$pdf->SetFont($pdfFont,'',8);

$tblhtml = '<table width="100%" bgcolor="#ccc" cellspacing="1" cellpadding="2" border="0">
<tr height="30" bgcolor="#efefef" style="font-weight:bold;text-align:center;">
<td width="5%">'.$_LANG['quoteqty'].'</td>
<td width="45%">'.$_LANG['quotedesc'].'</td>
<td width="15%">'.$_LANG['quoteunitprice'].'</td>
<td width="15%">'.$_LANG['quotediscount'].'</td>
<td width="20%">'.$_LANG['quotelinetotal'].'</td>
</tr>';
foreach ($lineitems AS $item) {
$tblhtml .= '
<tr bgcolor="#fff">
<td align="center">'.$item['qty'].'</td>
<td align="left">'.nl2br($item['description']).'<br /></td>
<td align="center">'.$item['unitprice'].'</td>
<td align="center">'.$item['discount'].'</td>
<td align="center">'.$item['total'].'</td>
</tr>';
}
$tblhtml .= '
<tr height="30" bgcolor="#efefef" style="font-weight:bold;">
<td align="right" colspan="4">'.$_LANG['invoicessubtotal'].'</td>
<td align="center">'.$subtotal.'</td>
</tr>';
if ($taxlevel1['rate']>0) $tblhtml .= '
<tr height="30" bgcolor="#efefef" style="font-weight:bold;">
<td align="right" colspan="4">'.$taxlevel1['name'].' @ '.$taxlevel1['rate'].'%</td>
<td align="center">'.$tax1.'</td>
</tr>';
if ($taxlevel2['rate']>0) $tblhtml .= '
<tr height="30" bgcolor="#efefef" style="font-weight:bold;">
<td align="right" colspan="4">'.$taxlevel2['name'].' @ '.$taxlevel2['rate'].'%</td>
<td align="center">'.$tax2.'</td>
</tr>';
$tblhtml .= '
<tr height="30" bgcolor="#efefef" style="font-weight:bold;">
<td align="right" colspan="4">'.$_LANG['invoicestotal'].'</td>
<td align="center">'.$total.'</td>
</tr>
</table>';

$pdf->writeHTML($tblhtml, true, false, false, false, '');
$pdf->Ln(5);


# Conclusion
$conclusion = "Conclusion";
$pdf->SetFont('freesans','B',12);
$pdf->Cell(0,4,$conclusion,0,1,'L');
$pdf->Ln(3);

if ($notes) {
$pdf->SetFont($pdfFont,'',8);
$pdf->MultiCell(170,5,$notes);
}
}
