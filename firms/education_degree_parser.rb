class EducationDegreeParser
  LAW_DEGREES = ["J.D.", "JD", "Juris Doctor", "LLM", "LL.M.", "LL.B.", "LL.M", "LL.B"]
  DEGREES = [
    "AB", "A.B.", "AM", "AS",
    "BA", "B.A.", "Bachelor of Commerce", "Bachelor of Technology", "BBA", "B.B.A.",
    "BAS", "BBA", "BChE", "BCL", "BCom", "B.Com", "BE", "BFA", "BM", "BME", "BPP", "BS",
    "B.S.", "B.Sc.", "BSE", "BSFS", "BSME", "B.V.C",
    "DEA", "D.E.S.S. European Law", "DIEI", "Diploma in Law", "Dr. iur.",
    "First State Exam in Law", "JCL",
    "Law Degree", "Legal Practice Course", "LLM", "LL.M.", "LLB", "LL.B.", "LPC", "L.P.C.",
    "MA", "M.A.", "Master", "MBA", "MPA", "MPH", "MS", "M.S.",
    "PGDip", "PG Diploma", "PhD" , "Postgraduate Diploma in European Law", "Post-diploma studies on Competition Law", "SB"
  ]

  ALL_DEGREES = (LAW_DEGREES + DEGREES).uniq

  def self.parse(education)
    education = ' ' + education + ','
    rlt = nil

    LAW_DEGREES.each do |degree_item|
      reg = Regexp.new("[(\\s\\/]#{degree_item}[,\\s\\/)\\;]")
      if education =~ reg
        rlt = degree_item
        break
      end
    end

    if rlt.nil?
      DEGREES.each do |degree_item|
        reg = Regexp.new("[(\\s\\/]#{degree_item}[,\\s\\/)\\;]")
        if education =~ reg
          rlt = degree_item
          break
        end
      end
    end

    rlt
  end
end
