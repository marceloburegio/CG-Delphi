unit Global;

interface

uses
  Sysutils, extctrls, Graphics, Math, Dialogs, Windows;

type
  TStringDynArray = array of string;
  TIntegerDynArray = array of integer;
  TRealDynArray = array of real;
  TRealBiDynArray = array of TRealDynArray;
  ImagemPGM = record
    Tipo : string;
    Largura  : integer;
    Altura   : integer;
    CinzaMax : integer;
    Colorida : boolean;
    Dados : array of TIntegerDynArray;
    Red   : array of TIntegerDynArray;
    Green : array of TIntegerDynArray;
    Blue  : array of TIntegerDynArray;
  end;

// Declarando as assinaturas das funções
function AbrirImagem(NomeArquivo: String): ImagemPGM;
function CriarImagem(Largura, Altura, CinzaMax: integer): ImagemPGM;

procedure LimparImagem(Imagem: TImage);
procedure DesenharImagem(ImagemPGM: ImagemPGM; Imagem: TImage);
function NormalizarImagem(ImagemPGM: ImagemPGM): ImagemPGM;

function AplicarNegativo(Imagem1: ImagemPGM): ImagemPGM;
function AplicarGama(Imagem1: ImagemPGM; C, Gamma: real): ImagemPGM;
function AplicarMascara(ImagemPGMOriginal: ImagemPGM; Mascara: TRealBiDynArray; AplicarAbs: boolean): ImagemPGM;
function AplicarMediana(ImagemPGMOriginal: ImagemPGM): ImagemPGM;
function AplicarArnold(Imagem1: ImagemPGM): ImagemPGM;
function AplicarEqHistograma(Imagem1: ImagemPGM): ImagemPGM;
function AplicarPseudocor(ImagemPGM1: ImagemPGM; CinzaMax: integer): ImagemPGM;
function ObterCor(CorCinza, CinzaMax: integer): integer;

function SomarImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
function SubtrairImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
function DividirImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
function MultiplicarImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
function ANDImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
function ORImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
function XORImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;

function GerarHistograma(Imagem1: ImagemPGM): TIntegerDynArray;
procedure DesenharHistograma(Imagem: TImage; Dados: TIntegerDynArray);

implementation

// Função que abre uma imagem
function AbrirImagem(NomeArquivo: String): ImagemPGM;
var
  Imagem: ImagemPGM;
  Tipo: string;
  Largura, Altura, CinzaMax, i, j: integer;
  Arquivo: TextFile;

begin
  // Validando se a imagem é .pgm
  if Pos('.pgm', LowerCase(NomeArquivo)) <> 0 then
  begin

    // Abrindo o arquivo da imagem
    AssignFile(Arquivo, NomeArquivo);
    Reset(Arquivo);

    // Carregando o cabeçalho
    ReadLn(Arquivo, Tipo);                  // Lendo o Tipo da imagem

    if Trim(Tipo) <> 'P2' then
    begin
      MessageDlg('O arquivo selecionado não é uma imagem PGM', mtWarning, [mbOk], 0);
      Exit;
    end;

    ReadLn(Arquivo, Largura, Altura); // Lendo as dimensões da iamgem
    ReadLn(Arquivo, CinzaMax);        // Lendo o valor do cinza máximo

    // Criando uma imagem empty
    Imagem := CriarImagem(Largura, Altura, CinzaMax);

    // Carregando os dados contidos na imagem
    for i := 0 to (Largura - 1) do
    begin
      for j := 0 to (Altura - 1) do
      begin
        Read(Arquivo, Imagem.Dados[i][j]);
      end;
      Read(Arquivo);
    end;
    CloseFile(Arquivo);
  end;

  // Retornando a imagem
  Result := Imagem;
end;

// Cria uma imagem em branco retornando ela na função
function CriarImagem(Largura, Altura, CinzaMax: integer): ImagemPGM;
var
  Imagem: ImagemPGM;
