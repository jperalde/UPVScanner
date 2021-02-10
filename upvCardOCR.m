
function [ocrI, results] = upvCardOCR(I, roi)
% Location of trained OCR language data
trainedLanguage = 'upvCardlang\tessdata\upvCardlang.traineddata';

% Run OCR using trained language. You may need to modify OCR parameters or
% pre-process your test images for optimal results. Also, consider
% specifying an ROI input to OCR in case your images have a lot of non-text
% background.
layout = 'Block';
if nargin == 2
    results = ocr(I, roi, ...
        'Language', trainedLanguage, ...
        'TextLayout', layout);
else
    results = ocr(I, ...
        'Language', trainedLanguage, ...
        'TextLayout', layout);
end

ocrI = insertOCRAnnotation(I, results);

%--------------------------------------------------------------------------
% Annotate I with OCR results.
%--------------------------------------------------------------------------
function J = insertOCRAnnotation(I, results)
text = results.Text;

I = im2uint8(I);
if isempty(deblank(text))
    % Text not recognized.
    text = 'Unable to recognize any text.';
    [M,N,~] = size(I);
    J = insertText(I, [N/2 M/2], text, ...
        'AnchorPoint', 'Center', 'FontSize', 24, 'Font', 'Arial');
    
else
    location = results.CharacterBoundingBoxes;
    
    % Remove new lines from results.
    newlines = text == char(10);
    text(newlines) = [];
    location(newlines, :) = [];
    
    % Remove spaces from results
    spaces = isspace(text);
    text(spaces) = [];
    location(spaces, :) = [];
    
    % Convert text array into cell array of strings.
    text = num2cell(text);
    
    % Pad the image to help annotate results close to the image border.
    I = padarray(I, [50 50], uint8(255));
    location(:,1:2) = location(:,1:2) + 50;
    
    % Insert text annotations.
    J  = insertObjectAnnotation(I, 'rectangle', location, text);
end