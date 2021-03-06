
include Atlassian::Util::TextUtil

class TextUtilTest < Minitest::Test

  context "to_sentence_case" do
    should "work with an empty string" do
      assert_equal "", to_sentence_case("")
    end

    should "work with a single letter" do
      assert_equal "A", to_sentence_case("a")
    end

    should "work with a single number" do
      assert_equal "1", to_sentence_case("1")
    end
    
    should "work with multichar" do
      assert_equal "Abc def", to_sentence_case("abc def")
    end
    
    should "coerce boolean false" do
      assert_equal "False", to_sentence_case(false)
    end
    
    should "coerce boolean true" do
      assert_equal "True", to_sentence_case(true)
    end
    
    should "coerce nil" do
      assert_equal "", to_sentence_case(nil)
    end
    
    should "coerce 0" do
      assert_equal "0", to_sentence_case(0)
    end
    
    should "coerce 1" do
      assert_equal "1", to_sentence_case(1)
    end
  end

  context "convert_branch_name_to_sentence" do

    should "work with branch name with leading issue key" do
      assert_equal "STASHDEV-1234 branch name", convert_branch_name_to_sentence("STASHDEV-1234-branch-name")
    end

    should "work with branch name with trailing issue key" do
      assert_equal "Branch name STASHDEV-1234", convert_branch_name_to_sentence("branch-name-STASHDEV-1234")
    end

    should "work with branch name with issue key in middle" do
      assert_equal "Branch STASHDEV-1234 name", convert_branch_name_to_sentence("branch-STASHDEV-1234-name")
    end

    should "work with branch name with multiple adjacent issue keys" do
      assert_equal "Branch name STASHDEV-1234 STASHDEV-1234", convert_branch_name_to_sentence("branch-name-STASHDEV-1234-STASHDEV-1234")
    end

    should "work with branch name with no issue keys" do
      assert_equal "Tests branch name", convert_branch_name_to_sentence("tests-branch-name")
    end

    should "work with branch name with underscore delimiter" do
      assert_equal "Tests branch name", convert_branch_name_to_sentence("tests_branch_name")
    end

    should "work with branch name with mixed delimiter" do
      assert_equal "Tests branch name", convert_branch_name_to_sentence("tests-branch_name")
    end

    should "work with single word branch name" do
      assert_equal "Branchname", convert_branch_name_to_sentence("branchname")
    end

    should "work with slash delimited branch name" do
      assert_equal "Feature/tests/STASHDEV-1234 branch name", convert_branch_name_to_sentence("feature/tests/STASHDEV-1234-branch-name")
    end

    should "work with slash delimited branch name with issue key component" do
      assert_equal "Feature/STASHDEV-1234/branch name", convert_branch_name_to_sentence("feature/STASHDEV-1234/branch-name")
    end

    should "work with branch name with invalid issue key (punctuation)" do
      assert_equal "STASHDEV! 1234 branch name", convert_branch_name_to_sentence("STASHDEV!-1234-branch-name")
    end

    should "work with branch name with invalid issue key (lowercase)" do
      assert_equal "Stashdev 1234 branch name", convert_branch_name_to_sentence("stashdev-1234-branch-name")
    end

    should "work with branch name with invalid issue key (numbers in project key)" do
      assert_equal "STASHDEV1 1234 branch name", convert_branch_name_to_sentence("STASHDEV1-1234-branch-name")
    end

    should "work with empty branch name" do
      assert_equal "", convert_branch_name_to_sentence("")
    end
  end

end