begin
  Imagem.Largura := 0;
  Imagem.Altura := 0;
  Imagem.CinzaMax := 0;
  Imagem.Colorida := false;
  if (Largura > 0) and (Altura > 0) and (CinzaMax > 0) then
  begin
    Imagem.Largura  := Largura;
    Imagem.Altura   := Altura;
    Imagem.CinzaMax := CinzaMax;
    SetLength(Imagem.Dados, Largura, Altura);
    SetLength(Imagem.Red, Largura, Altura);
    SetLength(Imagem.Green, Largura, Altura);
    SetLength(Imagem.Blue, Largura, Altura);
  end;
  Result := Imagem;
end;

// Procedimento para a limpeza da imagem
procedure LimparImagem(Imagem: TImage);
begin
  Imagem.Canvas.Brush.Color := clBtnFace;
  Imagem.Canvas.Pen.Style := psSolid;
  Imagem.Canvas.Pen.Color := clBtnFace;
  Imagem.Canvas.Rectangle(0, 0, Imagem.Width, Imagem.Height);
end;

// Desenha a imagem PGM em uma Imagem de Destino
procedure DesenharImagem(ImagemPGM: ImagemPGM; Imagem: TImage);
var
  Red, Green, Blue: integer;
  BordaLargura, BordaAltura, i, j: integer;
begin
  // Centralizando a imagem no centro do objeto Imagem
  BordaLargura := round((Imagem.Width - ImagemPGM.Largura) / 2);
  BordaAltura  := round((Imagem.Height - ImagemPGM.Altura) / 2);

  // Limpando a área da imagem
  LimparImagem(Imagem);

  // Desenhando os pontos pixel a pixel
  for i := 0 to (ImagemPGM.Altura - 1) do
  begin
    for j := 0 to (ImagemPGM.Largura - 1) do
    begin
      if (ImagemPGM.Colorida = true) then
      begin
        Red   := ImagemPGM.Red[i, j];
        Green := ImagemPGM.Green[i, j];
        Blue  := ImagemPGM.Blue[i, j];
      end
      else
      begin
        Red   := ImagemPGM.Dados[i, j];
        Green := ImagemPGM.Dados[i, j];
        Blue  := ImagemPGM.Dados[i, j];
      end;

      // Efetuando o truncamento dos valores min e máx
      if (Red < 0) then Red := 0
      else if (Red > 255) then Red := 255;

      if (Green < 0) then Green := 0
      else if (Green > 255) then Green := 255;
      
      if (Blue < 0) then Blue := 0
      else if (Blue > 255) then Blue := 255;

      Imagem.Canvas.Pixels[BordaLargura + j, BordaAltura + i] := RGB(Red, Green, Blue);
    end;
    if ((i mod 5) = 0) then Imagem.Repaint;
  end;
end;

// Função que normaliza todos os pixels da imagem
function NormalizarImagem(ImagemPGM: ImagemPGM): ImagemPGM;
var
  Cor: integer;
  i, j, CorMax, CorMin: integer;
  Fator: real;
begin
  // Calculando o fator de normalização da imagem
  CorMax := 0;
  CorMin := 255;
  for i := 0 to (ImagemPGM.Altura - 1) do
  begin
    for j := 0 to (ImagemPGM.Largura - 1) do
    begin
      Cor := ImagemPGM.Dados[i, j];

      if (Cor < CorMin) then CorMin := Cor;
      if (Cor > CorMax) then CorMax := Cor;
    end;
  end;

  // Calculando o Fator de Correção
  Fator := CorMax - CorMin;
  if (Fator = 0) then Fator := 1;
  Fator := 255 / Fator;

  // Calculando a correção em todos os pontos pixel a pixel
  for i := 0 to (ImagemPGM.Altura - 1) do
  begin
    for j := 0 to (ImagemPGM.Largura - 1) do
    begin
      // Calculando o pixel selecionado
      Cor := ImagemPGM.Dados[i, j];
      Cor := Round(Fator * (Cor - CorMin));
      
      // Efetuando o truncamento dos valores min e máx
      if (Cor < 0) then Cor := 0
      else if (Cor > 255) then Cor := 255;

      // Gravando o valor calculado
      ImagemPGM.Dados[i, j] := Cor;
    end;
  end;
  Result := ImagemPGM;
end;

function AplicarNegativo(Imagem1: ImagemPGM): ImagemPGM;
var
  i, j: integer;
  Imagem: ImagemPGM;
