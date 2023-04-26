from argparse import ArgumentParser
import re
import glob
import os

if __name__ == "__main__":
    parser = ArgumentParser(description="GrepU[nion]: This utilty will take a list of search patterns to search through and return a list of files if any that contain instances of all search terms")
    parser.add_argument("search_list", metavar="SEARCH_PATTERN", nargs='+', help="a list of search patterns to look for")
    parser.add_argument("--search-path", "-p",  nargs=1, default="./", help="the root path to start searching recursively")
    parser.add_argument("--file-types", default=[".txt", ".py", ".cpp", ".c", ".hpp", ".h"], help="list of file types")
    parser.add_argument("--dont-include-name", action="store_true", default=False, help="if the name of the file should be considered in the search")
    args = parser.parse_args()
    file_list = [f for f in glob.glob(f"{args.search_path[0]}/**/*", recursive=True) if (os.path.isfile(f) and os.path.splitext(f)[1] in args.file_types)]
    for i, search_pattern in enumerate(args.search_list):
        # print(f"iteration {i}")
        # print(f"file list length {len(file_list)}")
        if len(file_list) == 0:
            print("no files with union found")
            break
        else:
            new_list = []
            for file_name in file_list:
                with open(file_name) as f_handle:
                    try:
                        all_text = f_handle.read()
                    except Exception as e:
                        # assuming not a readable file
                        # print(e)
                        # print(f"skipping {file_name}")
                        pass
                    else:
                        matches_in_text = re.search(search_pattern, all_text)
                        if not args.dont_include_name:
                            matches_in_filename = re.search(search_pattern, file_name)
                        else:
                            matches_in_filename = None
                        if matches_in_text is not None or matches_in_filename is not None:
                            new_list.append(file_name)
            file_list = new_list
    if len(file_list) > 0:
        for filename in file_list:
            print(filename)

    sys.exit(0)
