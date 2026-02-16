# paper-steganography-Imm-cover
Code for paper "Universal Immunized Cover Construction for Secure Adaptive Steganography across Multiple Domains"
Abstract: Constructing the cover image with strong resistance to embedding distortion across multiple domains holds great promise for secure adaptive steganography. Nevertheless, existing CNN-based cover enhancement schemes, while effective against their target steganalyzers, struggle to resist detection beyond their target steganalyzer. Moreover, existing immune-based cover enhancement schemes focus solely on optimizing the spatial characteristics of the original cover. However, covers that can only resist spatial embedding distortion are insufficient to ensure security for steganography in other domains. In this paper, we propose a universal immunized (Uimm) cover construction scheme based on artificial immune evolution to enhance steganographic security, which is universal across multiple domains. Inspired by the similarity between steganography and immune response, we treat the original cover as the organism, the embedding distortion as the pathogen, and the universal immunoprocessing (UIP) applied to the original cover as the antibody. Moreover, the filter banks are meticulously designed to adaptively limit the universal immunoprocessing region (UIPR) and intensity of UIP, thereby fully considering the texture characteristics of the cover in the spatial domain. Under the constraints of the UIPR and UIP intensity, antibodies are guided to evolve towards improving the JPEG steganography security, yielding the optimal universal immunoprocessing policy. By considering intrinsic characteristics in both the spatial and JPEG domains, optimal universal immunoprocessing performed on the original cover will enhance its resistance to embedding distortion across multiple domains. Experimental results demonstrate that the proposed Uimm cover significantly improves the holistic security of adaptive steganography in both spatial and JPEG domains, effectively resisting handcrafted and CNN-based steganalysis. It also achieves superior performance compared to related schemes.


Please set the code root directory as the MATLAB current working directory; all relative paths are based on this.

Environment Requirements and Dependencies: MATLAB R2018b or higher

Data preparation: Please download the BOSSBase v1.01 dataset (256×256 grayscale images) and place all `.pgm` files in the folder 'BOSSBase_cover_256'. Download links:  
BOSSBase v1.01: https://dde.binghamton.edu/download/  
BOWS2: https://bows2.ec-lille.fr

External dependencies: STC embedding, Embedding Simulator, steganalysis feature extraction (SRM, GFR, DCTR), and JPEG Toolbox are included in the code package.

Configuration file: `config.m` contains the parameters: scaling factor (gamma), tolerance factor (delta), Population Scale (NP), Immunoselection rate (Isr), Mutation factor (e), Maximum evolution times (G), Clone factor (ncl), Quality Factor (QualityFactor). The random seed is fixed in `config.m` (rng(0)) to ensure consistent results with each run.

The steps for spatial steganography and JPEG steganography are as follows:

1. Spatial:
1: Run `generateUimmcover_spatial.m` to generate Uimm cover. Input original image path: `'BOSSBase_cover_256'`, output Uimm cover to: 'Uimmcover'.  
1.2: Run `Embedding_Spatial.m` or `Embedding_Spatial_STC.m` to perform secret message embedding based on Embedding Simulator or STC. Input original image path: 'Uimmcover', output Uimm stego to: 'stego' or 'stego_stc'.  
1.3: Run `saveCoverFeature.m` to extract steganalysis features from Uimm cover images. Input image path: 'Uimmcover', output cover features to: 'Steganalysis_Feature/cover.mat'.  
1.4: Run `saveStegoFeature.m` to extract steganalysis features from Uimm stego images. Input image path: 'stego' or 'stego_stc', output stego features to: 'Steganalysis_Feature/stego.mat'.  
1.5: Run `steganalysis.m` to perform steganalysis and output the steganalysis error rate. Input cover and stego feature paths: 'Steganalysis_Feature/cover.mat', 'Steganalysis_Feature/stego.mat'.

2. JPEG: 
2.1: Run `generateUimmcover_jpeg.m` to generate Uimm cover. Input original image path: 'BOSSBase_cover_256', output Uimm cover to: `'Uimmcover_qf75'`.  
2.2: Run `Embedding_JPEG.m` or `Embedding_JPEG_STC.m` to perform secret message embedding based on Embedding Simulator or STC. Input original image path: 'Uimmcover_qf75', output Uimm stego to: 'stego' or 'stego_stc'.  
2.3: Run `saveCoverFeature.m` to extract steganalysis features from Uimm cover images. Input image path: 'Uimmcover_qf75', output cover features to: 'Steganalysis_Feature/cover.mat'.  
2.4: Run `saveStegoFeature.m` to extract steganalysis features from Uimm stego images. Input image path: 'stego' or 'stego_stc', output stego features to: 'Steganalysis_Feature/stego.mat'.  
2.5: Run `steganalysis.m` to perform steganalysis and output the steganalysis error rate. Input cover and stego feature paths: 'Steganalysis_Feature/cover.mat', 'Steganalysis_Feature/stego.mat'.
