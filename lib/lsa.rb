require 'svd_matrix'

class LSA
  attr_accessor :u, :s, :v

  def initialize(matrix)
    @u, @s, @v = matrix.decompose(2)
  end
  
  def inspect
    "U:\n#{@u.inspect}\n\nS:\n#{@s.inspect}\n\nV:\n#{@v.inspect}"
  end
  
  # Return a distance (cosine similarity) between a new vector,
  # and all the clusters (columns) used in the original matrix.
  # Returns a sorted list of indexes and distances,
  def classify_vector(values)
    puts "LSA\tClassifying vector #{values}"

    raise "Unsupported vector length" unless values.size == @u.row_size || values.size == @v.row_size
    vector = Matrix.row_vector(values)
    mult_matrix = (values.size == @u.row_size ? @u : @v)
    comp_matrix = (values.size == @u.row_size ? @v : @u)
    
    position = vector * mult_matrix * @s.inverse
    x = position[0,0]
    y = position[0,1]
    results = []
    
    puts "LSA\tDetermining Similarities#{values}"
    comp_matrix.row_size.times do |index|
      results << [index, cosine_similarity(x, y, comp_matrix[index, 0], comp_matrix[index, 1])]
    end
    
    results.sort {|a, b| b[1] <=> a[1]}
  end
  
  # Determines the cosine similarity between two 2D points
  def cosine_similarity(x1, y1, x2, y2)
    dp = (x1 * x2) + (y1 * y2)
    mag1 = Math.sqrt((x1 ** 2) + (y1 ** 2))
    mag2 = Math.sqrt((x2 ** 2) + (y2 ** 2))
    return 0 if mag1 == 0 || mag2 == 0
    return (dp / (mag1 * mag2))
  end
end
