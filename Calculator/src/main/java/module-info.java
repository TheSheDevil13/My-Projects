module com.cs.oop.techgiant.calculator {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.cs.oop.techgiant.calculator to javafx.fxml;
    exports com.cs.oop.techgiant.calculator;
}