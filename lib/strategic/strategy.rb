# Copyright (c) 2020-2021 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module Strategic
  module Strategy
    def self.included(klass)
      klass.extend(ClassMethods)
    end
  
    module ClassMethods
      def strategy_alias(alias_string_or_class_or_object)
        strategy_aliases << alias_string_or_class_or_object
      end
      
      def strategy_aliases
        @strategy_aliases ||= []
      end
    
      def strategy_exclusion(exclusion_string_or_class_or_object)
        strategy_exclusions << exclusion_string_or_class_or_object
      end
      
      def strategy_exclusions
        @strategy_exclusions ||= []
      end
      
      def strategy_matcher(&matcher_block)
        if block_given?
          @strategy_matcher = matcher_block
        else
          @strategy_matcher
        end
      end
      
      def strategy_name
        Strategic.underscore(name.split(':').last).sub(/_strategy$/, '')
      end
    end
    
    attr_reader :context
    
    def initialize(context)
      @context = context
    end
    
  end
end
