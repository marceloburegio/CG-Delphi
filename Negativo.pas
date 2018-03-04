unit Negativo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, StdCtrls, ExtCtrls, Global;

type
  TFormNegativo = class(TForm)
    BtAbrirImagem: TButton;
    OpenDialogImage: TOpenDialog;
    BtVisualizarNegativo: TButton;
    LNegativo: TLabel;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Imagem1: TImage;
    GroupBox1: TGroupBox;
    Imagem2: TImage;
    procedure BtVisualizarNegativoClick(Sender: TObject);
    procedure BtAbrirImagemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormNegativo: TFormNegativo;
  ImagemPGM1: ImagemPGM;
  
implementation

{$R *.dfm}

procedure TFormNegativo.BtAbrirImagemClick(Sender: TObject);
begin
  if OpenDialogImage.Execute
  then
  begin
    ImagemPGM1 := AbrirImagem(OpenDialogImage.FileName);
    LimparImagem(Imagem1);
    DesenharImagem(ImagemPGM1, Imagem1);
  end;
end;

// Ação do botão Aplicar Negativo
procedure TFormNegativo.BtVisualizarNegativoClick(Sender: TObject);
var
  ImagemPGM2: ImagemPGM;
begin
  // Aplicando o Negativo da imagem
  ImagemPGM2 := AplicarNegativo(ImagemPGM1);

  // Desenhando a imagem final
  DesenharImagem(ImagemPGM2, Imagem2);
end;

end.
