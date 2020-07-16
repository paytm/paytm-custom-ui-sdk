package com.paytm.merchantsampleapp;


import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import net.one97.paytm.nativesdk.instruments.upicollect.models.UpiOptionsModel;

import java.util.List;

public class UpiAppListAdapter extends RecyclerView.Adapter<UpiAppListAdapter.UpiAppItemHolder> {

    private List<UpiOptionsModel> appList;
    private OnClickUpiApp onClickUpiApp;
    private int selectedPosition = 0;

    public UpiAppListAdapter(List<UpiOptionsModel> appList, OnClickUpiApp onClickUpiApp){
        this.appList = appList;
        this.onClickUpiApp = onClickUpiApp;
    }

    public void setSelectedPosition(int selectedPosition) {
        this.selectedPosition = selectedPosition;
        notifyDataSetChanged();
    }

    public int getSelectedPosition() {
        return selectedPosition;
    }

    @NonNull
    @Override
    public UpiAppItemHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new UpiAppItemHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_upi_app,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull UpiAppItemHolder holder, final int position) {

        /*if(position == 4 && appList.size() > 5){
            if (selectedPosition>3){
                holder.frameBg.setBackgroundResource(net.one97.paytm.nativesdk.R.drawable.native_circle_shadow);
                holder.ivSelected.setVisibility(View.VISIBLE);
                holder.appIcon.setImageDrawable(appList.get(selectedPosition).getDrawable());
                holder.tvAppName.setText(appList.get(selectedPosition).getAppName());
            } else {
                holder.frameBg.setBackgroundResource(net.one97.paytm.nativesdk.R.drawable.native_circle_bg);
                holder.appIcon.setImageResource(net.one97.paytm.nativesdk.R.drawable.ic_group_apps);
                holder.tvAppName.setText("Others");
                holder.ivSelected.setVisibility(View.GONE);

                holder.itemView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        onClickUpiApp.onClick(appList.get(position), true);
                        notifyDataSetChanged();
                    }
                });
            }

            return;
        }*/
        holder.appIcon.setImageDrawable(appList.get(position).getDrawable());
        holder.tvAppName.setText(appList.get(position).getAppName());
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onClickUpiApp.onClick(appList.get(position),false);
                selectedPosition = position;
                notifyDataSetChanged();
            }
        });

        if(position == selectedPosition){
            holder.frameBg.setBackgroundResource(R.drawable.native_circle_shadow);
            holder.ivSelected.setVisibility(View.VISIBLE);
        }else {
            holder.frameBg.setBackgroundResource(R.drawable.native_circle_bg);
            holder.ivSelected.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        return appList.size();
    }

    public static class UpiAppItemHolder extends RecyclerView.ViewHolder{

        private ImageView appIcon;
        private TextView tvAppName;
        private ImageView ivSelected;
        private FrameLayout frameBg;

        public UpiAppItemHolder(View itemView) {
            super(itemView);
            appIcon = itemView.findViewById(R.id.iv_appIcon);
            tvAppName = itemView.findViewById(R.id.tv_appName);
            ivSelected = itemView.findViewById(R.id.iv_selected);
            frameBg = itemView.findViewById(R.id.fl_bgView);
        }
    }

    public void clearSelected(){
        selectedPosition = -1;
        notifyDataSetChanged();
    }

    public interface OnClickUpiApp{
        void onClick(UpiOptionsModel upiOptionsModel, boolean isOtherClicked);
    }
}

