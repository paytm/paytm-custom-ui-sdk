package com.paytm.merchantsampleapp;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;

public class CheckboxCustomisation extends AppCompatActivity {
    private RadioButton rb_textcolor,rb_textsize,rb_bgcolor,rb_ccolor,rb_uccolor,rb_font;
    private Button button;
    private RadioGroup rg_textcolor,rg_textsize,rg_bgcolor,rg_ccolor,rg_uccolor,rg_font;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_checkbox_customisation);
        rg_textcolor = findViewById(R.id.rg_textColor);
        rg_textsize = findViewById(R.id.rg_textSize);
        rg_font = findViewById(R.id.rg_textFont);
        rg_bgcolor = findViewById(R.id.rg_backgroundColor);
        rg_ccolor = findViewById(R.id.rg_checkedColor);
        rg_uccolor = findViewById(R.id.rg_uncheckedColor);
        button = findViewById(R.id.proceed_instrumentsPage);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent2= new Intent(CheckboxCustomisation.this,InstrumentActivity.class);
                int selectedId1 = rg_textcolor.getCheckedRadioButtonId();
                rb_textcolor = (RadioButton) findViewById(selectedId1);
                if(selectedId1!=-1){
                    String t_color =  rb_textcolor.getText().toString();
                    switch (t_color) {
                        case "Red":
                            intent2.putExtra("text_color", getResources().getColor(R.color.error_color));
                            break;
                        case "Blue":
                            intent2.putExtra("text_color", getResources().getColor(R.color.deep_sky_blue));
                            break;
                        case "Yellow":
                            intent2.putExtra("text_color", getResources().getColor(R.color.yellow));
                            break;
                    }
                }
                int selectedId2 = rg_textsize.getCheckedRadioButtonId();
                rb_textsize = (RadioButton) findViewById(selectedId2);
                if(selectedId2!=-1) {
                    String t_size = rb_textsize.getText().toString();
                    switch (t_size) {
                        case "10sp":
                            intent2.putExtra("text_size", getResources().getDimension(R.dimen.dimen_10sp));
                            break;
                        case "15sp":
                            intent2.putExtra("text_size", getResources().getDimension(R.dimen.dimen_15sp));
                            break;
                        case "21sp":
                            intent2.putExtra("text_size", getResources().getDimension(R.dimen.dimen_21sp));
                            break;
                    }
                }
                int selectedId3 = rg_font.getCheckedRadioButtonId();
                rb_font = (RadioButton) findViewById(selectedId3);
                if(selectedId3!=-1) {
                    String t_font = rb_font.getText().toString();
                    switch (t_font) {
                        case "Monospace":
                            intent2.putExtra("font", 1);
                            break;
                        case "Sans-serif":
                            intent2.putExtra("font", 2);
                            break;
                        case "Serif":
                            intent2.putExtra("font", 3);
                            break;
                    }
                }
                int selectedId4 = rg_bgcolor.getCheckedRadioButtonId();
                rb_bgcolor = (RadioButton) findViewById(selectedId4);
                if(selectedId4!=-1){
                    String bg_color =  rb_bgcolor.getText().toString();
                    switch (bg_color) {
                        case "Grey":
                            intent2.putExtra("bg_color", getResources().getColor(R.color.grey));
                            break;
                        case "Green":
                            intent2.putExtra("bg_color", getResources().getColor(R.color.green));
                            break;
                        case "Purple":
                            intent2.putExtra("bg_color", getResources().getColor(R.color.purple));
                            break;
                    }
                }
                int selectedId5 = rg_ccolor.getCheckedRadioButtonId();
                rb_ccolor = (RadioButton) findViewById(selectedId5);
                if(selectedId5!=-1){
                    String t_color =  rb_ccolor.getText().toString();
                    switch (t_color) {
                        case "Red":
                            intent2.putExtra("checked_color", getResources().getColor(R.color.error_color));
                            break;
                        case "Blue":
                            intent2.putExtra("checked_color", getResources().getColor(R.color.deep_sky_blue));
                            break;
                        case "Yellow":
                            intent2.putExtra("checked_color", getResources().getColor(R.color.yellow));
                            break;
                    }
                }
                int selectedId6 = rg_uccolor.getCheckedRadioButtonId();
                rb_uccolor = (RadioButton) findViewById(selectedId6);
                if(selectedId6!=-1){
                    String t_color =  rb_uccolor.getText().toString();
                    switch (t_color) {
                        case "Red":
                            intent2.putExtra("unchecked_color", getResources().getColor(R.color.error_color));
                            break;
                        case "Blue":
                            intent2.putExtra("unchecked_color", getResources().getColor(R.color.deep_sky_blue));
                            break;
                        case "Yellow":
                            intent2.putExtra("unchecked_color", getResources().getColor(R.color.yellow));
                            break;
                    }
                }
                setResult(Activity.RESULT_OK,intent2);
                finish();
            }
        });
    }
}