class Search
  def extract_words(phrase)
    node = @word_tree
    words = []
    word = ''
    phrase.each_char.with_index do |c, i|
      node = node[c.to_sym]
      word = word + c
      if node.nil?
        p = phrase[word.size-1..-1]
        if p.size > 2
          w = extract_words(phrase[word.size-1..-1])
          words = words | w
          puts words
        end
        break
      elsif node[:word]
        words << phrase[0..i] 
      end
    end
    words
  end
  
  def locate_words(phrase, words = [], word_list = [])
    if phrase.empty?
      word_list << words
    else
        extract_words(phrase).each do |word|
          remainder = phrase[word.size..-1]
          locate_words(remainder, words + [word], word_list)
        end
    end
    word_list
  end
  
  def initialize(word_Tree)
    @word_tree = word_Tree.word_tree
  end
end


class WordTree
  attr_accessor :word_tree
 
  def dump_tree(file="tree.dat")
    File.open(file,"wb") do |file|
      Marshal.dump(@word_tree,file)
    end
  end
  
  def load_tree(file="tree.dat")
    @word_tree = nil
    File.open(file,"rb") {|f| @word_tree = Marshal.load(f)}
  end
  
  def add_word_to_tree(tree, word)
    first_letter = word[0..0].to_sym
    remainder = word[1..-1]
    tree[first_letter] ||= {}
    if remainder.empty?
      tree[first_letter][:word] = true
    else
      add_word_to_tree(tree[first_letter], remainder)
    end
  end
  
  def load_words(file="words.txt")
    @WORD_LIST = nil
    @WORD_LIST = File.open(file).collect
  end
  
  def make_word_tree
    root = {}
    @WORD_LIST.each do |word|
      add_word_to_tree(root, word.strip)
    end
    root
  end

  def init_tree
    @word_tree ||= make_word_tree
  end
end