begin
  // Criando a imagem resultante
  Imagem := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

  // Varrendo a imagem e aplicando a fórmula do negativo
  for i := 0 to (Imagem1.Largura -1) do
  begin
    for j := 0 to (Imagem1.Altura -1) do
    begin
      Imagem.Dados[i, j] := 255 - Imagem1.Dados[i, j];
    end;
  end;
  Result := Imagem;
end;

// Aplicar Mascara com Convolução na Imagem
function AplicarMascara(ImagemPGMOriginal: ImagemPGM; Mascara: TRealBiDynArray; AplicarAbs: boolean): ImagemPGM;
var
  i, j, Cor: integer;
  ImagemPGMFiltro: ImagemPGM;
begin
  // Criando a imagem resultante
  ImagemPGMFiltro := CriarImagem(ImagemPGMOriginal.Largura, ImagemPGMOriginal.Altura, ImagemPGMOriginal.CinzaMax);
  SetLength(Mascara, 3, 3);

  // Varrendo a imagem e aplicando a fórmula do negativo
  for i := 1 to (ImagemPGMOriginal.Largura -2) do
  begin
    for j := 1 to (ImagemPGMOriginal.Altura -2) do
    begin
      
      // Aplicando a Máscara nos dados da Imagem
      Cor := Round(
        (ImagemPGMOriginal.Dados[i -1, j -1] * Mascara[0][0]) +
        (ImagemPGMOriginal.Dados[i -1, j]    * Mascara[0][1]) +
        (ImagemPGMOriginal.Dados[i -1, j +1] * Mascara[0][2]) +

        (ImagemPGMOriginal.Dados[i, j -1]    * Mascara[1][0]) +
        (ImagemPGMOriginal.Dados[i, j]       * Mascara[1][1]) +
        (ImagemPGMOriginal.Dados[i, j +1]    * Mascara[1][2]) +

        (ImagemPGMOriginal.Dados[i +1, j -1] * Mascara[2][0]) +
        (ImagemPGMOriginal.Dados[i +1, j]    * Mascara[2][1]) +
        (ImagemPGMOriginal.Dados[i +1, j +1] * Mascara[2][2]));

      // Aplicando o valor Absoluto
      if (AplicarAbs) then Cor := Abs(Cor);

      ImagemPGMFiltro.Dados[i, j] := Cor;
    end;
  end;
  Result := ImagemPGMFiltro;
end;

// Função da Correção Gama
function AplicarGama(Imagem1: ImagemPGM; C, Gamma: real): ImagemPGM;
var
  i, j: integer;
  Imagem: ImagemPGM;
begin
  // Criando uma imagem vazia
  Imagem := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

  // Varrendo a imagem e aplicando a fórmula de Arnold
  for i := 0 to (Imagem1.Largura -1) do
  begin
    for j := 0 to (Imagem1.Altura -1) do
      Imagem.Dados[i, j] := Round(Power(C * Imagem1.Dados[i, j], Gamma));
  end;
  Result := Imagem;
end;

// Função que aplica o Filtro da Mediana
function AplicarMediana(ImagemPGMOriginal: ImagemPGM): ImagemPGM;
var
  i, j, x, y, Aux: integer;
  Imagem: ImagemPGM;
  Mediana: array[0..8] of integer;
