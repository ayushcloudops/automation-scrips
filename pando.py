from pyexcel.cookbook import merge_all_to_a_book
import glob
merge_all_to_a_book(glob.glob("*.csv"), "output.xlsx")
