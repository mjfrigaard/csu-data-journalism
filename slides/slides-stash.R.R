#=====================================================================#
# File name: slides-stash.R
# This is code to create: misc
# Authored by and feedback to: mjfrigaard
# Last updated: 2021-11-24
# MIT License
# Version: NA
#=====================================================================#


# packages ----------------------------------------------------------------
library(tidyverse)
library(Lahman)
library(reprex)
library(xaringan)
library(pagedown)
library(xaringanthemer)
library(vcdExtra)
library(ggrepel)
library(ggbeeswarm)
library(ggwaffle)
library(palmerpenguins)
library(fivethirtyeight)
library(ggmosaic)
library(treemapify)
library(ggdendro)

source("../code/batch_rename_files.R")
# fs::dir_ls("img")
# batch_rename_files(path = "img", pattern = "00-", replace = "01-", 
#                    prefix = TRUE, extension = "png")



# images for slides 2 ---------------------------------------------------
copy_slide_images <- function(slide_img) {
    # parent image folder
parent_img_folder <- "/Users/mjfrigaard/Dropbox/@projects/high-priority/@data-journalism/course-website/csuc-data-journalism/img/"
# slides image folder
slides_img_folder <- "/Users/mjfrigaard/Dropbox/@projects/high-priority/@data-journalism/course-website/csuc-data-journalism/slides/img/"
# slide_image_regex
slide_image_regex <- paste0("^", slide_img, "$")
# info
image_folder_info <- fs::dir_info(parent_img_folder)
# cols
image_folder_info <- dplyr::select(image_folder_info, img_path = path)
# file_name
image_folder_info <- dplyr::mutate(image_folder_info, 
                                file_name = basename(img_path))
# cols
image_folder_info <- dplyr::select(image_folder_info, img_path, 
                                   file_name)

# slide_img_path
image_folder_info <- dplyr::mutate(image_folder_info, 
                        slide_img_path = paste0(slides_img_folder, slide_img))

# image_info
image_info <- dplyr::filter(image_folder_info, 
       stringr::str_detect(string = file_name, slide_image_regex))

image_paths <- dplyr::select(image_info, 
                                img_path, slide_img_path)

from_image <- as.character(image_paths$img_path)

to_image <- as.character(image_paths$slide_img_path)

fs::file_copy(from_image, to_image, overwrite = TRUE)
    
}


copy_slide_images(slide_img = "settings.png")
# setting-options.png
copy_slide_images(slide_img = "setting-options.png")

copy_slide_images(slide_img = "code-settings.png")

copy_slide_images("code-display.png")

copy_slide_images("code-savings.png")

copy_slide_images("code-completion.png")