begin
  // Criando uma imagem vazia
  Imagem := CriarImagem(ImagemPGMOriginal.Largura, ImagemPGMOriginal.Altura, ImagemPGMOriginal.CinzaMax);

  // Realizando a computação da Mediana
  for i := 1 to (ImagemPGMOriginal.Largura -2) do
  begin
    for j := 1 to (ImagemPGMOriginal.Altura -2) do
    begin

      Mediana[0] := ImagemPGMOriginal.Dados[i -1][j -1];
      Mediana[1] := ImagemPGMOriginal.Dados[i -1][j];
      Mediana[2] := ImagemPGMOriginal.Dados[i -1][j +1];

      Mediana[3] := ImagemPGMOriginal.Dados[i][j -1];
      Mediana[4] := ImagemPGMOriginal.Dados[i][j];
      Mediana[5] := ImagemPGMOriginal.Dados[i][j +1];

      Mediana[6] := ImagemPGMOriginal.Dados[i +1][j -1];
      Mediana[7] := ImagemPGMOriginal.Dados[i +1][j];
      Mediana[8] := ImagemPGMOriginal.Dados[i +1][j +1];

      // Ordenando o Vetor Mediana
      for x := Low(Mediana) to High(Mediana) do
      begin
        for y := (x +1) to High(Mediana) do
        begin
          if Mediana[x] > Mediana[y] then
          begin
            Aux := Mediana[y];
            Mediana[y] := Mediana[x];
            Mediana[x] := Aux;
          end;
        end;
      end;

      // Gravando o valor na imagem resultante
      Imagem.Dados[i][j] := Mediana[4];
    end;
  end;
  Result := Imagem;
end;

// Função que Aplica o Gato de Arnold
function AplicarArnold(Imagem1: ImagemPGM): ImagemPGM;
var
  i, j, x, y: integer;
  Imagem: ImagemPGM;
begin
  // Criando uma imagem vazia
  Imagem := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

  // Aplicando da matriz de Arnold
  for i := 0 to (Imagem1.Largura -1) do
    for j := 0 to (Imagem1.Altura -1) do
    begin
      x := (i + j) mod Imagem1.Largura;
      y := (i + (2 * j)) mod Imagem1.Altura;
      Imagem.Dados[x][y] := Imagem1.Dados[i][j];
    end;
  Result := Imagem;
end;

// Função que Equaliza o Histograma de uma imagem
function AplicarEqHistograma(Imagem1: ImagemPGM): ImagemPGM;
var
  i, j, Pixels, Cor: integer;
  ImagemPGM2: ImagemPGM;
  Histograma, S: TIntegerDynArray;
  Somatorio: real;
begin
  // Criando uma imagem vazia
  ImagemPGM2 := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

  // Obtendo o Histograma da imagem
  Histograma := GerarHistograma(Imagem1);

  // Definindo o tamanho do vetor de probabilidades
  SetLength(S, High(Histograma));

  // Configurando os dados utilizados no algorítmo
  Pixels := Imagem1.Largura * Imagem1.Altura;
  Somatorio := 0;

  // Fazendo o mapeamento de probabilidades
  for i := 0 to High(Histograma) do
  begin
    Somatorio := Somatorio + (Histograma[i] / Pixels);
    S[i] := Round(Somatorio * High(Histograma));
  end;

  // Aplicando a equialização de histograma na imagem
  for i := 0 to (Imagem1.Largura -1) do
  begin
    for j := 0 to (Imagem1.Altura -1) do
    begin
      // Fazendo o mapeamento Sx -> y
      Cor := Imagem1.Dados[i, j] ;
      ImagemPGM2.Dados[i, j] := S[Cor];
    end;
  end;
  
  Result := ImagemPGM2;
end;

// Função que aplica o filtro da Pseudocor na Imagem
function AplicarPseudocor(ImagemPGM1: ImagemPGM; CinzaMax: integer): ImagemPGM;
var
  ImagemPGM2: ImagemPGM;
  Paleta: TIntegerDynArray;
  i, j, Cor: integer;
begin
  // Definindo o tamanho da paleta
  SetLength(Paleta, (CinzaMax + 1));

  // Criando uma imagem vazia
  ImagemPGM2 := CriarImagem(ImagemPGM1.Largura, ImagemPGM1.Altura, ImagemPGM1.CinzaMax);
  ImagemPGM2.Colorida := true;

  // Carregando as cores utilizadas pela paleta
  for i := 0 to CinzaMax do
  begin
    Paleta[i] := Round((i * 16777215) / CinzaMax);
  end;

  // Aplicando a pseudocor
  for i := 0 to (ImagemPGM1.Largura -1) do
  begin
    for j := 0 to (ImagemPGM1.Altura -1) do
    begin
      Cor := ObterCor(ImagemPGM1.Dados[i, j], CinzaMax);
      ImagemPGM2.Red[i, j]   := GetRValue(Cor);
      ImagemPGM2.Green[i, j] := GetGValue(Cor);
      ImagemPGM2.Blue[i, j]  := GetBValue(Cor);
    end;
  end;
  Result := ImagemPGM2;
