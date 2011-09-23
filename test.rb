require 'search'
w = WordTree.new
#w.load_words('words')
#w.init_tree
w.load_tree
s = Search.new(w)
s.locate_words('expertsexchange')
s.locate_words('expertbsexchange')
