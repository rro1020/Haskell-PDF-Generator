{-
Ramon Roel Orduno & Adam Pitones
Assignment 13: Printing PDF's version of Code File

Sources: 
http://www.simpopdf.com/resource/pdf-file-structure.html 
http://blog.idrsolutions.com/?s=%22Make+your+own+PDF+file%22
http://www.gnupdf.org/Introduction_to_PDF

Dr. Dos Reis, for providing a good starting point on this project 
-}

import System.Environment (getArgs)

-- Data Name name = String fileName | String fileType 

-- Header for PDF file --
addHeader :: String -> String
addHeader s = "%PDF-1.4\n" ++ (getObj s)

-- Root object is stored with Catalog (Root is in Trailer section) --
getObj :: String -> String 
getObj s = "1 0 obj <</Type /Catalog /Pages 2 0 R>>\n" ++ "endobj\n" ++ (addObj s) 

-- Another Object -- 
addObj :: String -> String 
addObj s = "2 0 obj <</Type /Pages /Kids[3 0 R] /Count 1>>\n" ++ "endobj\n" ++ (resourceKey s)

-- Resource is what goes on the page: fonts, graphics, shading, etc -- 
-- If empty, nothing will be printed --
resourceKey :: String -> String 
resourceKey s = "3 0 obj <</Type /Page /Parent 2 0 R /Resources 4 0 R" ++ (mediaBox s)

-- MediaBox is what PDF viewer needs to work -- 
mediaBox :: String -> String 
mediaBox s = "/MediaBox [0 0 500 800] /Contents 6 0 R>>\n" ++ "endobj\n" ++ (fontAndText s) -- ++ "TEST!!! " ++ (test 40 s)

{-
	BT = Begin Text 		ET = End Text 
	Tf, Td, Tj are instructions 
	Needs a font (/F1) and size: font size (24) 
	Td sets position 
	Character in brackets get drawn on PDF document 
	/F1 need to be in /Resources dictionary to be used 
-}

test num s 
		| num > (length s) = "worked!\n" 
		| otherwise = "didn't!\n" 

test2 [] = "" 		
test2 ('\n':xs) = ")'(" ++ test2 xs 
test2 (x:xs) = [x] ++ test2 xs 
		
fontAndText :: String -> String 
fontAndText s = "4 0 obj<</Font <</F1 5 0 R>>>>\n" ++ "endobj\n" ++ 
				"5 0 obj<</Type /Font /Subtype /Type1 /BaseFont /Arial>>\n" ++ "endobj\n" ++ 
				"6 0 obj<</Length 40>>\n" ++ "stream\n" ++ 
				"BT /F1 16 Tf 1 0 0 1 25 700 Tm 24 TL\n" ++ 
				"(" ++ (test2 s) ++ ")" ++ "\n ET\n" ++ 
				-- "BT /F1 24 Tf 175 720 Td (Howdy!) Tj ET\n" ++ <- Original Test Code
				"endstream\n" ++ "endobj\n" ++ (crossRefTable s)

-- Stores object addresses 				
crossRefTable :: String -> String 
crossRefTable s = "xref\n" ++ "0 7\n" ++ 
				  "0000000000 65535 f\n" ++ 
				  "0000000009 00000 n\n" ++ 
				  "0000000056 00000 n\n" ++ 
				  "0000000111 00000 n\n" ++ 
				  "0000000212 00000 n\n" ++ 
				  "0000000250 00000 n\n" ++ 
				  "0000000317 00000 n\n" ++
				  (trailer s)
				  
-- Obviously Size depends on number of obj in document -- 				  
trailer :: String -> String 
trailer s = "trailer <</Size 7/Root 1 0 R>>\n" ++ 
-- Calling endOfFile at the end of the file :P 
			"startxref\n" ++ "406\n" ++ (endOfFile s)

-- End of File for PDF -- 
endOfFile :: String -> String
-- endOfFile s = s ++ "\n%%EOF" 
endOfFile s = "\n%%EOF" 
	

outputFile2 :: FilePath -> String 
outputFile2 a = drop 1 (takeWhile(/='.')( show a)) ++ ".pdf"
 	
transform :: (String -> String) -> FilePath -> IO() 
transform function inputFile = do 
	input <- readFile inputFile
	print(outputFile2 inputFile)
	writeFile  (outputFile2 inputFile) (function (addHeader input))         
	
main = mainWith myFunction 
	where mainWith function = do 
		args <- getArgs		
		case args of 
			[input] -> transform function  input  
			_ -> error "exactly two arguments are needed" 
				
myFunction = id

	