end;

function ObterCor(CorCinza, CinzaMax: integer): integer;
var
  Red, Green, Blue, Cor, Nivel: integer;
begin
  // Inicializando as matrizes de cores
  Red   := 0;
  Green := 0;
  Blue  := 0;

  // Calculando o nível de cor aplicado
  Cor := Round((1279 * CorCinza) / CinzaMax);

  // Verde -> Azul Piscina
  Nivel := 256 * 4;
  if (Cor > Nivel) then
  begin
    Green := 255;
    Blue  := Cor - Nivel;
  end
  else
  begin
    // Amarelo -> Verde
    Nivel := Nivel - 256;
    if (Cor > Nivel) then
    begin
      Red   := Cor - Nivel;
      Green := 255;
    end
    else
    begin
      // Vermelho -> Amarelo
      Nivel := Nivel - 256;
      if (Cor > Nivel) then
      begin
        Red   := 255;
        Green := Cor - Nivel;
      end
      else
      begin
        // Rosa -> Vermelho
        Nivel := Nivel - 256;
        if (Cor > Nivel) then
        begin
          Red   := 255;
          Blue  := Cor - Nivel;
        end
        else
        begin
          // Azul -> Rosa
          Red  := Cor - Nivel;
          Blue := 255;
        end;
      end;
    end;
  end;
  Result := RGB(Red, Green, Blue);
end;

// Função que Soma duas imagens resultando em uma terceira
function SomarImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
var
  i, j: integer;
  Imagem: ImagemPGM;
begin
  if (Imagem1.Largura = Imagem2.Largura) and (Imagem1.Altura = Imagem2.Altura) then
  begin
    // Criando uma imagem vazia
    Imagem := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

    // Realizando a computação entre as duas imagens
    for i := 0 to (Imagem1.Largura -1) do
      for j := 0 to (Imagem1.Altura -1) do
        Imagem.Dados[i][j] := Imagem1.Dados[i][j] + Imagem2.Dados[i][j];
  end;
  Result := Imagem;
end;

// Função que Subtrai duas imagens resultando em uma terceira
function SubtrairImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
var
  i, j: integer;
  Imagem: ImagemPGM;
begin
  if (Imagem1.Largura = Imagem2.Largura) and (Imagem1.Altura = Imagem2.Altura) then
  begin
    // Criando uma imagem vazia
    Imagem := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

    // Realizando a computação entre as duas imagens
    for i := 0 to (Imagem1.Largura -1) do
      for j := 0 to (Imagem1.Altura -1) do
        Imagem.Dados[i][j] := Imagem1.Dados[i][j] - Imagem2.Dados[i][j];
  end;
  Result := Imagem;
end;

// Função que Divide duas imagens e resulta em uma terceira
function DividirImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
var
  i, j: integer;
  Imagem: ImagemPGM;
begin
  if (Imagem1.Largura = Imagem2.Largura) and (Imagem1.Altura = Imagem2.Altura) then
  begin
    // Criando uma imagem vazia
    Imagem := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

    // Realizando a computação entre as duas imagens
    for i := 0 to (Imagem1.Largura -1) do
      for j := 0 to (Imagem1.Altura -1) do
      begin
        if (Imagem2.Dados[i][j] = 0) then Imagem.Dados[i][j] := Imagem.CinzaMax
        else Imagem.Dados[i][j] := Round(Imagem1.Dados[i][j] / Imagem2.Dados[i][j]);
      end;
  end;
  Result := Imagem;
end;

// Função que Multiplica duas imagens resultando em uma terceira
function MultiplicarImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
var
  i, j: integer;
  Imagem: ImagemPGM;
begin
  if (Imagem1.Largura = Imagem2.Largura) and (Imagem1.Altura = Imagem2.Altura) then
  begin
    // Criando uma imagem vazia
    Imagem := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

    // Realizando a computação entre as duas imagens
    for i := 0 to (Imagem1.Largura -1) do
      for j := 0 to (Imagem1.Altura -1) do
        Imagem.Dados[i][j] := Imagem1.Dados[i][j] * Imagem2.Dados[i][j];
  end;
  Result := Imagem;
end;

// Função que Aplica o Operador AND em duas imagens resultando em uma terceira
function ANDImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
var
  i, j: integer;
  Imagem: ImagemPGM;
begin
  if (Imagem1.Largura = Imagem2.Largura) and (Imagem1.Altura = Imagem2.Altura) then
  begin
    // Criando uma imagem vazia
    Imagem := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

    // Realizando a computação entre as duas imagens
    for i := 0 to (Imagem1.Largura -1) do
      for j := 0 to (Imagem1.Altura -1) do
        Imagem.Dados[i][j] := Imagem1.Dados[i][j] and Imagem2.Dados[i][j];
  end;
  Result := Imagem;
end;

// Função que Aplica o Operador OR em duas imagens resultando em uma terceira
function ORImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
var
  i, j: integer;
  Imagem: ImagemPGM;
begin
  if (Imagem1.Largura = Imagem2.Largura) and (Imagem1.Altura = Imagem2.Altura) then
  begin
    // Criando uma imagem vazia
    Imagem := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

    // Realizando a computação entre as duas imagens
    for i := 0 to (Imagem1.Largura -1) do
      for j := 0 to (Imagem1.Altura -1) do
        Imagem.Dados[i][j] := Imagem1.Dados[i][j] or Imagem2.Dados[i][j];
  end;
  Result := Imagem;
end;


// Função que Aplica o Operador OR em duas imagens resultando em uma terceira
function XORImagens(Imagem1, Imagem2: ImagemPGM): ImagemPGM;
var
  i, j: integer;
  Imagem: ImagemPGM;
begin
  if (Imagem1.Largura = Imagem2.Largura) and (Imagem1.Altura = Imagem2.Altura) then
  begin
    // Criando uma imagem vazia
    Imagem := CriarImagem(Imagem1.Largura, Imagem1.Altura, Imagem1.CinzaMax);

    // Realizando a computação entre as duas imagens
    for i := 0 to (Imagem1.Largura -1) do
      for j := 0 to (Imagem1.Altura -1) do
        Imagem.Dados[i][j] := Imagem1.Dados[i][j] xor Imagem2.Dados[i][j];
  end;
  Result := Imagem;
end;

// Função que Gera os dados do Histograma
function GerarHistograma(Imagem1: ImagemPGM): TIntegerDynArray;
var
  i, j, Cor: integer;
  Histograma: TIntegerDynArray;
begin
  SetLength(Histograma, Imagem1.CinzaMax);

  for i := 0 to (Imagem1.Largura -1) do
    for j := 0 to (Imagem1.Altura -1) do
    begin
      Cor := Imagem1.Dados[i][j];
      Inc(Histograma[Cor]);
    end;
  
  Result := Histograma;
end;

// Procedimento que Desenha o Histograma na área desejada 
procedure DesenharHistograma(Imagem: TImage; Dados: TIntegerDynArray);
var
  i, x, Cor, Max: integer;
begin
  // Obtendo o maior valor do Histograma
  Max := 0;
  for i := 0 to High(Dados) do
  begin
    if (Dados[i] > Max) then
      Max := Dados[i];
  end;

  // Limpando o Histograma atual
  Cor := RGB(255, 255, 255);
  Imagem.Canvas.Brush.Color := Cor;
  Imagem.Canvas.Pen.Style := psSolid;
  Imagem.Canvas.Pen.Color := Cor;
  Imagem.Canvas.Rectangle(0, 0, Imagem.Width, Imagem.Height);

  // Definindo a cor do Histograma
  Cor := RGB(80, 80, 80);
  Imagem.Canvas.Brush.Color := Cor;
  Imagem.Canvas.Pen.Style := psSolid;
  Imagem.Canvas.Pen.Color := Cor;

  // Plotando o Histograma
  for i := 0 to High(Dados) do
  begin
    x := Imagem.Height - Round((Dados[i] * (Imagem.Height - 5)) / Max);
    Imagem.Canvas.Rectangle(i, x, (i+1), Imagem.Height);
  end;
end;

end.
