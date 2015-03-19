#!/bin/bash
# S. Salewski, 26-MAY-2014 (initial release, GTK 3.12)
# S. Salewski, 07-MAR-2015
# Generate GTK3 bindings for Nim -- this is for GTK headers 3.15.6
#
gtk3_dir="/home/stefan/Downloads/gtk+-3.15.6" # have currently only 3.14 lib installed!
final="final.h" # the input file for c2nim
list="list.txt"
wdir="tmp_gtk"

targets='a11y deprecated'
all_t=". ${targets}"

rm -rf $wdir # start from scratch
mkdir $wdir
cd $wdir
cp -r $gtk3_dir/gtk .
cd gtk

# check already done for 3.15.6...
#echo 'we may miss these headers -- please check:'
#for i in $all_t ; do
#  grep -c DECL ${i}/*.h | grep h:0
#done

# we insert in each header a marker with the filename
# may fail if G_BEGIN_DECLS macro is missing in a header
for j in $all_t ; do
  for i in ${j}/*.h; do
    sed -i "/^G_BEGIN_DECLS/a${i}_ssalewski;" $i
  done
done

cat gtk.h gtkunixprint.h gtk-a11y.h > all.h

cd ..

# cpp run with all headers to determine order
echo "cat \\" > $list

cpp -I. `pkg-config --cflags gtk+-3.0` gtk/all.h $final

# extract file names and push names to list
grep ssalewski $final | sed 's/_ssalewski;/ \\/' >> $list

# maybe add remaining missing headers
# for now we put all at the bottom and do manually insertion if we need these at all
# echo 'gtkactionhelper.h \' >> $list  # do not add, it uses G_GNUC_INTERNAL macro, so it really only for internal use
echo 'gtkintl.h \' >> $list # not really helpful?
#echo 'gtkmenutracker.h \' >> $list # do we need this?
#echo 'gtkmenutrackeritem.h \' >> $list

i=`uniq -d $list | wc -l`
if [ $i != 0 ]; then echo 'list contains duplicates!'; exit; fi;

# now we work again with original headers
rm -rf gtk
cp -r $gtk3_dir/gtk . 

# insert for each header file its name as first line
for j in $all_t ; do
  for i in gtk/${j}/*.h; do
    sed -i "1i/* file: $i */" $i
    sed -i "1i#define headerfilename \"$i\"" $i # marker for splitting
  done
done
cd gtk
  bash ../$list > ../$final
cd ..

# delete strange macros  -- define as empty for c2nim
# we restrict use of wildcards to limit risc of damage something!
for i in 2 4 6 8 10 12 14 16 ; do
  sed -i "1i#def GDK_AVAILABLE_IN_3_$i\n#def GDK_DEPRECATED_IN_3_$i\n#def GDK_DEPRECATED_IN_3_${i}_FOR(x)" $final
done

sed -i "1i#def G_BEGIN_DECLS" $final
sed -i "1i#def G_END_DECLS" $final
sed -i "1i#def GDK_AVAILABLE_IN_ALL" $final
sed -i "1i#def GDK_DEPRECATED" $final
sed -i "1i#def G_GNUC_DEPRECATED" $final
sed -i "1i#def GDK_DEPRECATED_IN_3_0" $final
sed -i "1i#def GDK_DEPRECATED_IN_3_0_FOR(x)" $final
sed -i "1i#def G_GNUC_MALLOC" $final
sed -i "1i#def G_GNUC_CONST" $final
sed -i "1i#def G_GNUC_NULL_TERMINATED" $final
sed -i "1i#def G_GNUC_PRINTF(i,j)" $final

perl -0777 -p -i -e "s/#if !?defined.*?\n#error.*?\n#endif//g" $final

# add missing {} for struct so that c2nim generates an object
sed -i 's/typedef struct _GtkAccelGroupPrivate      GtkAccelGroupPrivate;/typedef struct _GtkAccelGroupPrivate{} GtkAccelGroupPrivate;/' $final
sed -i 's/typedef struct _GtkGradient GtkGradient;/typedef struct _GtkGradient{} GtkGradient;/' $final
sed -i 's/typedef struct _GtkActivatable      GtkActivatable;/typedef struct _GtkActivatable{}      GtkActivatable;/' $final
sed -i 's/typedef struct _GtkTreeDragDest      GtkTreeDragDest;/typedef struct _GtkTreeDragDest{}      GtkTreeDragDest;/' $final
sed -i 's/typedef struct _GtkTreeDragSource      GtkTreeDragSource;/typedef struct _GtkTreeDragSource{}      GtkTreeDragSource;/' $final
sed -i 's/typedef struct _GtkToolShell           GtkToolShell;/typedef struct _GtkToolShell{}           GtkToolShell;/' $final
sed -i 's/typedef struct _GtkTextBTree GtkTextBTree;/typedef struct _GtkTextBTree{} GtkTextBTree;/' $final
sed -i 's/typedef struct _GtkScrollable          GtkScrollable;/typedef struct _GtkScrollable{}          GtkScrollable;/' $final
sed -i 's/typedef struct _GtkRecentFilter		GtkRecentFilter;/typedef struct _GtkRecentFilter{}		GtkRecentFilter;/' $final
sed -i 's/typedef struct _GtkRecentInfo		GtkRecentInfo;/typedef struct _GtkRecentInfo{}		GtkRecentInfo;/' $final
sed -i 's/typedef struct _GtkPrintOperationPreview      GtkPrintOperationPreview;/typedef struct _GtkPrintOperationPreview{}      GtkPrintOperationPreview;/' $final
sed -i 's/typedef struct _GtkPrintSettings GtkPrintSettings;/typedef struct _GtkPrintSettings{} GtkPrintSettings;/' $final
sed -i 's/typedef struct _GtkPlacesSidebar GtkPlacesSidebar;/typedef struct _GtkPlacesSidebar{} GtkPlacesSidebar;/' $final
sed -i 's/typedef struct _GtkPrintContext GtkPrintContext;/typedef struct _GtkPrintContext{} GtkPrintContext;/' $final
sed -i 's/typedef struct _GtkPageSetup GtkPageSetup;/typedef struct _GtkPageSetup{} GtkPageSetup;/' $final
sed -i 's/typedef struct _GtkPaperSize GtkPaperSize;/typedef struct _GtkPaperSize{} GtkPaperSize;/' $final
sed -i 's/typedef struct _GtkOrientable       GtkOrientable;/typedef struct _GtkOrientable{}       GtkOrientable;/' $final
sed -i 's/typedef struct _GtkStyleProvider GtkStyleProvider;/typedef struct _GtkStyleProvider{} GtkStyleProvider;/' $final
sed -i 's/typedef struct _GtkSizeGroupPrivate       GtkSizeGroupPrivate;/typedef struct _GtkSizeGroupPrivate{}       GtkSizeGroupPrivate;/' $final
sed -i 's/typedef struct _GtkRecentManagerPrivate GtkRecentManagerPrivate;/typedef struct _GtkRecentManagerPrivate{} GtkRecentManagerPrivate;/' $final
sed -i 's/typedef struct _GtkUIManagerPrivate GtkUIManagerPrivate;/typedef struct _GtkUIManagerPrivate{} GtkUIManagerPrivate;/' $final
sed -i 's/typedef struct _GtkTearoffMenuItemPrivate       GtkTearoffMenuItemPrivate;/typedef struct _GtkTearoffMenuItemPrivate{}       GtkTearoffMenuItemPrivate;/' $final
sed -i 's/typedef struct _GtkTablePrivate       GtkTablePrivate;/typedef struct _GtkTablePrivate{}       GtkTablePrivate;/' $final
sed -i 's/typedef struct _GtkRecentActionPrivate  GtkRecentActionPrivate;/typedef struct _GtkRecentActionPrivate{}  GtkRecentActionPrivate;/' $final
sed -i 's/typedef struct _GtkRadioActionPrivate GtkRadioActionPrivate;/typedef struct _GtkRadioActionPrivate{} GtkRadioActionPrivate;/' $final
sed -i 's/typedef struct _GtkToggleActionPrivate GtkToggleActionPrivate;/typedef struct _GtkToggleActionPrivate{} GtkToggleActionPrivate;/' $final
sed -i 's/typedef struct _GtkImageMenuItemPrivate       GtkImageMenuItemPrivate;/typedef struct _GtkImageMenuItemPrivate{}       GtkImageMenuItemPrivate;/' $final
sed -i 's/typedef struct _GtkHSVPrivate       GtkHSVPrivate;/typedef struct _GtkHSVPrivate{}       GtkHSVPrivate;/' $final
sed -i 's/typedef struct _GtkHandleBoxPrivate       GtkHandleBoxPrivate;/typedef struct _GtkHandleBoxPrivate{}       GtkHandleBoxPrivate;/' $final
sed -i 's/typedef struct _GtkFontSelectionPrivate       GtkFontSelectionPrivate;/typedef struct _GtkFontSelectionPrivate{}       GtkFontSelectionPrivate;/' $final
sed -i 's/typedef struct _GtkFontSelectionDialogPrivate       GtkFontSelectionDialogPrivate;/typedef struct _GtkFontSelectionDialogPrivate{}       GtkFontSelectionDialogPrivate;/' $final
sed -i 's/typedef struct _GtkColorSelectionDialogPrivate       GtkColorSelectionDialogPrivate;/typedef struct _GtkColorSelectionDialogPrivate{}       GtkColorSelectionDialogPrivate;/' $final
sed -i 's/typedef struct _GtkColorSelectionPrivate  GtkColorSelectionPrivate;/typedef struct _GtkColorSelectionPrivate{}  GtkColorSelectionPrivate;/' $final
sed -i 's/typedef struct _GtkActionGroupPrivate GtkActionGroupPrivate;/typedef struct _GtkActionGroupPrivate{} GtkActionGroupPrivate;/' $final
sed -i 's/typedef struct _GtkActionPrivate GtkActionPrivate;/typedef struct _GtkActionPrivate{} GtkActionPrivate;/' $final
sed -i 's/typedef struct _GtkViewportPrivate       GtkViewportPrivate;/typedef struct _GtkViewportPrivate{}       GtkViewportPrivate;/' $final
sed -i 's/typedef struct _GtkTreeStorePrivate GtkTreeStorePrivate;/typedef struct _GtkTreeStorePrivate{} GtkTreeStorePrivate;/' $final
sed -i 's/typedef struct _GtkTreeModelSortPrivate GtkTreeModelSortPrivate;/typedef struct _GtkTreeModelSortPrivate{} GtkTreeModelSortPrivate;/' $final
sed -i 's/typedef struct _GtkToolPalettePrivate    GtkToolPalettePrivate;/typedef struct _GtkToolPalettePrivate{}    GtkToolPalettePrivate;/' $final
sed -i 's/typedef struct _GtkToolItemGroupPrivate GtkToolItemGroupPrivate;/typedef struct _GtkToolItemGroupPrivate{} GtkToolItemGroupPrivate;/' $final
sed -i 's/typedef struct _GtkToolbarPrivate       GtkToolbarPrivate;/typedef struct _GtkToolbarPrivate{}       GtkToolbarPrivate;/' $final
sed -i 's/typedef struct _GtkTextViewPrivate GtkTextViewPrivate;/typedef struct _GtkTextViewPrivate{} GtkTextViewPrivate;/' $final
sed -i 's/typedef struct _GtkTextTagTablePrivate       GtkTextTagTablePrivate;/typedef struct _GtkTextTagTablePrivate{}       GtkTextTagTablePrivate;/' $final
sed -i 's/typedef struct _GtkSwitchPrivate        GtkSwitchPrivate;/typedef struct _GtkSwitchPrivate{}        GtkSwitchPrivate;/' $final
sed -i 's/typedef struct _GtkStatusIconPrivate GtkStatusIconPrivate;/typedef struct _GtkStatusIconPrivate{} GtkStatusIconPrivate;/' $final
sed -i 's/typedef struct _GtkStatusbarPrivate       GtkStatusbarPrivate;/typedef struct _GtkStatusbarPrivate{}       GtkStatusbarPrivate;/' $final
sed -i 's/typedef struct _GtkSpinnerPrivate  GtkSpinnerPrivate;/typedef struct _GtkSpinnerPrivate{}  GtkSpinnerPrivate;/' $final
sed -i 's/typedef struct _GtkSpinButtonPrivate       GtkSpinButtonPrivate;/typedef struct _GtkSpinButtonPrivate{}       GtkSpinButtonPrivate;/' $final
sed -i 's/typedef struct _GtkSeparatorToolItemPrivate GtkSeparatorToolItemPrivate;/typedef struct _GtkSeparatorToolItemPrivate{} GtkSeparatorToolItemPrivate;/' $final
sed -i 's/typedef struct _GtkSeparatorPrivate       GtkSeparatorPrivate;/typedef struct _GtkSeparatorPrivate{}       GtkSeparatorPrivate;/' $final
sed -i 's/typedef struct _GtkScrolledWindowPrivate       GtkScrolledWindowPrivate;/typedef struct _GtkScrolledWindowPrivate{}       GtkScrolledWindowPrivate;/' $final
sed -i 's/typedef struct _GtkScaleButtonPrivate GtkScaleButtonPrivate;/typedef struct _GtkScaleButtonPrivate{} GtkScaleButtonPrivate;/' $final
sed -i 's/typedef struct _GtkScalePrivate       GtkScalePrivate;/typedef struct _GtkScalePrivate{}       GtkScalePrivate;/' $final
sed -i 's/typedef struct _GtkRecentChooser      GtkRecentChooser;/typedef struct _GtkRecentChooser{}      GtkRecentChooser;/' $final
sed -i 's/typedef struct _GtkRecentChooserMenuPrivate	GtkRecentChooserMenuPrivate;/typedef struct _GtkRecentChooserMenuPrivate{}	GtkRecentChooserMenuPrivate;/' $final
sed -i 's/typedef struct _GtkRecentChooserDialogPrivate GtkRecentChooserDialogPrivate;/typedef struct _GtkRecentChooserDialogPrivate{} GtkRecentChooserDialogPrivate;/' $final
sed -i 's/typedef struct _GtkRecentChooserWidgetPrivate GtkRecentChooserWidgetPrivate;/typedef struct _GtkRecentChooserWidgetPrivate{} GtkRecentChooserWidgetPrivate;/' $final
sed -i 's/typedef struct _GtkRangePrivate       GtkRangePrivate;/typedef struct _GtkRangePrivate{}       GtkRangePrivate;/' $final
sed -i 's/typedef struct _GtkToggleToolButtonPrivate GtkToggleToolButtonPrivate;/typedef struct _GtkToggleToolButtonPrivate{} GtkToggleToolButtonPrivate;/' $final
sed -i 's/typedef struct _GtkRadioMenuItemPrivate       GtkRadioMenuItemPrivate;/typedef struct _GtkRadioMenuItemPrivate{}       GtkRadioMenuItemPrivate;/' $final
sed -i 's/typedef struct _GtkRadioButtonPrivate       GtkRadioButtonPrivate;/typedef struct _GtkRadioButtonPrivate{}       GtkRadioButtonPrivate;/' $final
sed -i 's/typedef struct _GtkProgressBarPrivate       GtkProgressBarPrivate;/typedef struct _GtkProgressBarPrivate{}       GtkProgressBarPrivate;/' $final
sed -i 's/typedef struct _GtkPrintOperationPrivate GtkPrintOperationPrivate;/typedef struct _GtkPrintOperationPrivate{} GtkPrintOperationPrivate;/' $final
sed -i 's/typedef struct _GtkPanedPrivate GtkPanedPrivate;/typedef struct _GtkPanedPrivate{} GtkPanedPrivate;/' $final
sed -i 's/typedef struct _GtkOverlayPrivate  GtkOverlayPrivate;/typedef struct _GtkOverlayPrivate{}  GtkOverlayPrivate;/' $final
sed -i 's/typedef struct _GtkNumerableIconPrivate GtkNumerableIconPrivate;/typedef struct _GtkNumerableIconPrivate{} GtkNumerableIconPrivate;/' $final
sed -i 's/typedef struct _GtkNotebookPrivate       GtkNotebookPrivate;/typedef struct _GtkNotebookPrivate{}       GtkNotebookPrivate;/' $final
sed -i 's/typedef struct _GtkMountOperationPrivate  GtkMountOperationPrivate;/typedef struct _GtkMountOperationPrivate{}  GtkMountOperationPrivate;/' $final
sed -i 's/typedef struct _GtkMessageDialogPrivate       GtkMessageDialogPrivate;/typedef struct _GtkMessageDialogPrivate{}       GtkMessageDialogPrivate;/' $final
sed -i 's/typedef struct _GtkMenuToolButtonPrivate GtkMenuToolButtonPrivate;/typedef struct _GtkMenuToolButtonPrivate{} GtkMenuToolButtonPrivate;/' $final
sed -i 's/typedef struct _GtkToolButtonPrivate GtkToolButtonPrivate;/typedef struct _GtkToolButtonPrivate{} GtkToolButtonPrivate;/' $final
sed -i 's/typedef struct _GtkToolItemPrivate GtkToolItemPrivate;/typedef struct _GtkToolItemPrivate{} GtkToolItemPrivate;/' $final
sed -i 's/typedef struct _GtkMenuButtonPrivate GtkMenuButtonPrivate;/typedef struct _GtkMenuButtonPrivate{} GtkMenuButtonPrivate;/' $final
sed -i 's/typedef struct _GtkPopoverPrivate GtkPopoverPrivate;/typedef struct _GtkPopoverPrivate{} GtkPopoverPrivate;/' $final
sed -i 's/typedef struct _GtkMenuBarPrivate  GtkMenuBarPrivate;/typedef struct _GtkMenuBarPrivate{}  GtkMenuBarPrivate;/' $final
sed -i 's/typedef struct _GtkLockButtonPrivate GtkLockButtonPrivate;/typedef struct _GtkLockButtonPrivate{} GtkLockButtonPrivate;/' $final
sed -i 's/typedef struct _GtkLinkButtonPrivate	GtkLinkButtonPrivate;/typedef struct _GtkLinkButtonPrivate{}	GtkLinkButtonPrivate;/' $final
sed -i 's/typedef struct _GtkLevelBarPrivate GtkLevelBarPrivate;/typedef struct _GtkLevelBarPrivate{} GtkLevelBarPrivate;/' $final
sed -i 's/typedef struct _GtkLayoutPrivate       GtkLayoutPrivate;/typedef struct _GtkLayoutPrivate{}       GtkLayoutPrivate;/' $final
sed -i 's/typedef struct _GtkInvisiblePrivate       GtkInvisiblePrivate;/typedef struct _GtkInvisiblePrivate{}       GtkInvisiblePrivate;/' $final
sed -i 's/typedef struct _GtkInfoBarPrivate GtkInfoBarPrivate;/typedef struct _GtkInfoBarPrivate{} GtkInfoBarPrivate;/' $final
sed -i 's/typedef struct _GtkIMMulticontextPrivate GtkIMMulticontextPrivate;/typedef struct _GtkIMMulticontextPrivate{} GtkIMMulticontextPrivate;/' $final
sed -i 's/typedef struct _GtkIMContextSimplePrivate       GtkIMContextSimplePrivate;/typedef struct _GtkIMContextSimplePrivate{}       GtkIMContextSimplePrivate;/' $final
sed -i 's/typedef struct _GtkIconViewPrivate    GtkIconViewPrivate;/typedef struct _GtkIconViewPrivate{}    GtkIconViewPrivate;/' $final
sed -i 's/typedef struct _GtkIconThemePrivate GtkIconThemePrivate;/typedef struct _GtkIconThemePrivate{} GtkIconThemePrivate;/' $final
sed -i 's/typedef struct _GtkStyleContextPrivate GtkStyleContextPrivate;/typedef struct _GtkStyleContextPrivate{} GtkStyleContextPrivate;/' $final
sed -i 's/typedef struct _GtkStylePropertiesPrivate GtkStylePropertiesPrivate;/typedef struct _GtkStylePropertiesPrivate{} GtkStylePropertiesPrivate;/' $final
sed -i 's/typedef struct _GtkIconFactoryPrivate       GtkIconFactoryPrivate;/typedef struct _GtkIconFactoryPrivate{}       GtkIconFactoryPrivate;/' $final
sed -i 's/typedef struct _GtkGridPrivate       GtkGridPrivate;/typedef struct _GtkGridPrivate{}       GtkGridPrivate;/' $final
sed -i 's/typedef struct _GtkFileChooserWidgetPrivate GtkFileChooserWidgetPrivate;/typedef struct _GtkFileChooserWidgetPrivate{} GtkFileChooserWidgetPrivate;/' $final
sed -i 's/typedef struct _GtkSymbolicColor GtkSymbolicColor;/typedef struct _GtkSymbolicColor{} GtkSymbolicColor;/' $final
sed -i 's/typedef struct _GtkFontChooserDialogPrivate       GtkFontChooserDialogPrivate;/typedef struct _GtkFontChooserDialogPrivate{}       GtkFontChooserDialogPrivate;/' $final
sed -i 's/typedef struct _GtkFontButtonPrivate GtkFontButtonPrivate;/typedef struct _GtkFontButtonPrivate{} GtkFontButtonPrivate;/' $final
sed -i 's/typedef struct _GtkIconInfo         GtkIconInfo;/typedef struct _GtkIconInfo{}         GtkIconInfo;/' $final
sed -i 's/typedef struct _GtkIconSource          GtkIconSource;/typedef struct _GtkIconSource{}          GtkIconSource;/' $final
sed -i 's/typedef struct _GtkFileChooserDialogPrivate GtkFileChooserDialogPrivate;/typedef struct _GtkFileChooserDialogPrivate{} GtkFileChooserDialogPrivate;/' $final
sed -i 's/typedef struct _GtkFileChooserButtonPrivate GtkFileChooserButtonPrivate;/typedef struct _GtkFileChooserButtonPrivate{} GtkFileChooserButtonPrivate;/' $final
sed -i 's/typedef struct _GtkFileChooser      GtkFileChooser;/typedef struct _GtkFileChooser{}      GtkFileChooser;/' $final
sed -i 's/typedef struct _GtkFileFilter     GtkFileFilter;/typedef struct _GtkFileFilter{}     GtkFileFilter;/' $final
sed -i 's/typedef struct _GtkCssSection GtkCssSection;/typedef struct _GtkCssSection{} GtkCssSection;/' $final
sed -i 's/typedef struct _GtkColorChooser          GtkColorChooser;/typedef struct _GtkColorChooser{}          GtkColorChooser;/' $final
sed -i 's/typedef struct _GtkCellLayout           GtkCellLayout;/typedef struct _GtkCellLayout{}           GtkCellLayout;/' $final
sed -i 's/typedef struct _GtkCssProviderPrivate GtkCssProviderPrivate;/typedef struct _GtkCssProviderPrivate{} GtkCssProviderPrivate;/' $final
sed -i 's/typedef struct _GtkEventBoxPrivate GtkEventBoxPrivate;/typedef struct _GtkEventBoxPrivate{} GtkEventBoxPrivate;/' $final
sed -i 's/typedef struct _GtkComboBoxTextPrivate      GtkComboBoxTextPrivate;/typedef struct _GtkComboBoxTextPrivate{}      GtkComboBoxTextPrivate;/' $final
sed -i 's/typedef struct _GtkCellRendererTogglePrivate       GtkCellRendererTogglePrivate;/typedef struct _GtkCellRendererTogglePrivate{}       GtkCellRendererTogglePrivate;/' $final
sed -i 's/typedef struct _GtkCheckMenuItemPrivate       GtkCheckMenuItemPrivate;/typedef struct _GtkCheckMenuItemPrivate{}       GtkCheckMenuItemPrivate;/' $final
sed -i 's/typedef struct _GtkMenuItemPrivate GtkMenuItemPrivate;/typedef struct _GtkMenuItemPrivate{} GtkMenuItemPrivate;/' $final
sed -i 's/typedef struct _GtkFixedPrivate       GtkFixedPrivate;/typedef struct _GtkFixedPrivate{}       GtkFixedPrivate;/' $final
sed -i 's/typedef struct _GtkExpanderPrivate GtkExpanderPrivate;/typedef struct _GtkExpanderPrivate{} GtkExpanderPrivate;/' $final
sed -i 's/typedef struct _GtkCellViewPrivate      GtkCellViewPrivate;/typedef struct _GtkCellViewPrivate{}      GtkCellViewPrivate;/' $final
sed -i 's/typedef struct _GtkColorButtonPrivate   GtkColorButtonPrivate;/typedef struct _GtkColorButtonPrivate{}   GtkColorButtonPrivate;/' $final
sed -i 's/typedef struct _GtkColorChooserDialogPrivate GtkColorChooserDialogPrivate;/typedef struct _GtkColorChooserDialogPrivate{} GtkColorChooserDialogPrivate;/' $final
sed -i 's/typedef struct _GtkToggleButtonPrivate       GtkToggleButtonPrivate;/typedef struct _GtkToggleButtonPrivate{}       GtkToggleButtonPrivate;/' $final
sed -i 's/typedef struct _GtkCellRendererSpinnerPrivate GtkCellRendererSpinnerPrivate;/typedef struct _GtkCellRendererSpinnerPrivate{} GtkCellRendererSpinnerPrivate;/' $final
sed -i 's/typedef struct _GtkCellRendererSpinPrivate GtkCellRendererSpinPrivate;/typedef struct _GtkCellRendererSpinPrivate{} GtkCellRendererSpinPrivate;/' $final
sed -i 's/typedef struct _GtkCellRendererProgressPrivate  GtkCellRendererProgressPrivate;/typedef struct _GtkCellRendererProgressPrivate{}  GtkCellRendererProgressPrivate;/' $final
sed -i 's/typedef struct _GtkCellRendererPixbufPrivate       GtkCellRendererPixbufPrivate;/typedef struct _GtkCellRendererPixbufPrivate{}       GtkCellRendererPixbufPrivate;/' $final
sed -i 's/typedef struct _GtkCellRendererComboPrivate       GtkCellRendererComboPrivate;/typedef struct _GtkCellRendererComboPrivate{}       GtkCellRendererComboPrivate;/' $final
sed -i 's/typedef struct _GtkCellRendererAccelPrivate       GtkCellRendererAccelPrivate;/typedef struct _GtkCellRendererAccelPrivate{}       GtkCellRendererAccelPrivate;/' $final
sed -i 's/typedef struct _GtkCellRendererTextPrivate       GtkCellRendererTextPrivate;/typedef struct _GtkCellRendererTextPrivate{}       GtkCellRendererTextPrivate;/' $final
sed -i 's/typedef struct _GtkButtonPrivate      GtkButtonPrivate;/typedef struct _GtkButtonPrivate{}      GtkButtonPrivate;/' $final
sed -i 's/typedef struct _GtkBuildable      GtkBuildable;/typedef struct _GtkBuildable{}      GtkBuildable;/' $final
sed -i 's/typedef struct _GtkIconSet             GtkIconSet;/typedef struct _GtkIconSet{}             GtkIconSet;/' $final
sed -i 's/typedef struct _GtkCellAreaBoxPrivate       GtkCellAreaBoxPrivate;/typedef struct _GtkCellAreaBoxPrivate{}       GtkCellAreaBoxPrivate;/' $final
sed -i 's/typedef struct _GtkAssistantPrivate GtkAssistantPrivate;/typedef struct _GtkAssistantPrivate{} GtkAssistantPrivate;/' $final
sed -i 's/typedef struct _GtkButtonBoxPrivate       GtkButtonBoxPrivate;/typedef struct _GtkButtonBoxPrivate{}       GtkButtonBoxPrivate;/' $final
sed -i 's/typedef struct _GtkAspectFramePrivate       GtkAspectFramePrivate;/typedef struct _GtkAspectFramePrivate{}       GtkAspectFramePrivate;/' $final
sed -i 's/typedef struct _GtkCalendarPrivate     GtkCalendarPrivate;/typedef struct _GtkCalendarPrivate{}     GtkCalendarPrivate;/' $final
sed -i 's/typedef struct _GtkFramePrivate       GtkFramePrivate;/typedef struct _GtkFramePrivate{}       GtkFramePrivate;/' $final
sed -i 's/typedef struct _GtkTreeSelectionPrivate      GtkTreeSelectionPrivate;/typedef struct _GtkTreeSelectionPrivate{}      GtkTreeSelectionPrivate;/' $final
sed -i 's/typedef struct _GtkApplicationWindowPrivate GtkApplicationWindowPrivate;/typedef struct _GtkApplicationWindowPrivate{} GtkApplicationWindowPrivate;/' $final
sed -i 's/typedef struct _GtkArrowPrivate       GtkArrowPrivate;/typedef struct _GtkArrowPrivate{}       GtkArrowPrivate;/' $final
sed -i 's/typedef struct _GtkAppChooserButtonPrivate GtkAppChooserButtonPrivate;/typedef struct _GtkAppChooserButtonPrivate{} GtkAppChooserButtonPrivate;/' $final
sed -i 's/typedef struct _GtkComboBoxPrivate GtkComboBoxPrivate;/typedef struct _GtkComboBoxPrivate{} GtkComboBoxPrivate;/' $final
sed -i 's/typedef struct _GtkTreeViewPrivate    GtkTreeViewPrivate;/typedef struct _GtkTreeViewPrivate{}    GtkTreeViewPrivate;/' $final
sed -i 's/typedef struct _GtkEntryPrivate       GtkEntryPrivate;/typedef struct _GtkEntryPrivate{}       GtkEntryPrivate;/' $final
sed -i 's/typedef struct _GtkImagePrivate       GtkImagePrivate;/typedef struct _GtkImagePrivate{}       GtkImagePrivate;/' $final
sed -i 's/typedef struct _GtkEntryCompletionPrivate     GtkEntryCompletionPrivate;/typedef struct _GtkEntryCompletionPrivate{}     GtkEntryCompletionPrivate;/' $final
sed -i 's/typedef struct _GtkEditable          GtkEditable;/typedef struct _GtkEditable{}          GtkEditable;/' $final
sed -i 's/typedef struct _GtkTargetList  GtkTargetList;/typedef struct _GtkTargetList{}  GtkTargetList;/' $final
sed -i 's/typedef struct _GtkTreeModelFilterPrivate   GtkTreeModelFilterPrivate;/typedef struct _GtkTreeModelFilterPrivate{}   GtkTreeModelFilterPrivate;/' $final
sed -i 's/typedef struct _GtkEntryBufferPrivate     GtkEntryBufferPrivate;/typedef struct _GtkEntryBufferPrivate{}     GtkEntryBufferPrivate;/' $final
sed -i 's/typedef struct _GtkListStorePrivate       GtkListStorePrivate;/typedef struct _GtkListStorePrivate{}       GtkListStorePrivate;/' $final
sed -i 's/typedef struct _GtkTextBufferPrivate GtkTextBufferPrivate;/typedef struct _GtkTextBufferPrivate{} GtkTextBufferPrivate;/' $final
sed -i 's/typedef struct _GtkTextTagPrivate      GtkTextTagPrivate;/typedef struct _GtkTextTagPrivate{}      GtkTextTagPrivate;/' $final
sed -i 's/typedef struct _GtkTreeViewColumnPrivate GtkTreeViewColumnPrivate;/typedef struct _GtkTreeViewColumnPrivate{} GtkTreeViewColumnPrivate;/' $final
sed -i 's/typedef struct _GtkTreeSortable      GtkTreeSortable;/typedef struct _GtkTreeSortable{}      GtkTreeSortable;/' $final
sed -i 's/typedef struct _GtkCellAreaContextPrivate       GtkCellAreaContextPrivate;/typedef struct _GtkCellAreaContextPrivate{}       GtkCellAreaContextPrivate;/' $final
sed -i 's/typedef struct _GtkCellAreaPrivate       GtkCellAreaPrivate;/typedef struct _GtkCellAreaPrivate{}       GtkCellAreaPrivate;/' $final
sed -i 's/typedef struct _GtkCellRendererClassPrivate  GtkCellRendererClassPrivate;/typedef struct _GtkCellRendererClassPrivate{}  GtkCellRendererClassPrivate;/' $final
sed -i 's/typedef struct _GtkCellRendererPrivate       GtkCellRendererPrivate;/typedef struct _GtkCellRendererPrivate{}       GtkCellRendererPrivate;/' $final
sed -i 's/typedef struct _GtkCellEditable      GtkCellEditable;/typedef struct _GtkCellEditable{}      GtkCellEditable;/' $final
sed -i 's/typedef struct _GtkTreeRowReference GtkTreeRowReference;/typedef struct _GtkTreeRowReference{} GtkTreeRowReference;/' $final
sed -i 's/typedef struct _GtkTreePath         GtkTreePath;/typedef struct _GtkTreePath{}         GtkTreePath;/' $final
sed -i 's/typedef struct _GtkTreeModel        GtkTreeModel;/typedef struct _GtkTreeModel{}        GtkTreeModel;/' $final
sed -i 's/typedef struct _GtkActionable                               GtkActionable;/typedef struct _GtkActionable{}                               GtkActionable;/' $final
sed -i 's/typedef struct _GtkAppChooserDialogPrivate GtkAppChooserDialogPrivate;/typedef struct _GtkAppChooserDialogPrivate{} GtkAppChooserDialogPrivate;/' $final
sed -i 's/typedef struct _GtkAppChooser GtkAppChooser;/typedef struct _GtkAppChooser{} GtkAppChooser;/' $final
sed -i 's/typedef struct _GtkAccelMap      GtkAccelMap;/typedef struct _GtkAccelMap{}      GtkAccelMap;/' $final
sed -i 's/typedef struct _GtkBoxPrivate       GtkBoxPrivate;/typedef struct _GtkBoxPrivate{}       GtkBoxPrivate;/' $final
sed -i 's/typedef struct _GtkAlignmentPrivate       GtkAlignmentPrivate;/typedef struct _GtkAlignmentPrivate{}       GtkAlignmentPrivate;/' $final
sed -i 's/typedef struct _GtkAccelLabelPrivate GtkAccelLabelPrivate;/typedef struct _GtkAccelLabelPrivate{} GtkAccelLabelPrivate;/' $final
sed -i 's/typedef struct _GtkAccessiblePrivate GtkAccessiblePrivate;/typedef struct _GtkAccessiblePrivate{} GtkAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkLabelPrivate       GtkLabelPrivate;/typedef struct _GtkLabelPrivate{}       GtkLabelPrivate;/' $final
sed -i 's/typedef struct _GtkMenuShellPrivate GtkMenuShellPrivate;/typedef struct _GtkMenuShellPrivate{} GtkMenuShellPrivate;/' $final
sed -i 's/typedef struct _GtkMenuPrivate GtkMenuPrivate;/typedef struct _GtkMenuPrivate{} GtkMenuPrivate;/' $final
sed -i 's/typedef struct _GtkMiscPrivate       GtkMiscPrivate;/typedef struct _GtkMiscPrivate{}       GtkMiscPrivate;/' $final
sed -i 's/typedef struct _GtkAboutDialogPrivate GtkAboutDialogPrivate;/typedef struct _GtkAboutDialogPrivate{} GtkAboutDialogPrivate;/' $final
sed -i 's/typedef struct _GtkDialogPrivate       GtkDialogPrivate;/typedef struct _GtkDialogPrivate{}       GtkDialogPrivate;/' $final
sed -i 's/typedef struct _GtkWindowGroupPrivate GtkWindowGroupPrivate;/typedef struct _GtkWindowGroupPrivate{} GtkWindowGroupPrivate;/' $final
sed -i 's/typedef struct _GtkWindowPrivate      GtkWindowPrivate;/typedef struct _GtkWindowPrivate{}      GtkWindowPrivate;/' $final
sed -i 's/typedef struct _GtkBinPrivate       GtkBinPrivate;/typedef struct _GtkBinPrivate{}       GtkBinPrivate;/' $final
sed -i 's/typedef struct _GtkAdjustmentPrivate  GtkAdjustmentPrivate;/typedef struct _GtkAdjustmentPrivate{}  GtkAdjustmentPrivate;/' $final
sed -i 's/typedef struct _GtkContainerPrivate       GtkContainerPrivate;/typedef struct _GtkContainerPrivate{}       GtkContainerPrivate;/' $final
sed -i 's/typedef struct _GtkApplicationPrivate GtkApplicationPrivate;/typedef struct _GtkApplicationPrivate{} GtkApplicationPrivate;/' $final
sed -i 's/typedef struct _GtkSettingsPrivate GtkSettingsPrivate;/typedef struct _GtkSettingsPrivate{} GtkSettingsPrivate;/' $final
sed -i 's/typedef struct _GtkWidgetClassPrivate  GtkWidgetClassPrivate;/typedef struct _GtkWidgetClassPrivate{}  GtkWidgetClassPrivate;/' $final
sed -i 's/typedef struct _GtkFontChooserWidgetPrivate       GtkFontChooserWidgetPrivate;/typedef struct _GtkFontChooserWidgetPrivate{}       GtkFontChooserWidgetPrivate;/' $final
sed -i 's/typedef struct _GtkFontChooser      GtkFontChooser;/typedef struct _GtkFontChooser{}      GtkFontChooser;/' $final
sed -i 's/typedef struct _GtkColorChooserWidgetPrivate GtkColorChooserWidgetPrivate;/typedef struct _GtkColorChooserWidgetPrivate{} GtkColorChooserWidgetPrivate;/' $final
sed -i 's/typedef struct _GtkAppChooserWidgetPrivate GtkAppChooserWidgetPrivate;/typedef struct _GtkAppChooserWidgetPrivate{} GtkAppChooserWidgetPrivate;/' $final
sed -i 's/typedef struct _GtkWidgetPath          GtkWidgetPath;/typedef struct _GtkWidgetPath{}          GtkWidgetPath;/' $final
sed -i 's/typedef struct _GtkClipboard	       GtkClipboard;/typedef struct _GtkClipboard{}	       GtkClipboard;/' $final
sed -i 's/typedef struct _GtkTooltip             GtkTooltip;/typedef struct _GtkTooltip{}             GtkTooltip;/' $final
sed -i 's/typedef struct _GtkSelectionData       GtkSelectionData;/typedef struct _GtkSelectionData{}       GtkSelectionData;/' $final
sed -i 's/typedef struct _GtkWidgetPrivate       GtkWidgetPrivate;/typedef struct _GtkWidgetPrivate{}       GtkWidgetPrivate;/' $final
sed -i 's/typedef struct _GtkBuilderPrivate GtkBuilderPrivate;/typedef struct _GtkBuilderPrivate{} GtkBuilderPrivate;/' $final
sed -i 's/typedef struct _GtkEventController GtkEventController;/typedef struct _GtkEventController{} GtkEventController;/' $final
sed -i 's/typedef struct _GtkGesture GtkGesture;/typedef struct _GtkGesture{} GtkGesture;/' $final
sed -i 's/typedef struct _GtkGestureSingle GtkGestureSingle;/typedef struct _GtkGestureSingle{} GtkGestureSingle;/' $final
sed -i 's/typedef struct _GtkGestureDrag GtkGestureDrag;/typedef struct _GtkGestureDrag{} GtkGestureDrag;/' $final
sed -i 's/typedef struct _GtkGestureMultiPress GtkGestureMultiPress;/typedef struct _GtkGestureMultiPress{} GtkGestureMultiPress;/' $final
sed -i 's/typedef struct _GtkGesturePan GtkGesturePan;/typedef struct _GtkGesturePan{} GtkGesturePan;/' $final
sed -i 's/typedef struct _GtkGestureRotate GtkGestureRotate;/typedef struct _GtkGestureRotate{} GtkGestureRotate;/' $final
sed -i 's/typedef struct _GtkGestureSwipe GtkGestureSwipe;/typedef struct _GtkGestureSwipe{} GtkGestureSwipe;/' $final
sed -i 's/typedef struct _GtkGestureZoom GtkGestureZoom;/typedef struct _GtkGestureZoom{} GtkGestureZoom;/' $final
sed -i 's/typedef struct _GtkPopoverMenu GtkPopoverMenu;/typedef struct _GtkPopoverMenu{} GtkPopoverMenu;/' $final
sed -i 's/typedef struct GtkThemingEnginePrivate GtkThemingEnginePrivate;/typedef struct GtkThemingEnginePrivate{} GtkThemingEnginePrivate;/' $final
sed -i 's/typedef struct _GtkPageSetupUnixDialogPrivate  GtkPageSetupUnixDialogPrivate;/typedef struct _GtkPageSetupUnixDialogPrivate{} GtkPageSetupUnixDialogPrivate;/' $final
sed -i 's/typedef struct _GtkPrinterPrivate   GtkPrinterPrivate;/typedef struct _GtkPrinterPrivate{} GtkPrinterPrivate;/' $final
sed  -i "s/typedef struct _GtkPrintJobPrivate   GtkPrintJobPrivate;/typedef struct _GtkPrintJobPrivate{} GtkPrintJobPrivate;/" $final
sed  -i "s/typedef struct GtkPrintUnixDialogPrivate   GtkPrintUnixDialogPrivate;/typedef struct GtkPrintUnixDialogPrivate{} GtkPrintUnixDialogPrivate;/" $final
sed -i 's/typedef struct _GtkCellAccessibleParent GtkCellAccessibleParent;/typedef struct _GtkCellAccessibleParent{} GtkCellAccessibleParent;/' $final
sed -i 's/typedef struct _GtkWindowAccessiblePrivate GtkWindowAccessiblePrivate;/typedef struct _GtkWindowAccessiblePrivate{} GtkWindowAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkTreeViewAccessiblePrivate GtkTreeViewAccessiblePrivate;/typedef struct _GtkTreeViewAccessiblePrivate{} GtkTreeViewAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkToplevelAccessiblePrivate GtkToplevelAccessiblePrivate;/typedef struct _GtkToplevelAccessiblePrivate{} GtkToplevelAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkTextViewAccessiblePrivate GtkTextViewAccessiblePrivate;/typedef struct _GtkTextViewAccessiblePrivate{} GtkTextViewAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkTextCellAccessiblePrivate GtkTextCellAccessiblePrivate;/typedef struct _GtkTextCellAccessiblePrivate{} GtkTextCellAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkSwitchAccessiblePrivate GtkSwitchAccessiblePrivate;/typedef struct _GtkSwitchAccessiblePrivate{} GtkSwitchAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkStatusbarAccessiblePrivate GtkStatusbarAccessiblePrivate;/typedef struct _GtkStatusbarAccessiblePrivate{} GtkStatusbarAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkSpinnerAccessiblePrivate GtkSpinnerAccessiblePrivate;/typedef struct _GtkSpinnerAccessiblePrivate{} GtkSpinnerAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkSpinButtonAccessiblePrivate GtkSpinButtonAccessiblePrivate;/typedef struct _GtkSpinButtonAccessiblePrivate{} GtkSpinButtonAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkScrolledWindowAccessiblePrivate GtkScrolledWindowAccessiblePrivate;/typedef struct _GtkScrolledWindowAccessiblePrivate{} GtkScrolledWindowAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkScaleButtonAccessiblePrivate GtkScaleButtonAccessiblePrivate;/typedef struct _GtkScaleButtonAccessiblePrivate{} GtkScaleButtonAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkScaleAccessiblePrivate GtkScaleAccessiblePrivate;/typedef struct _GtkScaleAccessiblePrivate{} GtkScaleAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkRangeAccessiblePrivate GtkRangeAccessiblePrivate;/typedef struct _GtkRangeAccessiblePrivate{} GtkRangeAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkRadioMenuItemAccessiblePrivate GtkRadioMenuItemAccessiblePrivate;/typedef struct _GtkRadioMenuItemAccessiblePrivate{} GtkRadioMenuItemAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkRadioButtonAccessiblePrivate GtkRadioButtonAccessiblePrivate;/typedef struct _GtkRadioButtonAccessiblePrivate{} GtkRadioButtonAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkProgressBarAccessiblePrivate GtkProgressBarAccessiblePrivate;/typedef struct _GtkProgressBarAccessiblePrivate{} GtkProgressBarAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkPanedAccessiblePrivate GtkPanedAccessiblePrivate;/typedef struct _GtkPanedAccessiblePrivate{} GtkPanedAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkNotebookPageAccessiblePrivate GtkNotebookPageAccessiblePrivate;/typedef struct _GtkNotebookPageAccessiblePrivate{} GtkNotebookPageAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkNotebookAccessiblePrivate GtkNotebookAccessiblePrivate;/typedef struct _GtkNotebookAccessiblePrivate{} GtkNotebookAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkMenuButtonAccessiblePrivate GtkMenuButtonAccessiblePrivate;/typedef struct _GtkMenuButtonAccessiblePrivate{} GtkMenuButtonAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkToggleButtonAccessiblePrivate GtkToggleButtonAccessiblePrivate;/typedef struct _GtkToggleButtonAccessiblePrivate{} GtkToggleButtonAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkMenuAccessiblePrivate GtkMenuAccessiblePrivate;/typedef struct _GtkMenuAccessiblePrivate{} GtkMenuAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkMenuShellAccessiblePrivate GtkMenuShellAccessiblePrivate;/typedef struct _GtkMenuShellAccessiblePrivate{} GtkMenuShellAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkLockButtonAccessiblePrivate GtkLockButtonAccessiblePrivate;/typedef struct _GtkLockButtonAccessiblePrivate{} GtkLockButtonAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkListBoxAccessiblePrivate GtkListBoxAccessiblePrivate;/typedef struct _GtkListBoxAccessiblePrivate{} GtkListBoxAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkLinkButtonAccessiblePrivate GtkLinkButtonAccessiblePrivate;/typedef struct _GtkLinkButtonAccessiblePrivate{} GtkLinkButtonAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkLabelAccessiblePrivate GtkLabelAccessiblePrivate;/typedef struct _GtkLabelAccessiblePrivate{} GtkLabelAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkLevelBarAccessiblePrivate GtkLevelBarAccessiblePrivate;/typedef struct _GtkLevelBarAccessiblePrivate{} GtkLevelBarAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkImageCellAccessiblePrivate GtkImageCellAccessiblePrivate;/typedef struct _GtkImageCellAccessiblePrivate{} GtkImageCellAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkImageAccessiblePrivate GtkImageAccessiblePrivate;/typedef struct _GtkImageAccessiblePrivate{} GtkImageAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkIconViewAccessiblePrivate GtkIconViewAccessiblePrivate;/typedef struct _GtkIconViewAccessiblePrivate{} GtkIconViewAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkFrameAccessiblePrivate GtkFrameAccessiblePrivate;/typedef struct _GtkFrameAccessiblePrivate{} GtkFrameAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkFlowBoxAccessiblePrivate GtkFlowBoxAccessiblePrivate;/typedef struct _GtkFlowBoxAccessiblePrivate{} GtkFlowBoxAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkExpanderAccessiblePrivate GtkExpanderAccessiblePrivate;/typedef struct _GtkExpanderAccessiblePrivate{} GtkExpanderAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkEntryAccessiblePrivate GtkEntryAccessiblePrivate;/typedef struct _GtkEntryAccessiblePrivate{} GtkEntryAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkContainerCellAccessiblePrivate GtkContainerCellAccessiblePrivate;/typedef struct _GtkContainerCellAccessiblePrivate{} GtkContainerCellAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkComboBoxAccessiblePrivate GtkComboBoxAccessiblePrivate;/typedef struct _GtkComboBoxAccessiblePrivate{} GtkComboBoxAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkCheckMenuItemAccessiblePrivate GtkCheckMenuItemAccessiblePrivate;/typedef struct _GtkCheckMenuItemAccessiblePrivate{} GtkCheckMenuItemAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkMenuItemAccessiblePrivate GtkMenuItemAccessiblePrivate;/typedef struct _GtkMenuItemAccessiblePrivate{} GtkMenuItemAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkButtonAccessiblePrivate GtkButtonAccessiblePrivate;/typedef struct _GtkButtonAccessiblePrivate{} GtkButtonAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkContainerAccessiblePrivate GtkContainerAccessiblePrivate;/typedef struct _GtkContainerAccessiblePrivate{} GtkContainerAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkBooleanCellAccessiblePrivate GtkBooleanCellAccessiblePrivate;/typedef struct _GtkBooleanCellAccessiblePrivate{} GtkBooleanCellAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkRendererCellAccessiblePrivate GtkRendererCellAccessiblePrivate;/typedef struct _GtkRendererCellAccessiblePrivate{} GtkRendererCellAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkCellAccessiblePrivate GtkCellAccessiblePrivate;/typedef struct _GtkCellAccessiblePrivate{} GtkCellAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkArrowAccessiblePrivate GtkArrowAccessiblePrivate;/typedef struct _GtkArrowAccessiblePrivate{} GtkArrowAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkWidgetAccessiblePrivate GtkWidgetAccessiblePrivate;/typedef struct _GtkWidgetAccessiblePrivate{} GtkWidgetAccessiblePrivate;/' $final
sed -i 's/typedef struct _GtkModelButton        GtkModelButton;/typedef struct _GtkModelButton{} GtkModelButton;/' $final

i='#define GTK_CONTAINER_WARN_INVALID_CHILD_PROPERTY_ID(object, property_id, pspec) \
    G_OBJECT_WARN_INVALID_PSPEC ((object), "child property", (property_id), (pspec))
'
j='#define GTK_CONTAINER_WARN_INVALID_CHILD_PROPERTY_ID(obj, property_id, pspec) \\
    G_OBJECT_WARN_INVALID_PSPEC ((obj), "child property", (property_id), (pspec))
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.h
i='#define GTK_CELL_AREA_WARN_INVALID_CELL_PROPERTY_ID(object, property_id, pspec) \
  G_OBJECT_WARN_INVALID_PSPEC ((object), "cell property id", (property_id), (pspec))
'
j='#define GTK_CELL_AREA_WARN_INVALID_CELL_PROPERTY_ID(obj, property_id, pspec) \\
  G_OBJECT_WARN_INVALID_PSPEC ((obj), "cell property id", (property_id), (pspec))
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.h

i='#define GTK_BUILDER_WARN_INVALID_CHILD_TYPE(object, type) \
  g_warning ("'%s' is not a valid child type of '%s'", type, g_type_name (G_OBJECT_TYPE (object)))
'
j='#define GTK_BUILDER_WARN_INVALID_CHILD_TYPE(obj, type) \\
  g_warning ("'%s' is not a valid child type of '%s'", type, g_type_name (G_OBJECT_TYPE (obj)))
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.h
# this is not really nice, because () is missing around identifier 3 times.
# c2nim > 0.10.2 should fix that automatically, so we can remove these patches
sed  -i "s/(object)/(obj)/g" $final # name is used in macros, but object is keyword

ruby ../fix_.rb $final

# GApplicationFlags missing from GIO, file gioenums.h
# header for Nim module
i='#ifdef __INCREASE_TMP_INDENT__
#ifdef C2NIM
#  dynlib lib
#endif

typedef enum
{
  G_APPLICATION_FLAGS_NONE,
  G_APPLICATION_IS_SERVICE  =          (1 << 0),
  G_APPLICATION_IS_LAUNCHER =          (1 << 1),

  G_APPLICATION_HANDLES_OPEN =         (1 << 2),
  G_APPLICATION_HANDLES_COMMAND_LINE = (1 << 3),
  G_APPLICATION_SEND_ENVIRONMENT    =  (1 << 4),

  G_APPLICATION_NON_UNIQUE =           (1 << 5)
} GApplicationFlags;

typedef void (*GAsyncReadyCallback) (GObject *source_object,
                                     GAsyncResult *res,
                                     gpointer user_data);
#endif
'
perl -0777 -p -i -e "s/^/$i/" $final

# avoid empty when: statement
i="\
#ifdef G_PLATFORM_WIN32
#include <gtk/gtkbox.h>
#include <gtk/gtkwindow.h>
#endif
"
perl -0777 -p -i -e "s%\Q$i\E%%s" final.h

i="\
#ifndef GDK_DISABLE_DEPRECATION_WARNINGS
#if GDK_VERSION_MIN_REQUIRED >= GDK_VERSION_3_10
G_DEPRECATED
#endif
#endif
"
perl -0777 -p -i -e "s%\Q$i\E%%s" final.h

i="\
#define gtk_major_version gtk_get_major_version ()
#define gtk_minor_version gtk_get_minor_version ()
#define gtk_micro_version gtk_get_micro_version ()
#define gtk_binary_age gtk_get_binary_age ()
#define gtk_interface_age gtk_get_interface_age ()
"
j="\
#define gtk_major_version() gtk_get_major_version ()
#define gtk_minor_version() gtk_get_minor_version ()
#define gtk_micro_version() gtk_get_micro_version ()
#define gtk_binary_age() gtk_get_binary_age ()
#define gtk_interface_age() gtk_get_interface_age ()
"
perl -0777 -p -i -e "s/\Q$i\E//s" final.h

# no direct bitfield support in nimrod
i="\
struct GtkAccelKey
{
  guint           accel_key;
  GdkModifierType accel_mods;
  guint           accel_flags : 16;
};
"
j="\
struct GtkAccelKey
{
  guint           accel_key;
  GdkModifierType accel_mods;
  guint           accel_flags;
};
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.h

i="\
struct GtkWidgetAuxInfo
{
  gint width;
  gint height;

  guint   halign : 4;
  guint   valign : 4;

  GtkBorder margin;
};
"
j="\
struct GtkWidgetAuxInfo
{
  gint width;
  gint height;
	guint bitfield0GtkWidgetAuxInfo;
  GtkBorder margin;
};
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.h

# remove these macros for now
i="\
#define gtk_widget_class_bind_template_callback(widget_class, callback) \\
  gtk_widget_class_bind_template_callback_full (GTK_WIDGET_CLASS (widget_class), \\
                                                #callback, \\
                                                G_CALLBACK (callback))
"
perl -0777 -p -i -e "s/\Q$i\E//s" final.h

i="\
#define gtk_widget_class_bind_template_child(widget_class, TypeName, member_name) \\
  gtk_widget_class_bind_template_child_full (widget_class, \\
                                             #member_name, \\
                                             FALSE, \\
                                             G_STRUCT_OFFSET (TypeName, member_name))
"
perl -0777 -p -i -e "s/\Q$i\E//s" final.h

i="\
#define gtk_widget_class_bind_template_child_internal(widget_class, TypeName, member_name) \\
  gtk_widget_class_bind_template_child_full (widget_class, \\
                                             #member_name, \\
                                             TRUE, \\
                                             G_STRUCT_OFFSET (TypeName, member_name))
"
perl -0777 -p -i -e "s/\Q$i\E//s" final.h

i="\
#define gtk_widget_class_bind_template_child_private(widget_class, TypeName, member_name) \\
  gtk_widget_class_bind_template_child_full (widget_class, \\
                                             #member_name, \\
                                             FALSE, \\
                                             G_PRIVATE_OFFSET (TypeName, member_name))
"
perl -0777 -p -i -e "s/\Q$i\E//s" final.h

i="\
#define gtk_widget_class_bind_template_child_internal_private(widget_class, TypeName, member_name) \\
  gtk_widget_class_bind_template_child_full (widget_class, \\
                                             #member_name, \\
                                             TRUE, \\
                                             G_PRIVATE_OFFSET (TypeName, member_name))
"
perl -0777 -p -i -e "s/\Q$i\E//s" final.h

# more bitfield
i="\
  \/*< private >*\/

  unsigned int _handle_border_width : 1;

  \/* Padding for future expansion *\/
  void (*_gtk_reserved1) (void);
"
j="\
  unsigned int _handle_border_width;
  void (*_gtk_reserved1) (void);
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.h

i="\
struct GtkMenuShellClass
{
  GtkContainerClass parent_class;

  guint submenu_placement : 1;

  void     (*deactivate)       (GtkMenuShell *menu_shell);
"
j="\
struct GtkMenuShellClass
{
  GtkContainerClass parent_class;
  guint submenu_placement;
  void     (*deactivate)       (GtkMenuShell *menu_shell);
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.h

i="\
struct GtkTextAppearance
{
  /*< public >*/
  GdkColor bg_color;
  GdkColor fg_color;

  /* super/subscript rise, can be negative */
  gint rise;

  guint underline : 4;          /* PangoUnderline */
  guint strikethrough : 1;

  /* Whether to use background-related values; this is irrelevant for
   * the values struct when in a tag, but is used for the composite
   * values struct; it's true if any of the tags being composited
   * had background stuff set.
   */
  guint draw_bg : 1;

  /* These are only used when we are actually laying out and rendering
   * a paragraph; not when a GtkTextAppearance is part of a
   * GtkTextAttributes.
   */
  guint inside_selection : 1;
  guint is_text : 1;

  /* For the sad story of this bit of code, see
   * https://bugzilla.gnome.org/show_bug.cgi?id=711158
   */
#ifdef __GI_SCANNER__
  /* The scanner should only see the transparent union, so that its
   * content does not vary across architectures.
   */
  union {
    GdkRGBA *rgba[2];
    /*< private >*/
    guint padding[4];
  };
#else
  GdkRGBA *rgba[2];
#if (defined(__SIZEOF_INT__) && defined(__SIZEOF_POINTER__)) && (__SIZEOF_INT__ == __SIZEOF_POINTER__)
  /* unusable, just for ABI compat */
  /*< private >*/
  guint padding[2];
#endif
#endif
};
"
j="\
struct GtkTextAppearance
{
  GdkColor bg_color;
  GdkColor fg_color;
  gint rise;
  guint bitfield0_GtkTextAppearance;
  GdkRGBA *rgba[2];
};
"
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.h

i='struct GtkTextAttributes
{
  /*< private >*/
  guint refcount;

  /*< public >*/
  GtkTextAppearance appearance;

  GtkJustification justification;
  GtkTextDirection direction;

  PangoFontDescription *font;

  gdouble font_scale;

  gint left_margin;
  gint right_margin;
  gint indent;

  gint pixels_above_lines;
  gint pixels_below_lines;
  gint pixels_inside_wrap;

  PangoTabArray *tabs;

  GtkWrapMode wrap_mode;

  PangoLanguage *language;

  /*< private >*/
  GdkColor *pg_bg_color;

  /*< public >*/
  guint invisible : 1;
  guint bg_full_height : 1;
  guint editable : 1;
  guint no_fallback: 1;

  /*< private >*/
  GdkRGBA *pg_bg_rgba;

  /*< public >*/
  gint letter_spacing;

  /*< private >*/
  guint padding[2];
};
'
j='struct GtkTextAttributes
{
  guint refcount;
  GtkTextAppearance appearance;
  GtkJustification justification;
  GtkTextDirection direction;
  PangoFontDescription *font;
  gdouble font_scale;
  gint left_margin;
  gint right_margin;
  gint indent;
  gint pixels_above_lines;
  gint pixels_below_lines;
  gint pixels_inside_wrap;
  PangoTabArray *tabs;
  GtkWrapMode wrap_mode;
  PangoLanguage *language;
  GdkColor *pg_bg_color;
	guint bitfield0GtkTextAttributes;
  GdkRGBA *pg_bg_rgba;
  gint letter_spacing;
  guint padding[2];
};
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.h

i="\
struct GtkBindingSet
{
  gchar           *set_name;
  gint             priority;
  GSList          *widget_path_pspecs;
  GSList          *widget_class_pspecs;
  GSList          *class_branch_pspecs;
  GtkBindingEntry *entries;
  GtkBindingEntry *current;
  guint            parsed : 1;
};
"
j="\
struct GtkBindingSet
{
  gchar           *set_name;
  gint             priority;
  GSList          *widget_path_pspecs;
  GSList          *widget_class_pspecs;
  GSList          *class_branch_pspecs;
  GtkBindingEntry *entries;
  GtkBindingEntry *current;
  guint            parsed;
};
"
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.h

i="\
struct GtkBindingEntry
{
  /* key portion */
  guint             keyval;
  GdkModifierType   modifiers;

  GtkBindingSet    *binding_set;
  guint             destroyed     : 1;
  guint             in_emission   : 1;
  guint             marks_unbound : 1;
  GtkBindingEntry  *set_next;
  GtkBindingEntry  *hash_next;
  GtkBindingSignal *signals;
};
"
j="\
struct GtkBindingEntry
{
  guint             keyval;
  GdkModifierType   modifiers;
  GtkBindingSet    *binding_set;
  guint             bitfield0GtkBindingEntry;
  GtkBindingEntry  *set_next;
  GtkBindingEntry  *hash_next;
  GtkBindingSignal *signals;
};
"
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.h

i="\
struct GtkMenuItemClass
{
  GtkBinClass parent_class;

  /*< public >*/

  /* If the following flag is true, then we should always
   * hide the menu when the MenuItem is activated. Otherwise,
   * it is up to the caller. For instance, when navigating
   * a menu with the keyboard, <Space> doesn't hide, but
   * <Return> does.
   */
  guint hide_on_activate : 1;

  void (* activate)             (GtkMenuItem *menu_item);
"
j="\
struct GtkMenuItemClass
{
  GtkBinClass parent_class;
  guint hide_on_activate;
  void (* activate)             (GtkMenuItem *menu_item);
"
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.h

i="\
#ifdef G_ENABLE_DEBUG

#define GTK_NOTE(type,action)                G_STMT_START { \\
    if (gtk_get_debug_flags () & GTK_DEBUG_##type)		    \\
       { action; };                          } G_STMT_END

#else /* !G_ENABLE_DEBUG */

#define GTK_NOTE(type, action)

#endif /* G_ENABLE_DEBUG */
"
perl -0777 -p -i -e "s%\Q$i\E%%s" final.h

i="\
  GSList *icon_factories;

  guint engine_specified : 1;   /* The RC file specified the engine */
};
"
j="\
  GSList *icon_factories;
  guint engine_specified;
};
"
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.h

i="\
struct GtkTableChild
{
  GtkWidget *widget;
  guint16 left_attach;
  guint16 right_attach;
  guint16 top_attach;
  guint16 bottom_attach;
  guint16 xpadding;
  guint16 ypadding;
  guint xexpand : 1;
  guint yexpand : 1;
  guint xshrink : 1;
  guint yshrink : 1;
  guint xfill : 1;
  guint yfill : 1;
};

struct GtkTableRowCol
{
  guint16 requisition;
  guint16 allocation;
  guint16 spacing;
  guint need_expand : 1;
  guint need_shrink : 1;
  guint expand : 1;
  guint shrink : 1;
  guint empty : 1;
};
"
j="\
struct GtkTableChild
{
  GtkWidget *widget;
  guint16 left_attach;
  guint16 right_attach;
  guint16 top_attach;
  guint16 bottom_attach;
  guint16 xpadding;
  guint16 ypadding;
  guint bitfield0GtkTableChild;
};

struct GtkTableRowCol
{
  guint16 requisition;
  guint16 allocation;
  guint16 spacing;
  guint bitfield0GtkTableRowCol;
};
"
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.h

# proc aliases without real benefit
sed -i '/\s*#define GTK_RECENT_MANAGER_ERROR/d' final.h
sed -i '/\s*#define GTK_RECENT_CHOOSER_ERROR/d' final.h
sed -i '/\s*#define GTK_BUILDER_ERROR/d' final.h
sed -i '/\s*#define GTK_CSS_PROVIDER_ERROR/d' final.h
sed -i '/\s*#define GTK_FILE_CHOOSER_ERROR/d' final.h
sed -i '/\s*#define GTK_ICON_THEME_ERROR/d' final.h
sed -i '/\s*#define GTK_PRINT_ERROR/d' final.h

ruby ../fix_gtk_type.rb final.h GTK_
c2nim096 --skipcomments --skipinclude $final
sed -i -f gtk_type_sedlist final.nim

perl -0777 -p -i -e "s~([=:] proc \(.*?\)(?:: (?:ptr )?\w+)?)~\1 {.cdecl.}~sg" final.nim

# we use our own defined pragma
sed -i "s/\bdynlib: lib\b/libgtk/g" final.nim

ruby ../remdef.rb final.nim

i='const 
  headerfilename* = '
perl -0777 -p -i -e "s~\Q$i\E~  ### ~sg" final.nim

sed -i '1d' final.nim
sed -i 's/^  //' final.nim

i=' {.deadCodeElim: on.}'
j='{.deadCodeElim: on.}

when defined(windows): 
  const LIB_GTK* = "libgtk-win32-3.0-0.dll"
elif defined(gtk_quartz):
  const LIB_GTK* = "libgtk-3.0.dylib"
elif defined(macosx):
  const LIB_GTK* = "libgtk-x11-3.0.dylib"
else: 
  const LIB_GTK* = "libgtk-3.so(|.0)"

{.pragma: libgtk, cdecl, dynlib: LIB_GTK.}

IMPORTLIST

const
  GDK_MULTIHEAD_SAFE = true
  GTK_DISABLE_DEPRECATED = false

'
perl -0777 -p -i -e "s~\Q$i\E~$j~s" final.nim

sed  -i 's/  GtkAllocation\* = GdkRectangle/  GtkAllocation* = object /' final.nim

ruby ../glib_fix_T.rb final.nim gtk3 Gtk
ruby ../fix_new.rb final.nim
ruby ../glib_fix_proc.rb final.nim
sed -i 's/\bGTK_PRINT_CAPABILITY_/GTK_PRINT_CAPABILITIES_/g' final.nim
sed -i 's/\bGTK_INPUT_HINT_/GTK_INPUT_HINTS_/g' final.nim
ruby ../glib_fix_enum_prefix.rb final.nim

sed  -i 's/  GtkAllocationObj\* = object /  GtkAllocationObj\* = GdkRectangle/' final.nim

# procs starting with underscore should be privat -- and for two we would get a name conflict...
perl -0777 -p -i -e "s~proc _\w+\*?\(.*?\}~~sg" final.nim

ruby ../underscorefix.rb final.nim

sed -i -f ../glib_sedlist final.nim
sed -i -f ../gobject_sedlist final.nim
sed -i -f ../cairo_sedlist final.nim
sed -i -f ../pango_sedlist final.nim
sed -i -f ../gdk_pixbuf_sedlist final.nim
sed -i -f ../gdk3_sedlist final.nim
sed -i -f ../gio_sedlist final.nim
sed -i -f ../atk_sedlist final.nim

ruby ../fix_template.rb final.nim

ruby ../fix_object_of.rb final.nim
ruby ../fix_reserved.rb final.nim

# do not export priv and reserved
sed -i "s/\( priv[0-9]\?[0-9]\?[0-9]\?\)\*: /\1: /g" final.nim
sed -i "s/\(reserved[0-9]\?[0-9]\?[0-9]\?\)\*: /\1: /g" final.nim

i='type 
  GtkUnit* {.size: sizeof(cint), pure.} = enum 
    NONE, POINTS, INCH, MM
const 
  GTK_UNIT_PIXEL* = GTK_UNIT_NONE
'
j='type 
  GtkUnit* {.size: sizeof(cint), pure.} = enum 
    NONE, POINTS, INCH, MM
const 
  GTK_UNIT_PIXEL* = GtkUnit.NONE
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkJunctionSides* {.size: sizeof(cint), pure.} = enum 
    NONE = 0, CORNER_TOPLEFT = 1 shl 0, 
    CORNER_TOPRIGHT = 1 shl 1, 
    CORNER_BOTTOMLEFT = 1 shl 2, 
    CORNER_BOTTOMRIGHT = 1 shl 3, TOP = (
        CORNER_TOPLEFT or CORNER_TOPRIGHT), BOTTOM = (
        CORNER_BOTTOMLEFT or CORNER_BOTTOMRIGHT), LEFT = (
        CORNER_TOPLEFT or CORNER_BOTTOMLEFT), RIGHT = (
        CORNER_TOPRIGHT or CORNER_BOTTOMRIGHT)
'
j='type 
  GtkJunctionSides* {.size: sizeof(cint), pure.} = enum 
    NONE = 0,
    CORNER_TOPLEFT = 1 shl 0, 
    CORNER_TOPRIGHT = 1 shl 1, 
    TOP = (GtkJunctionSides.CORNER_TOPLEFT.ord or GtkJunctionSides.CORNER_TOPRIGHT.ord),
    CORNER_BOTTOMLEFT = 1 shl 2, 
    LEFT = (GtkJunctionSides.CORNER_TOPLEFT.ord or GtkJunctionSides.CORNER_BOTTOMLEFT.ord),
    CORNER_BOTTOMRIGHT = 1 shl 3,
    RIGHT = (GtkJunctionSides.CORNER_TOPRIGHT.ord or GtkJunctionSides.CORNER_BOTTOMRIGHT.ord),
    BOTTOM = (GtkJunctionSides.CORNER_BOTTOMLEFT.ord or GtkJunctionSides.CORNER_BOTTOMRIGHT.ord)
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='
type 
  GtkAccelGroupPrivateObj = object 
  
  GtkAccelGroupActivate* = proc (accel_group: GtkAccelGroup; 
                                 acceleratable: gobject.GObject; keyval: guint; 
                                 modifier: GdkModifierType): gboolean {.cdecl.}
type 
  GtkAccelGroupFindFunc* = proc (key: GtkAccelKey; closure: gobject.GClosure; 
                                 data: gpointer): gboolean {.cdecl.}
type 
  GtkAccelGroup* =  ptr GtkAccelGroupObj
  GtkAccelGroupPtr* = ptr GtkAccelGroupObj
  GtkAccelGroupObj*{.final.} = object of gobject.GObjectObj
    priv1: ptr GtkAccelGroupPrivateObj

type 
  GtkAccelGroupClass* =  ptr GtkAccelGroupClassObj
  GtkAccelGroupClassPtr* = ptr GtkAccelGroupClassObj
  GtkAccelGroupClassObj*{.final.} = object of gobject.GObjectClassObj
    accel_changed*: proc (accel_group: GtkAccelGroup; keyval: guint; 
                          modifier: GdkModifierType; 
                          accel_closure: gobject.GClosure) {.cdecl.}
    gtk_reserved11: proc () {.cdecl.}
    gtk_reserved12: proc () {.cdecl.}
    gtk_reserved13: proc () {.cdecl.}
    gtk_reserved14: proc () {.cdecl.}

type 
  GtkAccelKey* =  ptr GtkAccelKeyObj
'
j='
type 
  GtkAccelGroupPrivateObj = object 
  
  GtkAccelGroupActivate* = proc (accel_group: GtkAccelGroup; 
                                 acceleratable: gobject.GObject; keyval: guint; 
                                 modifier: GdkModifierType): gboolean {.cdecl.}
#type 
  GtkAccelGroupFindFunc* = proc (key: GtkAccelKey; closure: gobject.GClosure; 
                                 data: gpointer): gboolean {.cdecl.}
#type 
  GtkAccelGroup* =  ptr GtkAccelGroupObj
  GtkAccelGroupPtr* = ptr GtkAccelGroupObj
  GtkAccelGroupObj*{.final.} = object of gobject.GObjectObj
    priv1: ptr GtkAccelGroupPrivateObj

#type 
  GtkAccelGroupClass* =  ptr GtkAccelGroupClassObj
  GtkAccelGroupClassPtr* = ptr GtkAccelGroupClassObj
  GtkAccelGroupClassObj*{.final.} = object of gobject.GObjectClassObj
    accel_changed*: proc (accel_group: GtkAccelGroup; keyval: guint; 
                          modifier: GdkModifierType; 
                          accel_closure: gobject.GClosure) {.cdecl.}
    gtk_reserved11: proc () {.cdecl.}
    gtk_reserved12: proc () {.cdecl.}
    gtk_reserved13: proc () {.cdecl.}
    gtk_reserved14: proc () {.cdecl.}

#type 
  GtkAccelKey* =  ptr GtkAccelKeyObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

# these enums are not covered by gdk3_sedlist -- that is OK, because it are enums :-)
sed  -i "s/PangoDirection/pango.Direction/g" final.nim
sed  -i "s/PangoWrapMode/pango.WrapMode/g" final.nim
sed  -i "s/PangoEllipsizeMode/pango.EllipsizeMode/g" final.nim
sed  -i "s/GdkModifierType/gdk3.ModifierType/g" final.nim
sed  -i "s/GdkEventMask/gdk3.EventMask/g" final.nim
sed  -i "s/GdkModifierIntent/gdk3.ModifierIntent/g" final.nim
sed  -i "s/GdkWindowTypeHint/gdk3.WindowTypeHint/g" final.nim
sed  -i "s/GdkGravity/gdk3.Gravity/g" final.nim
sed  -i "s/GdkWindowHints/gdk3.WindowHints/g" final.nim
sed  -i "s/GdkWindowEdge/gdk3.WindowEdge/g" final.nim
sed  -i "s/GdkDragAction/gdk3.DragAction/g" final.nim
sed  -i "s/GdkDragProtocol/gdk3.DragProtocol/g" final.nim
sed  -i "s/GdkGLProfile/gdk3.GLProfile/g" final.nim
sed  -i "s/AtkRole/atk.Role/g" final.nim
sed  -i "s/AtkCoordType/atk.CoordType/g" final.nim

# and this Atom is a special pointer -- also not covered by sedlist
sed  -i "s/GdkAtom/gdk3.Atom/g" final.nim

sed -i 's/(object: /(`object`: /g' final.nim
sed -i 's/; object: /; `object`: /g' final.nim

i='proc query*(accel_group: GtkAccelGroup; accel_key: guint; 
                            accel_mods: gdk3.ModifierType; n_entries: ptr guint): GtkAccelGroupEntry {.
    importc: "gtk_accel_group_query", libgtk.}
type 
  GtkAccelGroupEntry* =  ptr GtkAccelGroupEntryObj
  GtkAccelGroupEntryPtr* = ptr GtkAccelGroupEntryObj
  GtkAccelGroupEntryObj* = object 
    key*: GtkAccelKeyObj
    closure*: gobject.GClosure
    accel_path_quark*: GQuark
'
j='type 
  GtkAccelGroupEntry* =  ptr GtkAccelGroupEntryObj
  GtkAccelGroupEntryPtr* = ptr GtkAccelGroupEntryObj
  GtkAccelGroupEntryObj* = object 
    key*: GtkAccelKeyObj
    closure*: gobject.GClosure
    accel_path_quark*: GQuark

proc query*(accel_group: GtkAccelGroup; accel_key: guint; 
                            accel_mods: gdk3.ModifierType; n_entries: ptr guint): GtkAccelGroupEntry {.
    importc: "gtk_accel_group_query", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkBuilderPrivateObj = object 
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
j='type 
  GtkBuilder* =  ptr GtkBuilderObj
  GtkBuilderPtr* = ptr GtkBuilderObj
  GtkBuilderObj*{.final.} = object of gobject.GObjectObj
    priv39: ptr GtkBuilderPrivateObj
'
perl -0777 -p -i -e "s%\Q$j\E%%s" final.nim

k='type 
  GtkClipboard* =  ptr GtkClipboardObj
  GtkClipboardPtr* = ptr GtkClipboardObj
  GtkClipboardObj* = object 
'
perl -0777 -p -i -e "s%\Q$k\E%$i$j$k%s" final.nim

i='type 
  GtkAllocation* =  ptr GtkAllocationObj
  GtkAllocationPtr* = ptr GtkAllocationObj
  GtkAllocationObj* = gdk3.RectangleObj
type 
  GtkCallback* = proc (widget: GtkWidget; data: gpointer) {.cdecl.}
type 
  GtkTickCallback* = proc (widget: GtkWidget; 
                           frame_clock: gdk3.FrameClock; user_data: gpointer): gboolean {.cdecl.}
type 
  GtkRequisition* =  ptr GtkRequisitionObj
  GtkRequisitionPtr* = ptr GtkRequisitionObj
  GtkRequisitionObj* = object 
    width*: gint
    height*: gint

type 
  GtkWidget* =  ptr GtkWidgetObj
  GtkWidgetPtr* = ptr GtkWidgetObj
  GtkWidgetObj*{.final.} = object of gobject.GInitiallyUnownedObj
    priv2: ptr GtkWidgetPrivateObj
'
j='type 
  GtkWidget* =  ptr GtkWidgetObj
  GtkWidgetPtr* = ptr GtkWidgetObj
  GtkWidgetObj* = object of gobject.GInitiallyUnownedObj
    priv2: ptr GtkWidgetPrivateObj
type 
  GtkAllocation* =  ptr GtkAllocationObj
  GtkAllocationPtr* = ptr GtkAllocationObj
  GtkAllocationObj* = gdk3.RectangleObj
type 
  GtkCallback* = proc (widget: GtkWidget; data: gpointer) {.cdecl.}
type 
  GtkTickCallback* = proc (widget: GtkWidget; 
                           frame_clock: gdk3.FrameClock; user_data: gpointer): gboolean {.cdecl.}
type 
  GtkRequisition* =  ptr GtkRequisitionObj
  GtkRequisitionPtr* = ptr GtkRequisitionObj
  GtkRequisitionObj* = object 
    width*: gint
    height*: gint
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkStyle* =  ptr GtkStyleObj
  GtkStylePtr* = ptr GtkStyleObj
  GtkStyleObj*{.final.} = object of gobject.GObjectObj
    fg*: array[5, gdk3.ColorObj]
    bg*: array[5, gdk3.ColorObj]
    light*: array[5, gdk3.ColorObj]
    dark*: array[5, gdk3.ColorObj]
    mid*: array[5, gdk3.ColorObj]
    text*: array[5, gdk3.ColorObj]
    base*: array[5, gdk3.ColorObj]
    text_aa*: array[5, gdk3.ColorObj]
    black*: gdk3.ColorObj
    white*: gdk3.ColorObj
    font_desc*: pango.FontDescription
    xthickness*: gint
    ythickness*: gint
    background*: array[5, cairo.Pattern]
    attach_count*: gint
    visual*: gdk3.Visual
    private_font_desc*: pango.FontDescription
    rc_style*: GtkRcStyle
    styles*: glib.GSList
    property_cache*: glib.GArray
    icon_factories*: glib.GSList
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
j='type 
  GtkRcFlags* {.size: sizeof(cint), pure.} = enum 
    FG = 1 shl 0, BG = 1 shl 1, TEXT = 1 shl 2, 
    BASE = 1 shl 3
type 
  GtkRcStyle* =  ptr GtkRcStyleObj
  GtkRcStylePtr* = ptr GtkRcStyleObj
  GtkRcStyleObj*{.final.} = object of gobject.GObjectObj
    name*: ptr gchar
    bg_pixmap_name*: array[5, ptr gchar]
    font_desc*: pango.FontDescription
    color_flags*: array[5, GtkRcFlags]
    fg*: array[5, gdk3.ColorObj]
    bg*: array[5, gdk3.ColorObj]
    text*: array[5, gdk3.ColorObj]
    base*: array[5, gdk3.ColorObj]
    xthickness*: gint
    ythickness*: gint
    rc_properties*: glib.GArray
    rc_style_lists*: glib.GSList
    icon_factories*: glib.GSList
    engine_specified*: guint
'
perl -0777 -p -i -e "s%\Q$j\E%%s" final.nim
k='
type 
  GtkRequisition* =  ptr GtkRequisitionObj
  GtkRequisitionPtr* = ptr GtkRequisitionObj
  GtkRequisitionObj* = object 
    width*: gint
    height*: gint
'
perl -0777 -p -i -e "s%\Q$k\E%$k$j$i%s" final.nim

sed -i 's/\bout: /`out`: /g' final.nim
sed -i 's/\bin\*: /`in`\*: /g' final.nim
sed -i 's/\bproc raise\b/proc `raise`/g' final.nim

sed -i 's/\bptr: /`ptr`: /g' final.nim
sed -i 's/\btype: /`type`: /g' final.nim
sed -i 's/\btype\*: /`type`\*: /g' final.nim

sed -i 's/^proc ref\*(/proc `ref`\*(/g' final.nim

i='type 
  GtkSettingsPrivateObj = object 
  
type 
  GtkSettings* =  ptr GtkSettingsObj
  GtkSettingsPtr* = ptr GtkSettingsObj
  GtkSettingsObj*{.final.} = object of gobject.GObjectObj
    priv111: ptr GtkSettingsPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
j='
type 
  GtkWidgetHelpType* {.size: sizeof(cint), pure.} = enum 
    TOOLTIP, WHATS_THIS
'
perl -0777 -p -i -e "s%\Q$j\E%$i$j%s" final.nim

i='type 
  GtkWindowPrivateObj = object 
  
  GtkWindowGroupPrivateObj = object 
  
type 
  GtkWindow* =  ptr GtkWindowObj
  GtkWindowPtr* = ptr GtkWindowObj
  GtkWindowObj* = object 
    bin*: GtkBinObj
    priv7: ptr GtkWindowPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
j='type 
  GtkBinPrivateObj = object 
  
type 
  GtkBin* =  ptr GtkBinObj
  GtkBinPtr* = ptr GtkBinObj
  GtkBinObj* = object 
    container*: GtkContainerObj
    priv6: ptr GtkBinPrivateObj
'
perl -0777 -p -i -e "s%\Q$j\E%%s" final.nim
k='type 
  GtkContainerPrivateObj = object 
  
type 
  GtkContainer* =  ptr GtkContainerObj
  GtkContainerPtr* = ptr GtkContainerObj
  GtkContainerObj* = object 
    widget*: GtkWidgetObj
    priv5: ptr GtkContainerPrivateObj
'
perl -0777 -p -i -e "s%\Q$k\E%%s" final.nim
l='type 
  GtkWidgetAuxInfo* =  ptr GtkWidgetAuxInfoObj
  GtkWidgetAuxInfoPtr* = ptr GtkWidgetAuxInfoObj
  GtkWidgetAuxInfoObj* = object 
    width*: gint
    height*: gint
    bitfield0GtkWidgetAuxInfo*: guint
    margin*: GtkBorderObj
'
perl -0777 -p -i -e "s%\Q$l\E%$l$k$j$i%s" final.nim
j='type 
  GtkStyleContextPrivateObj = object 
  
type 
  GtkStyleContext* =  ptr GtkStyleContextObj
  GtkStyleContextPtr* = ptr GtkStyleContextObj
  GtkStyleContextObj*{.final.} = object of gobject.GObjectObj
    priv73: ptr GtkStyleContextPrivateObj
'
perl -0777 -p -i -e "s%\Q$j\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$i\E%$i$j%s" final.nim

i='type 
  GtkAdjustmentPrivateObj = object 
  
type 
  GtkAdjustment* =  ptr GtkAdjustmentObj
  GtkAdjustmentPtr* = ptr GtkAdjustmentObj
  GtkAdjustmentObj*{.final.} = object of gobject.GInitiallyUnownedObj
    priv16: ptr GtkAdjustmentPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$j\E%$j$i%s" final.nim

# fix non final objects
sed  -i "s/GtkWidgetClassObj\*{\.final\.} = object of/GtkWidgetClassObj = object of/" final.nim
sed  -i "s/GtkContainerClassObj\*{\.final\.} = object of/GtkContainerClassObj = object of/" final.nim
sed  -i "s/GtkBinClassObj\*{\.final\.} = object of/GtkBinClassObj* = object of/" final.nim
sed  -i "s/GtkBoxClassObj\*{\.final\.} = object of/GtkBoxClassObj = object of/" final.nim
sed  -i "s/GtkWindowClassObj\*{\.final\.} = object of/GtkWindowClassObj* = object of/" final.nim
sed  -i "s/GtkDialogClassObj\*{\.final\.} = object of/GtkDialogClassObj = object of/" final.nim
sed  -i "s/GtkLabelClassObj\*{\.final\.} = object of/GtkLabelClassObj = object of/" final.nim
sed  -i "s/GtkMiscClassObj\*{\.final\.} = object of/GtkMiscClassObj = object of/" final.nim
sed  -i "s/GtkMenuShellClassObj\*{\.final\.} = object of/GtkMenuShellClassObj = object of/" final.nim
sed  -i "s/GtkComboBoxObj\*{\.final\.} = object of/GtkComboBoxObj = object of/" final.nim
sed  -i "s/GtkComboBoxClassObj\*{\.final\.} = object of/GtkComboBoxClassObj = object of/" final.nim
sed  -i "s/GtkFrameClassObj\*{\.final\.} = object of/GtkFrameClassObj = object of/" final.nim
sed  -i "s/GtkCellAreaObj\*{\.final\.} = object of/GtkCellAreaObj = object of/" final.nim
sed  -i "s/GtkCellAreaClassObj\*{\.final\.} = object of/GtkCellAreaClassObj = object of/" final.nim
sed  -i "s/GtkCellRendererObj\*{\.final\.} = object of/GtkCellRendererObj = object of/" final.nim
sed  -i "s/GtkCellRendererClassObj\*{\.final\.} = object of/GtkCellRendererClassObj = object of/" final.nim
sed  -i "s/GtkCellRendererTextObj\*{\.final\.} = object of/GtkCellRendererTextObj = object of/" final.nim
sed  -i "s/GtkCellRendererTextClassObj\*{\.final\.} = object of/GtkCellRendererTextClassObj = object of/" final.nim
sed  -i "s/GtkButtonClassObj\*{\.final\.} = object of/GtkButtonClassObj* = object of/" final.nim
sed  -i "s/GtkTextMarkObj\*{\.final\.} = object of/GtkTextMarkObj* = object of/" final.nim
sed  -i "s/GtkTextMarkClassObj\*{\.final\.} = object of/GtkTextMarkClassObj* = object of/" final.nim
sed  -i "s/GtkTextBufferClassObj\*{\.final\.} = object of/GtkTextBufferClassObj* = object of/" final.nim
sed  -i "s/GtkTextViewObj\*{\.final\.} = object of/GtkTextViewObj* = object of/" final.nim
sed  -i "s/GtkTextViewClassObj\*{\.final\.} = object of/GtkTextViewClassObj* = object of/" final.nim
sed  -i "s/GtkButtonBoxClassObj\*{\.final\.} = object of/GtkButtonBoxClassObj = object of/" final.nim
sed  -i "s/GtkPanedClassObj\*{\.final\.} = object of/GtkPanedClassObj = object of/" final.nim
sed  -i "s/GtkToggleButtonClassObj\*{\.final\.} = object of/GtkToggleButtonClassObj = object of/" final.nim
sed  -i "s/GtkScaleButtonObj\*{\.final\.} = object of/GtkScaleButtonObj = object of/" final.nim
sed  -i "s/GtkScaleButtonClassObj\*{\.final\.} = object of/GtkScaleButtonClassObj = object of/" final.nim
sed  -i "s/GtkScaleClassObj\*{\.final\.} = object of/GtkScaleClassObj = object of/" final.nim
sed  -i "s/GtkToggleToolButtonClassObj\*{\.final\.} = object of/GtkToggleToolButtonClassObj = object of/" final.nim
sed  -i "s/GtkToggleToolButtonObj\*{\.final\.} = object of/GtkToggleToolButtonObj = object of/" final.nim
sed  -i "s/GtkCheckButtonClassObj\*{\.final\.} = object of/GtkCheckButtonClassObj = object of/" final.nim
sed  -i "s/GtkMenuItemClassObj\*{\.final\.} = object of/GtkMenuItemClassObj = object of/" final.nim
sed  -i "s/GtkMenuClassObj\*{\.final\.} = object of/GtkMenuClassObj = object of/" final.nim
sed  -i "s/GtkCheckMenuItemClassObj\*{\.final\.} = object of/GtkCheckMenuItemClassObj = object of/" final.nim
sed  -i "s/GtkIMContextObj\*{\.final\.} = object of/GtkIMContextObj = object of/" final.nim
sed  -i "s/GtkIMContextClassObj\*{\.final\.} = object of/GtkIMContextClassObj = object of/" final.nim
sed  -i "s/GtkToolItemObj\*{\.final\.} = object of/GtkToolItemObj = object of/" final.nim
sed  -i "s/GtkToolItemClassObj\*{\.final\.} = object of/GtkToolItemClassObj = object of/" final.nim
sed  -i "s/GtkToolButtonObj\*{\.final\.} = object of/GtkToolButtonObj = object of/" final.nim
sed  -i "s/GtkToolButtonClassObj\*{\.final\.} = object of/GtkToolButtonClassObj = object of/" final.nim
sed  -i "s/GtkPopoverClassObj\*{\.final\.} = object of/GtkPopoverClassObj = object of/" final.nim
sed  -i "s/GtkRangeClassObj\*{\.final\.} = object of/GtkRangeClassObj = object of/" final.nim
sed  -i "s/GtkEntryObj\*{\.final\.} = object of/GtkEntryObj = object of/" final.nim
sed  -i "s/GtkEntryClassObj\*{\.final\.} = object of/GtkEntryClassObj = object of/" final.nim
sed  -i "s/GtkScrollbarClassObj\*{\.final\.} = object of/GtkScrollbarClassObj = object of/" final.nim
sed  -i "s/GtkSeparatorClassObj\*{\.final\.} = object of/GtkSeparatorClassObj = object of/" final.nim
sed  -i "s/GtkActionClassObj\*{\.final\.} = object of/GtkActionClassObj = object of/" final.nim
sed  -i "s/GtkToggleActionObj\*{\.final\.} = object of/GtkToggleActionObj = object of/" final.nim
sed  -i "s/GtkToggleActionClassObj\*{\.final\.} = object of/GtkToggleActionClassObj = object of/" final.nim
sed  -i "s/GtkAccessibleObj\*{\.final\.} = object of/GtkAccessibleObj = object of/" final.nim
sed  -i "s/GtkAccessibleClassObj\*{\.final\.} = object of/GtkAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkWidgetAccessibleObj\*{\.final\.} = object of/GtkWidgetAccessibleObj = object of/" final.nim
sed  -i "s/GtkWidgetAccessibleClassObj\*{\.final\.} = object of/GtkWidgetAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkCellAccessibleObj\*{\.final\.} = object of/GtkCellAccessibleObj = object of/" final.nim
sed  -i "s/GtkCellAccessibleClassObj\*{\.final\.} = object of/GtkCellAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkRendererCellAccessibleObj\*{\.final\.} = object of/GtkRendererCellAccessibleObj = object of/" final.nim
sed  -i "s/GtkRendererCellAccessibleClassObj\*{\.final\.} = object of/GtkRendererCellAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkContainerAccessibleObj\*{\.final\.} = object of/GtkContainerAccessibleObj = object of/" final.nim
sed  -i "s/GtkContainerAccessibleClassObj\*{\.final\.} = object of/GtkContainerAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkMenuItemAccessibleObj\*{\.final\.} = object of/GtkMenuItemAccessibleObj = object of/" final.nim
sed  -i "s/GtkMenuItemAccessibleClassObj\*{\.final\.} = object of/GtkMenuItemAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkCheckMenuItemAccessibleObj\*{\.final\.} = object of/GtkCheckMenuItemAccessibleObj = object of/" final.nim
sed  -i "s/GtkCheckMenuItemAccessibleClassObj\*{\.final\.} = object of/GtkCheckMenuItemAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkButtonAccessibleClassObj\*{\.final\.} = object of/GtkButtonAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkToggleButtonAccessibleObj\*{\.final\.} = object of/GtkToggleButtonAccessibleObj = object of/" final.nim
sed  -i "s/GtkToggleButtonAccessibleClassObj\*{\.final\.} = object of/GtkToggleButtonAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkButtonAccessibleObj\*{\.final\.} = object of/GtkButtonAccessibleObj = object of/" final.nim
sed  -i "s/GtkMenuShellAccessibleObj\*{\.final\.} = object of/GtkMenuShellAccessibleObj = object of/" final.nim
sed  -i "s/GtkMenuShellAccessibleClassObj\*{\.final\.} = object of/GtkMenuShellAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkRangeAccessibleObj\*{\.final\.} = object of/GtkRangeAccessibleObj = object of/" final.nim
sed  -i "s/GtkRangeAccessibleClassObj\*{\.final\.} = object of/GtkRangeAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkEntryAccessibleObj\*{\.final\.} = object of/GtkEntryAccessibleObj = object of/" final.nim
sed  -i "s/GtkEntryAccessibleClassObj\*{\.final\.} = object of/GtkEntryAccessibleClassObj = object of/" final.nim
sed  -i "s/GtkMiscObj\*{\.final\.} = object of/GtkMiscObj = object of/" final.nim

i='type 
  GtkWindowGroup* =  ptr GtkWindowGroupObj
  GtkWindowGroupPtr* = ptr GtkWindowGroupObj
  GtkWindowGroupObj*{.final.} = object of gobject.GObjectObj
    priv126: ptr GtkWindowGroupPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
j='type 
  GtkWindowPrivateObj = object 
  
  GtkWindowGroupPrivateObj = object 
'
perl -0777 -p -i -e "s%\Q$j\E%$j$i%s" final.nim

i='type 
  GtkWindow* =  ptr GtkWindowObj
  GtkWindowPtr* = ptr GtkWindowObj
  GtkWindowObj* = object 
    bin*: GtkBinObj
    priv7: ptr GtkWindowPrivateObj
'
j='type 
  GtkWindow* =  ptr GtkWindowObj
  GtkWindowPtr* = ptr GtkWindowObj
  GtkWindowObj* = object of GtkBinObj
    priv7: ptr GtkWindowPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkDialog* =  ptr GtkDialogObj
  GtkDialogPtr* = ptr GtkDialogObj
  GtkDialogObj* = object 
    window*: GtkWindowObj
    priv8: ptr GtkDialogPrivateObj
'
j='type 
  GtkDialog* =  ptr GtkDialogObj
  GtkDialogPtr* = ptr GtkDialogObj
  GtkDialogObj* = object of GtkWindowObj
    priv8: ptr GtkDialogPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkContainer* =  ptr GtkContainerObj
  GtkContainerPtr* = ptr GtkContainerObj
  GtkContainerObj* = object 
    widget*: GtkWidgetObj
    priv5: ptr GtkContainerPrivateObj
type 
  GtkBinPrivateObj = object 
  
type 
  GtkBin* =  ptr GtkBinObj
  GtkBinPtr* = ptr GtkBinObj
  GtkBinObj* = object 
    container*: GtkContainerObj
    priv6: ptr GtkBinPrivateObj
'
j='type 
  GtkContainer* =  ptr GtkContainerObj
  GtkContainerPtr* = ptr GtkContainerObj
  GtkContainerObj* = object of GtkWidgetObj
    priv5: ptr GtkContainerPrivateObj
type 
  GtkBinPrivateObj = object 
  
type 
  GtkBin* =  ptr GtkBinObj
  GtkBinPtr* = ptr GtkBinObj
  GtkBinObj* = object of GtkContainerObj
    priv6: ptr GtkBinPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkMisc* =  ptr GtkMiscObj
  GtkMiscPtr* = ptr GtkMiscObj
  GtkMiscObj* = object 
    widget*: GtkWidgetObj
    priv10: ptr GtkMiscPrivateObj
'
j='type 
  GtkMisc* =  ptr GtkMiscObj
  GtkMiscPtr* = ptr GtkMiscObj
  GtkMiscObj* = object of GtkWidgetObj
    priv10: ptr GtkMiscPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkCalendar* =  ptr GtkCalendarObj
  GtkCalendarPtr* = ptr GtkCalendarObj
  GtkCalendarObj* = object 
    widget*: GtkWidgetObj
    priv41: ptr GtkCalendarPrivateObj
'
j='type 
  GtkCalendar* =  ptr GtkCalendarObj
  GtkCalendarPtr* = ptr GtkCalendarObj
  GtkCalendarObj*{.final.} = object of GtkWidgetObj
    priv41: ptr GtkCalendarPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkDrawingArea* =  ptr GtkDrawingAreaObj
  GtkDrawingAreaPtr* = ptr GtkDrawingAreaObj
  GtkDrawingAreaObj* = object 
    widget*: GtkWidgetObj
    dummy*: gpointer
'
j='type 
  GtkDrawingArea* =  ptr GtkDrawingAreaObj
  GtkDrawingAreaPtr* = ptr GtkDrawingAreaObj
  GtkDrawingAreaObj*{.final.} = object of GtkWidgetObj
    dummy*: gpointer
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkInvisible* =  ptr GtkInvisibleObj
  GtkInvisiblePtr* = ptr GtkInvisibleObj
  GtkInvisibleObj* = object 
    widget*: GtkWidgetObj
    priv79: ptr GtkInvisiblePrivateObj
'
j='type 
  GtkInvisible* =  ptr GtkInvisibleObj
  GtkInvisiblePtr* = ptr GtkInvisibleObj
  GtkInvisibleObj*{.final.} = object of GtkWidgetObj
    priv79: ptr GtkInvisiblePrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkRange* =  ptr GtkRangeObj
  GtkRangePtr* = ptr GtkRangeObj
  GtkRangeObj* = object 
    widget*: GtkWidgetObj
    priv101: ptr GtkRangePrivateObj
'
j='type 
  GtkRange* =  ptr GtkRangeObj
  GtkRangePtr* = ptr GtkRangeObj
  GtkRangeObj* = object of GtkWidgetObj
    priv101: ptr GtkRangePrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkSeparator* =  ptr GtkSeparatorObj
  GtkSeparatorPtr* = ptr GtkSeparatorObj
  GtkSeparatorObj* = object 
    widget*: GtkWidgetObj
    priv109: ptr GtkSeparatorPrivateObj
'
j='type 
  GtkSeparator* =  ptr GtkSeparatorObj
  GtkSeparatorPtr* = ptr GtkSeparatorObj
  GtkSeparatorObj* = object of GtkWidgetObj
    priv109: ptr GtkSeparatorPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkMenuPositionFunc* = proc (menu: GtkMenu; x: ptr gint; y: ptr gint; 
                               push_in: ptr gboolean; user_data: gpointer) {.cdecl.}
type 
  GtkMenuDetachFunc* = proc (attach_widget: GtkWidget; menu: GtkMenu) {.cdecl.}
type 
  GtkMenu* =  ptr GtkMenuObj
'
j='type 
  GtkMenuPositionFunc* = proc (menu: GtkMenu; x: ptr gint; y: ptr gint; 
                               push_in: ptr gboolean; user_data: gpointer) {.cdecl.}
#type 
  GtkMenuDetachFunc* = proc (attach_widget: GtkWidget; menu: GtkMenu) {.cdecl.}
#type 
  GtkMenu* =  ptr GtkMenuObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

sed  -i "s/   func: GtkMenuPositionFunc/   fn: GtkMenuPositionFunc/" final.nim
sed  -i "s/   func: GtkTreeModelForeachFunc;/fn: GtkTreeModelForeachFunc;/" final.nim
sed  -i "s/   func: GtkTreeCellDataFunc;/fn: GtkTreeCellDataFunc;/" final.nim
sed  -i 's/\bend: ptr gint/`end`: ptr gint/' final.nim
sed  -i 's/\bend: GtkTextIter/`end`: GtkTextIter/' final.nim
sed  -i 's/; end: /; `end`:/' final.nim
sed  -i 's/; func: /; `func`: /' final.nim
sed  -i 's/    func: Gtk/    `func`: Gtk/' final.nim

i='type 
  GtkButtonBox* =  ptr GtkButtonBoxObj
  GtkButtonBoxPtr* = ptr GtkButtonBoxObj
  GtkButtonBoxObj* = object 
    box*: GtkBoxObj
    priv38: ptr GtkButtonBoxPrivateObj
'
j='type 
  GtkButtonBox* =  ptr GtkButtonBoxObj
  GtkButtonBoxPtr* = ptr GtkButtonBoxObj
  GtkButtonBoxObj* = object of GtkBoxObj
    priv38: ptr GtkButtonBoxPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkStackSwitcher* =  ptr GtkStackSwitcherObj
  GtkStackSwitcherPtr* = ptr GtkStackSwitcherObj
  GtkStackSwitcherObj* = object 
    widget*: GtkBoxObj
'
j='type 
  GtkStackSwitcher* =  ptr GtkStackSwitcherObj
  GtkStackSwitcherPtr* = ptr GtkStackSwitcherObj
  GtkStackSwitcherObj*{.final.} = object of GtkBoxObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkStatusbar* =  ptr GtkStatusbarObj
  GtkStatusbarPtr* = ptr GtkStatusbarObj
  GtkStatusbarObj* = object 
    parent_widget*: GtkBoxObj
    priv114: ptr GtkStatusbarPrivateObj
'
j='type 
  GtkStatusbar* =  ptr GtkStatusbarObj
  GtkStatusbarPtr* = ptr GtkStatusbarObj
  GtkStatusbarObj*{.final.} = object of GtkBoxObj
    priv114: ptr GtkStatusbarPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkHBox* =  ptr GtkHBoxObj
  GtkHBoxPtr* = ptr GtkHBoxObj
  GtkHBoxObj* = object 
    box*: GtkBoxObj
'
j='type 
  GtkHBox* =  ptr GtkHBoxObj
  GtkHBoxPtr* = ptr GtkHBoxObj
  GtkHBoxObj*{.final.} = object of GtkBoxObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkVBox* =  ptr GtkVBoxObj
  GtkVBoxPtr* = ptr GtkVBoxObj
  GtkVBoxObj* = object 
    box*: GtkBoxObj
'
j='type 
  GtkVBox* =  ptr GtkVBoxObj
  GtkVBoxPtr* = ptr GtkVBoxObj
  GtkVBoxObj*{.final.} = object of GtkBoxObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkBox* =  ptr GtkBoxObj
  GtkBoxPtr* = ptr GtkBoxObj
  GtkBoxObj* = object 
    container*: GtkContainerObj
    priv18: ptr GtkBoxPrivateObj
'
j='type 
  GtkBox* =  ptr GtkBoxObj
  GtkBoxPtr* = ptr GtkBoxObj
  GtkBoxObj* = object of GtkContainerObj
    priv18: ptr GtkBoxPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkTreeModelForeachFunc* = proc (model: GtkTreeModel; 
                                   path: GtkTreePath; 
                                   iter: GtkTreeIter; data: gpointer): gboolean {.cdecl.}
type 
  GtkTreeModelFlags* {.size: sizeof(cint), pure.} = enum 
    ITERS_PERSIST = 1 shl 0, LIST_ONLY = 1 shl
        1
type 
  GtkTreeIter* =  ptr GtkTreeIterObj
  GtkTreeIterPtr* = ptr GtkTreeIterObj
  GtkTreeIterObj* = object 
    stamp*: gint
    user_data*: gpointer
    user_data2*: gpointer
    user_data3*: gpointer
'
j='type 
  GtkTreeModelFlags* {.size: sizeof(cint), pure.} = enum 
    ITERS_PERSIST = 1 shl 0, LIST_ONLY = 1 shl
        1
type 
  GtkTreeIter* =  ptr GtkTreeIterObj
  GtkTreeIterPtr* = ptr GtkTreeIterObj
  GtkTreeIterObj* = object 
    stamp*: gint
    user_data*: gpointer
    user_data2*: gpointer
    user_data3*: gpointer
type 
  GtkTreeModelForeachFunc* = proc (model: GtkTreeModel; 
                                   path: GtkTreePath; 
                                   iter: GtkTreeIter; data: gpointer): gboolean {.cdecl.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkCellAreaContextPrivateObj = object 
  
type 
  GtkCellAreaContext* =  ptr GtkCellAreaContextObj
  GtkCellAreaContextPtr* = ptr GtkCellAreaContextObj
  GtkCellAreaContextObj*{.final.} = object of gobject.GObjectObj
    priv43: ptr GtkCellAreaContextPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim

j='type 
  GtkCellArea* =  ptr GtkCellAreaObj
  GtkCellAreaPtr* = ptr GtkCellAreaObj
  GtkCellAreaObj = object of gobject.GInitiallyUnownedObj
    priv22: ptr GtkCellAreaPrivateObj
'
perl -0777 -p -i -e "s%\Q$j\E%$j$i%s" final.nim

i='type 
  GtkTreeCellDataFunc* = proc (tree_column: GtkTreeViewColumn; 
                               cell: GtkCellRenderer; 
                               tree_model: GtkTreeModel; 
                               iter: GtkTreeIter; data: gpointer) {.cdecl.}
type 
  GtkTreeViewColumn* =  ptr GtkTreeViewColumnObj
'
j='type 
  GtkTreeCellDataFunc* = proc (tree_column: GtkTreeViewColumn; 
                               cell: GtkCellRenderer; 
                               tree_model: GtkTreeModel; 
                               iter: GtkTreeIter; data: gpointer) {.cdecl.}
#type 
  GtkTreeViewColumn* =  ptr GtkTreeViewColumnObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkTextIter* =  ptr GtkTextIterObj
  GtkTextIterPtr* = ptr GtkTextIterObj
  GtkTextIterObj* = object 
    dummy1*: gpointer
    dummy2*: gpointer
    dummy3*: gint
    dummy4*: gint
    dummy5*: gint
    dummy6*: gint
    dummy7*: gint
    dummy8*: gint
    dummy9*: gpointer
    dummy10*: gpointer
    dummy11*: gint
    dummy12*: gint
    dummy13*: gint
    dummy14*: gpointer
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
j='type 
  GtkTextTagPrivateObj = object 
  
'
perl -0777 -p -i -e "s%\Q$j\E%$i$j%s" final.nim

i='type 
  GtkTextBufferPrivateObj = object 
  
type 
  GtkTextBuffer* =  ptr GtkTextBufferObj
  GtkTextBufferPtr* = ptr GtkTextBufferObj
  GtkTextBufferObj*{.final.} = object of gobject.GObjectObj
    priv117: ptr GtkTextBufferPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim

i='type 
  GtkTextBufferPrivateObj = object 
  
type 
  GtkTextBuffer* =  ptr GtkTextBufferObj
  GtkTextBufferPtr* = ptr GtkTextBufferObj
  GtkTextBufferObj* = object of gobject.GObjectObj
    priv117: ptr GtkTextBufferPrivateObj
'
j='type 
  GtkTextSearchFlags* {.size: sizeof(cint), pure.} = enum 
    VISIBLE_ONLY = 1 shl 0, 
    TEXT_ONLY = 1 shl 1, 
    CASE_INSENSITIVE = 1 shl 2
'
# INVALID is temporary fix to allow or operation
k='type 
  GtkTextSearchFlags* {.size: sizeof(cint), pure.} = enum 
    VISIBLE_ONLY = 1 shl 0, 
    TEXT_ONLY = 1 shl 1, 
    CASE_INSENSITIVE = 1 shl 2
    INVALID = 1 shl 3
'
perl -0777 -p -i -e "s%\Q$j\E%$i$k%s" final.nim

i='type 
  GtkEntryCompletionMatchFunc* = proc (completion: GtkEntryCompletion; 
      key: ptr gchar; iter: GtkTreeIter; user_data: gpointer): gboolean {.cdecl.}
type 
  GtkEntryCompletion* =  ptr GtkEntryCompletionObj
'
j='type 
  GtkEntryCompletionMatchFunc* = proc (completion: GtkEntryCompletion; 
      key: ptr gchar; iter: GtkTreeIter; user_data: gpointer): gboolean {.cdecl.}
#type 
  GtkEntryCompletion* =  ptr GtkEntryCompletionObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkTreeSelectionPrivateObj = object 
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
j='type 
  GtkTreeSelection* =  ptr GtkTreeSelectionObj
  GtkTreeSelectionPtr* = ptr GtkTreeSelectionObj
  GtkTreeSelectionObj*{.final.} = object of gobject.GObjectObj
    priv123: ptr GtkTreeSelectionPrivateObj
'
perl -0777 -p -i -e "s%\Q$j\E%%s" final.nim

k='type 
  GtkTreeViewPrivateObj = object 
'
perl -0777 -p -i -e "s%\Q$k\E%$i$j$k%s" final.nim

i='type 
  GtkBindingSet* =  ptr GtkBindingSetObj
  GtkBindingSetPtr* = ptr GtkBindingSetObj
  GtkBindingSetObj* = object 
    set_name*: ptr gchar
    priority*: gint
    widget_path_pspecs*: glib.GSList
    widget_class_pspecs*: glib.GSList
    class_branch_pspecs*: glib.GSList
    entries*: GtkBindingEntry
    current*: GtkBindingEntry
    parsed*: guint

type 
  GtkBindingEntry* =  ptr GtkBindingEntryObj
  GtkBindingEntryPtr* = ptr GtkBindingEntryObj
  GtkBindingEntryObj* = object 
    keyval*: guint
    modifiers*: gdk3.ModifierType
    binding_set*: GtkBindingSet
    bitfield0GtkBindingEntry*: guint
    set_next*: GtkBindingEntry
    hash_next*: GtkBindingEntry
    signals*: GtkBindingSignal

type 
  INNER_C_UNION_13196231340349930226* = object  {.union.}
    long_data*: glong
    double_data*: gdouble
    string_data*: ptr gchar

type 
  GtkBindingArg* =  ptr GtkBindingArgObj
  GtkBindingArgPtr* = ptr GtkBindingArgObj
  GtkBindingArgObj* = object 
    arg_type*: GType
    d*: INNER_C_UNION_13196231340349930226

type 
  GtkBindingSignal* =  ptr GtkBindingSignalObj
  GtkBindingSignalPtr* = ptr GtkBindingSignalObj
  GtkBindingSignalObj* = object 
    next*: GtkBindingSignal
    signal_name*: ptr gchar
    n_args*: guint
    args*: GtkBindingArg
'
j='type 
  GtkBindingSet* =  ptr GtkBindingSetObj
  GtkBindingSetPtr* = ptr GtkBindingSetObj
  GtkBindingSetObj* = object 
    set_name*: ptr gchar
    priority*: gint
    widget_path_pspecs*: glib.GSList
    widget_class_pspecs*: glib.GSList
    class_branch_pspecs*: glib.GSList
    entries*: GtkBindingEntry
    current*: GtkBindingEntry
    parsed*: guint

#type 
  GtkBindingEntry* =  ptr GtkBindingEntryObj
  GtkBindingEntryPtr* = ptr GtkBindingEntryObj
  GtkBindingEntryObj* = object 
    keyval*: guint
    modifiers*: gdk3.ModifierType
    binding_set*: GtkBindingSet
    bitfield0GtkBindingEntry*: guint
    set_next*: GtkBindingEntry
    hash_next*: GtkBindingEntry
    signals*: GtkBindingSignal

#type 
  INNER_C_UNION_13196231340349930226* = object  {.union.}
    long_data*: glong
    double_data*: gdouble
    string_data*: ptr gchar

#type 
  GtkBindingArg* =  ptr GtkBindingArgObj
  GtkBindingArgPtr* = ptr GtkBindingArgObj
  GtkBindingArgObj* = object 
    arg_type*: GType
    d*: INNER_C_UNION_13196231340349930226

#type 
  GtkBindingSignal* =  ptr GtkBindingSignalObj
  GtkBindingSignalPtr* = ptr GtkBindingSignalObj
  GtkBindingSignalObj* = object 
    next*: GtkBindingSignal
    signal_name*: ptr gchar
    n_args*: guint
    args*: GtkBindingArg
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

sed -i 's/object: gobject\.GObject/obj: gobject.GObject/' final.nim
sed -i 's/(object, `type`: expr)/(obj, `type`: expr)/' final.nim
sed -i 's/, type, /, `type`, /' final.nim

i='type 
  GtkCalendarDetailFunc* = proc (calendar: GtkCalendar; year: guint; 
                                 month: guint; day: guint; user_data: gpointer): ptr gchar {.cdecl.}
type 
  GtkCalendar* =  ptr GtkCalendarObj
  GtkCalendarPtr* = ptr GtkCalendarObj
  GtkCalendarObj*{.final.} = object of GtkWidgetObj
    priv41: ptr GtkCalendarPrivateObj
'
j='type 
  GtkCalendar* =  ptr GtkCalendarObj
  GtkCalendarPtr* = ptr GtkCalendarObj
  GtkCalendarObj*{.final.} = object of GtkWidgetObj
    priv41: ptr GtkCalendarPrivateObj
type 
  GtkCalendarDetailFunc* = proc (calendar: GtkCalendar; year: guint; 
                                 month: guint; day: guint; user_data: gpointer): ptr gchar {.cdecl.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

sed -i 's/    g_type_name(G_OBJECT_TYPE(obj)))/    gobject.name(G_OBJECT_TYPE(obj)))/' final.nim

i='type 
  GtkFileFilterFunc* = proc (filter_info: GtkFileFilterInfo; 
                             data: gpointer): gboolean {.cdecl.}
type 
  GtkFileFilterInfo* =  ptr GtkFileFilterInfoObj
'
j='type 
  GtkFileFilterFunc* = proc (filter_info: GtkFileFilterInfo; 
                             data: gpointer): gboolean {.cdecl.}
#type 
  GtkFileFilterInfo* =  ptr GtkFileFilterInfoObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkFileChooserButtonClass* =  ptr GtkFileChooserButtonClassObj
  GtkFileChooserButtonClassPtr* = ptr GtkFileChooserButtonClassObj
  GtkFileChooserButtonClassObj*{.final.} = object of GtkBoxClassObj
    file_set*: proc (fc: GtkFileChooserButton) {.cdecl.}
    gtk_reserved1: nil
    gtk_reserved2: nil
    gtk_reserved3: nil
    gtk_reserved4: nil
'
j='type 
  GtkFileChooserButtonClass* =  ptr GtkFileChooserButtonClassObj
  GtkFileChooserButtonClassPtr* = ptr GtkFileChooserButtonClassObj
  GtkFileChooserButtonClassObj*{.final.} = object of GtkBoxClassObj
    file_set*: proc (fc: GtkFileChooserButton) {.cdecl.}
    gtk_reserved1: proc () {.cdecl.}
    gtk_reserved2: proc () {.cdecl.}
    gtk_reserved3: proc () {.cdecl.}
    gtk_reserved4: proc () {.cdecl.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkFlowBoxChild* =  ptr GtkFlowBoxChildObj
  GtkFlowBoxChildPtr* = ptr GtkFlowBoxChildObj
  GtkFlowBoxChildObj*{.final.} = object of GtkBinObj
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim

j='type 
  GtkFlowBox* =  ptr GtkFlowBoxObj
  GtkFlowBoxPtr* = ptr GtkFlowBoxObj
  GtkFlowBoxObj* = object 
    container*: GtkContainerObj
'
perl -0777 -p -i -e "s%\Q$j\E%$j$i%s" final.nim

i='type 
  GtkIconViewForeachFunc* = proc (icon_view: GtkIconView; 
                                  path: GtkTreePath; data: gpointer) {.cdecl.}
type 
  GtkIconViewDropPosition* {.size: sizeof(cint), pure.} = enum 
    NO_DROP, DROP_INTO, DROP_LEFT, 
    DROP_RIGHT, DROP_ABOVE, 
    DROP_BELOW
type 
  GtkIconView* =  ptr GtkIconViewObj
  GtkIconViewPtr* = ptr GtkIconViewObj
  GtkIconViewObj*{.final.} = object of GtkContainerObj
    priv75: ptr GtkIconViewPrivateObj
'
j='type 
  GtkIconViewForeachFunc* = proc (icon_view: GtkIconView; 
                                  path: GtkTreePath; data: gpointer) {.cdecl.}
#type 
  GtkIconViewDropPosition* {.size: sizeof(cint), pure.} = enum 
    NO_DROP, DROP_INTO, DROP_LEFT, 
    DROP_RIGHT, DROP_ABOVE, 
    DROP_BELOW
#type 
  GtkIconView* =  ptr GtkIconViewObj
  GtkIconViewPtr* = ptr GtkIconViewObj
  GtkIconViewObj*{.final.} = object of GtkContainerObj
    priv75: ptr GtkIconViewPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkIMContextSimple* =  ptr GtkIMContextSimpleObj
  GtkIMContextSimplePtr* = ptr GtkIMContextSimpleObj
  GtkIMContextSimpleObj* = object 
    object*: GtkIMContextObj
    priv76: ptr GtkIMContextSimplePrivateObj
'
j='type 
  GtkIMContextSimple* =  ptr GtkIMContextSimpleObj
  GtkIMContextSimplePtr* = ptr GtkIMContextSimpleObj
  GtkIMContextSimpleObj*{.final.} = object of GtkIMContextObj
    priv76: ptr GtkIMContextSimplePrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkIMMulticontext* =  ptr GtkIMMulticontextObj
  GtkIMMulticontextPtr* = ptr GtkIMMulticontextObj
  GtkIMMulticontextObj* = object 
    object*: GtkIMContextObj
    priv77: ptr GtkIMMulticontextPrivateObj
'
j='type 
  GtkIMMulticontext* =  ptr GtkIMMulticontextObj
  GtkIMMulticontextPtr* = ptr GtkIMMulticontextObj
  GtkIMMulticontextObj*{.final.} = object of GtkIMContextObj
    priv77: ptr GtkIMMulticontextPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkButton* =  ptr GtkButtonObj
  GtkButtonPtr* = ptr GtkButtonObj
  GtkButtonObj* = object 
    bin*: GtkBinObj
    priv40: ptr GtkButtonPrivateObj
'
j='type 
  GtkButton* =  ptr GtkButtonObj
  GtkButtonPtr* = ptr GtkButtonObj
  GtkButtonObj* = object of GtkBinObj
    priv40: ptr GtkButtonPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkToggleButton* =  ptr GtkToggleButtonObj
  GtkToggleButtonPtr* = ptr GtkToggleButtonObj
  GtkToggleButtonObj* = object 
    button*: GtkButtonObj
    priv53: ptr GtkToggleButtonPrivateObj
'
j='type 
  GtkToggleButton* =  ptr GtkToggleButtonObj
  GtkToggleButtonPtr* = ptr GtkToggleButtonObj
  GtkToggleButtonObj* = object of GtkButtonObj
    priv53: ptr GtkToggleButtonPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkColorButton* =  ptr GtkColorButtonObj
  GtkColorButtonPtr* = ptr GtkColorButtonObj
  GtkColorButtonObj* = object 
    button*: GtkButtonObj
    priv56: ptr GtkColorButtonPrivateObj
'
j='type 
  GtkColorButton* =  ptr GtkColorButtonObj
  GtkColorButtonPtr* = ptr GtkColorButtonObj
  GtkColorButtonObj*{.final.} = object of GtkButtonObj
    priv56: ptr GtkColorButtonPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkListBoxRow* =  ptr GtkListBoxRowObj
  GtkListBoxRowPtr* = ptr GtkListBoxRowObj
  GtkListBoxRowObj*{.final.} = object of GtkBinObj
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
j='type 
  GtkListBox* =  ptr GtkListBoxObj
  GtkListBoxPtr* = ptr GtkListBoxObj
  GtkListBoxObj*{.final.} = object of GtkContainerObj
'
perl -0777 -p -i -e "s%\Q$j\E%$j$i%s" final.nim

i='type 
  GtkPopoverMenuClass* =  ptr GtkPopoverMenuClassObj
  GtkPopoverMenuClassPtr* = ptr GtkPopoverMenuClassObj
  GtkPopoverMenuClassObj*{.final.} = object of GtkPopoverClassObj
    reserved: array[10, gpointer]
'
j='type 
  GtkPopoverMenuClass* =  ptr GtkPopoverMenuClassObj
  GtkPopoverMenuClassPtr* = ptr GtkPopoverMenuClassObj
  GtkPopoverMenuClassObj*{.final.} = object of GtkPopoverClassObj
    reserved00: array[10, gpointer]
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

sed -i 's/end\*: gint/`end`*: gint/' final.nim

i='type 
  GtkRecentFilterFunc* = proc (filter_info: GtkRecentFilterInfo; 
                               user_data: gpointer): gboolean {.cdecl.}
type 
  GtkRecentFilterInfo* =  ptr GtkRecentFilterInfoObj
'
j='type 
  GtkRecentFilterFunc* = proc (filter_info: GtkRecentFilterInfo; 
                               user_data: gpointer): gboolean {.cdecl.}
#type 
  GtkRecentFilterInfo* =  ptr GtkRecentFilterInfoObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='  GtkMenuObj* = object 
    menu_shell*: GtkMenuShellObj
    priv12: ptr GtkMenuPrivateObj
'
j='  GtkMenuObj* = object of GtkMenuShellObj
    priv12: ptr GtkMenuPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkMenuShell* =  ptr GtkMenuShellObj
  GtkMenuShellPtr* = ptr GtkMenuShellObj
  GtkMenuShellObj* = object 
    container*: GtkContainerObj
    priv11: ptr GtkMenuShellPrivateObj
'
j='type 
  GtkMenuShell* =  ptr GtkMenuShellObj
  GtkMenuShellPtr* = ptr GtkMenuShellObj
  GtkMenuShellObj* = object of GtkContainerObj
    priv11: ptr GtkMenuShellPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

sed -i 's/\bGDK_PRIORITY_REDRAW\b/gdk3.PRIORITY_REDRAW/' final.nim

i='type 
  GtkAction* =  ptr GtkActionObj
  GtkActionPtr* = ptr GtkActionObj
  GtkActionObj* = object 
    object*: gobject.GObjectObj
    private_data*: ptr GtkActionPrivateObj
'
j='type 
  GtkAction* =  ptr GtkActionObj
  GtkActionPtr* = ptr GtkActionObj
  GtkActionObj* = object of gobject.GObjectObj
    private_data*: ptr GtkActionPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkAction* =  ptr GtkActionObj
  GtkActionPtr* = ptr GtkActionObj
  GtkActionObj* = object of gobject.GObjectObj
    private_data*: ptr GtkActionPrivateObj
'
j='type 
  GtkAction* =  ptr GtkActionObj
  GtkActionPtr* = ptr GtkActionObj
  GtkActionObj* = object of gobject.GObjectObj
    private_data00*: ptr GtkActionPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

sed -i 's/G_TOKEN_LAST/glib.GTokenType.LAST/' final.nim

i='type 
  GtkToggleAction* =  ptr GtkToggleActionObj
  GtkToggleActionPtr* = ptr GtkToggleActionObj
  GtkToggleActionObj = object of GtkActionObj
    private_data*: ptr GtkToggleActionPrivateObj
'
j='type 
  GtkToggleAction* =  ptr GtkToggleActionObj
  GtkToggleActionPtr* = ptr GtkToggleActionObj
  GtkToggleActionObj = object of GtkActionObj
    private_data01*: ptr GtkToggleActionPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='    query_tooltip*: proc (status_icon: GtkStatusIcon; x: gint; y: gint; 
                          keyboard_mode: gboolean; tooltip: GtkTooltip): gboolean {.cdecl.}
    gtk_reserved1: nil
    gtk_reserved2: nil
    gtk_reserved3: nil
    gtk_reserved4: nil
'
j='    query_tooltip*: proc (status_icon: GtkStatusIcon; x: gint; y: gint; 
                          keyboard_mode: gboolean; tooltip: GtkTooltip): gboolean {.cdecl.}
    gtk_reserved1: proc () {.cdecl.}
    gtk_reserved2: proc () {.cdecl.}
    gtk_reserved3: proc () {.cdecl.}
    gtk_reserved4: proc () {.cdecl.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

sed -i 's/(func: /(fn: /' final.nim

i='type 
  GtkPrintJobCompleteFunc* = proc (print_job: GtkPrintJob; 
                                   user_data: gpointer; error: glib.GError) {.cdecl.}
type 
  GtkPrinter* =  ptr GtkPrinterObj
  GtkPrinterPtr* = ptr GtkPrinterObj
  GtkPrinterObj* = object 
  
type 
  GtkPrintJob* =  ptr GtkPrintJobObj
  GtkPrintJobPtr* = ptr GtkPrintJobObj
  GtkPrintJobObj*{.final.} = object of gobject.GObjectObj
    priv144: ptr GtkPrintJobPrivateObj
'
j='type 
  GtkPrintJobCompleteFunc* = proc (print_job: GtkPrintJob; 
                                   user_data: gpointer; error: glib.GError) {.cdecl.}
#type 
  GtkPrintJob* =  ptr GtkPrintJobObj
  GtkPrintJobPtr* = ptr GtkPrintJobObj
  GtkPrintJobObj*{.final.} = object of gobject.GObjectObj
    priv144: ptr GtkPrintJobPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkLabel* =  ptr GtkLabelObj
  GtkLabelPtr* = ptr GtkLabelObj
  GtkLabelObj* = object 
    misc*: GtkMiscObj
    priv13: ptr GtkLabelPrivateObj
'
j='type 
  GtkLabel* =  ptr GtkLabelObj
  GtkLabelPtr* = ptr GtkLabelObj
  GtkLabelObj* = object of GtkMiscObj
    priv13: ptr GtkLabelPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkAccelLabel* =  ptr GtkAccelLabelObj
  GtkAccelLabelPtr* = ptr GtkAccelLabelObj
  GtkAccelLabelObj* = object 
    label*: GtkLabelObj
    priv14: ptr GtkAccelLabelPrivateObj
'
j='type 
  GtkAccelLabel* =  ptr GtkAccelLabelObj
  GtkAccelLabelPtr* = ptr GtkAccelLabelObj
  GtkAccelLabelObj*{.final.} = object of GtkLabelObj
    priv14: ptr GtkAccelLabelPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkActionableInterface* =  ptr GtkActionableInterfaceObj
  GtkActionableInterfacePtr* = ptr GtkActionableInterfaceObj
  GtkActionableInterfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkActionableInterface* =  ptr GtkActionableInterfaceObj
  GtkActionableInterfacePtr* = ptr GtkActionableInterfaceObj
  GtkActionableInterfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkActionBar* =  ptr GtkActionBarObj
  GtkActionBarPtr* = ptr GtkActionBarObj
  GtkActionBarObj* = object 
    bin*: GtkBinObj
'
j='type 
  GtkActionBar* =  ptr GtkActionBarObj
  GtkActionBarPtr* = ptr GtkActionBarObj
  GtkActionBarObj*{.final.} = object of GtkBinObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkTreeModelIface* =  ptr GtkTreeModelIfaceObj
  GtkTreeModelIfacePtr* = ptr GtkTreeModelIfaceObj
  GtkTreeModelIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkTreeModelIface* =  ptr GtkTreeModelIfaceObj
  GtkTreeModelIfacePtr* = ptr GtkTreeModelIfaceObj
  GtkTreeModelIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkCellEditableIface* =  ptr GtkCellEditableIfaceObj
  GtkCellEditableIfacePtr* = ptr GtkCellEditableIfaceObj
  GtkCellEditableIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkCellEditableIface* =  ptr GtkCellEditableIfaceObj
  GtkCellEditableIfacePtr* = ptr GtkCellEditableIfaceObj
  GtkCellEditableIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkTreeSortableIface* =  ptr GtkTreeSortableIfaceObj
  GtkTreeSortableIfacePtr* = ptr GtkTreeSortableIfaceObj
  GtkTreeSortableIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkTreeSortableIface* =  ptr GtkTreeSortableIfaceObj
  GtkTreeSortableIfacePtr* = ptr GtkTreeSortableIfaceObj
  GtkTreeSortableIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkEditableInterface* =  ptr GtkEditableInterfaceObj
  GtkEditableInterfacePtr* = ptr GtkEditableInterfaceObj
  GtkEditableInterfaceObj* = object 
    base_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkEditableInterface* =  ptr GtkEditableInterfaceObj
  GtkEditableInterfacePtr* = ptr GtkEditableInterfaceObj
  GtkEditableInterfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkImage* =  ptr GtkImageObj
  GtkImagePtr* = ptr GtkImageObj
  GtkImageObj* = object 
    misc*: GtkMiscObj
    priv29: ptr GtkImagePrivateObj
'
j='type 
  GtkImage* =  ptr GtkImageObj
  GtkImagePtr* = ptr GtkImageObj
  GtkImageObj*{.final.} = object of GtkMiscObj
    priv29: ptr GtkImagePrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkFrame* =  ptr GtkFrameObj
  GtkFramePtr* = ptr GtkFrameObj
  GtkFrameObj* = object 
    bin*: GtkBinObj
    priv35: ptr GtkFramePrivateObj
'
j='type 
  GtkFrame* =  ptr GtkFrameObj
  GtkFramePtr* = ptr GtkFrameObj
  GtkFrameObj* = object of GtkBinObj
    priv35: ptr GtkFramePrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkAspectFrame* =  ptr GtkAspectFrameObj
  GtkAspectFramePtr* = ptr GtkAspectFrameObj
  GtkAspectFrameObj* = object 
    frame*: GtkFrameObj
    priv36: ptr GtkAspectFramePrivateObj
'
j='type 
  GtkAspectFrame* =  ptr GtkAspectFrameObj
  GtkAspectFramePtr* = ptr GtkAspectFrameObj
  GtkAspectFrameObj*{.final.} = object of GtkFrameObj
    priv36: ptr GtkAspectFramePrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkBuildableIface* =  ptr GtkBuildableIfaceObj
  GtkBuildableIfacePtr* = ptr GtkBuildableIfaceObj
  GtkBuildableIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkBuildableIface* =  ptr GtkBuildableIfaceObj
  GtkBuildableIfacePtr* = ptr GtkBuildableIfaceObj
  GtkBuildableIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkCellLayoutIface* =  ptr GtkCellLayoutIfaceObj
  GtkCellLayoutIfacePtr* = ptr GtkCellLayoutIfaceObj
  GtkCellLayoutIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkCellLayoutIface* =  ptr GtkCellLayoutIfaceObj
  GtkCellLayoutIfacePtr* = ptr GtkCellLayoutIfaceObj
  GtkCellLayoutIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkCheckButton* =  ptr GtkCheckButtonObj
  GtkCheckButtonPtr* = ptr GtkCheckButtonObj
  GtkCheckButtonObj* = object 
    toggle_button*: GtkToggleButtonObj
'
j='type 
  GtkCheckButton* =  ptr GtkCheckButtonObj
  GtkCheckButtonPtr* = ptr GtkCheckButtonObj
  GtkCheckButtonObj* = object of GtkToggleButtonObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkMenuItem* =  ptr GtkMenuItemObj
  GtkMenuItemPtr* = ptr GtkMenuItemObj
  GtkMenuItemObj* = object 
    bin*: GtkBinObj
    priv54: ptr GtkMenuItemPrivateObj
'
j='type 
  GtkMenuItem* =  ptr GtkMenuItemObj
  GtkMenuItemPtr* = ptr GtkMenuItemObj
  GtkMenuItemObj* = object of GtkBinObj
    priv54: ptr GtkMenuItemPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkCheckMenuItem* =  ptr GtkCheckMenuItemObj
  GtkCheckMenuItemPtr* = ptr GtkCheckMenuItemObj
  GtkCheckMenuItemObj* = object 
    menu_item*: GtkMenuItemObj
    priv55: ptr GtkCheckMenuItemPrivateObj
'
j='type 
  GtkCheckMenuItem* =  ptr GtkCheckMenuItemObj
  GtkCheckMenuItemPtr* = ptr GtkCheckMenuItemObj
  GtkCheckMenuItemObj* = object of GtkMenuItemObj
    priv55: ptr GtkCheckMenuItemPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkColorChooserInterface* =  ptr GtkColorChooserInterfaceObj
  GtkColorChooserInterfacePtr* = ptr GtkColorChooserInterfaceObj
  GtkColorChooserInterfaceObj* = object 
    base_interface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkColorChooserInterface* =  ptr GtkColorChooserInterfaceObj
  GtkColorChooserInterfacePtr* = ptr GtkColorChooserInterfaceObj
  GtkColorChooserInterfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkEventBox* =  ptr GtkEventBoxObj
  GtkEventBoxPtr* = ptr GtkEventBoxObj
  GtkEventBoxObj* = object 
    bin*: GtkBinObj
    priv61: ptr GtkEventBoxPrivateObj
'
j='type 
  GtkEventBox* =  ptr GtkEventBoxObj
  GtkEventBoxPtr* = ptr GtkEventBoxObj
  GtkEventBoxObj*{.final.} = object of GtkBinObj
    priv61: ptr GtkEventBoxPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkExpander* =  ptr GtkExpanderObj
  GtkExpanderPtr* = ptr GtkExpanderObj
  GtkExpanderObj* = object 
    bin*: GtkBinObj
    priv62: ptr GtkExpanderPrivateObj
'
j='type 
  GtkExpander* =  ptr GtkExpanderObj
  GtkExpanderPtr* = ptr GtkExpanderObj
  GtkExpanderObj*{.final.} = object of GtkBinObj
    priv62: ptr GtkExpanderPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkFixed* =  ptr GtkFixedObj
  GtkFixedPtr* = ptr GtkFixedObj
  GtkFixedObj* = object 
    container*: GtkContainerObj
    priv63: ptr GtkFixedPrivateObj
'
j='type 
  GtkFixed* =  ptr GtkFixedObj
  GtkFixedPtr* = ptr GtkFixedObj
  GtkFixedObj*{.final.} = object of GtkContainerObj
    priv63: ptr GtkFixedPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkFixedChild* =  ptr GtkFixedChildObj
  GtkFixedChildPtr* = ptr GtkFixedChildObj
  GtkFixedChildObj* = object 
    widget*: GtkWidget
    x*: gint
    y*: gint
'
j='type 
  GtkFixedChild* =  ptr GtkFixedChildObj
  GtkFixedChildPtr* = ptr GtkFixedChildObj
  GtkFixedChildObj*{.final.} = object of GtkWidget
    x*: gint
    y*: gint
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkFlowBox* =  ptr GtkFlowBoxObj
  GtkFlowBoxPtr* = ptr GtkFlowBoxObj
  GtkFlowBoxObj* = object 
    container*: GtkContainerObj
'
j='type 
  GtkFlowBox* =  ptr GtkFlowBoxObj
  GtkFlowBoxPtr* = ptr GtkFlowBoxObj
  GtkFlowBoxObj*{.final.} = object of GtkContainerObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkFontButton* =  ptr GtkFontButtonObj
  GtkFontButtonPtr* = ptr GtkFontButtonObj
  GtkFontButtonObj* = object 
    button*: GtkButtonObj
    priv67: ptr GtkFontButtonPrivateObj
'
j='type 
  GtkFontButton* =  ptr GtkFontButtonObj
  GtkFontButtonPtr* = ptr GtkFontButtonObj
  GtkFontButtonObj*{.final.} = object of GtkButtonObj
    priv67: ptr GtkFontButtonPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkFontChooserIface* =  ptr GtkFontChooserIfaceObj
  GtkFontChooserIfacePtr* = ptr GtkFontChooserIfaceObj
  GtkFontChooserIfaceObj* = object 
    base_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkFontChooserIface* =  ptr GtkFontChooserIfaceObj
  GtkFontChooserIfacePtr* = ptr GtkFontChooserIfaceObj
  GtkFontChooserIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkGrid* =  ptr GtkGridObj
  GtkGridPtr* = ptr GtkGridObj
  GtkGridObj* = object 
    container*: GtkContainerObj
    priv70: ptr GtkGridPrivateObj
'
j='type 
  GtkGrid* =  ptr GtkGridObj
  GtkGridPtr* = ptr GtkGridObj
  GtkGridObj*{.final.} = object of GtkContainerObj
    priv70: ptr GtkGridPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkHeaderBar* =  ptr GtkHeaderBarObj
  GtkHeaderBarPtr* = ptr GtkHeaderBarObj
  GtkHeaderBarObj* = object 
    container*: GtkContainerObj
'
j='type 
  GtkHeaderBar* =  ptr GtkHeaderBarObj
  GtkHeaderBarPtr* = ptr GtkHeaderBarObj
  GtkHeaderBarObj*{.final.} = object of GtkContainerObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkStyleProviderIface* =  ptr GtkStyleProviderIfaceObj
  GtkStyleProviderIfacePtr* = ptr GtkStyleProviderIfaceObj
  GtkStyleProviderIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkStyleProviderIface* =  ptr GtkStyleProviderIfaceObj
  GtkStyleProviderIfacePtr* = ptr GtkStyleProviderIfaceObj
  GtkStyleProviderIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkLayout* =  ptr GtkLayoutObj
  GtkLayoutPtr* = ptr GtkLayoutObj
  GtkLayoutObj* = object 
    container*: GtkContainerObj
    priv80: ptr GtkLayoutPrivateObj
'
j='type 
  GtkLayout* =  ptr GtkLayoutObj
  GtkLayoutPtr* = ptr GtkLayoutObj
  GtkLayoutObj*{.final.} = object of GtkContainerObj
    priv80: ptr GtkLayoutPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkMenuBar* =  ptr GtkMenuBarObj
  GtkMenuBarPtr* = ptr GtkMenuBarObj
  GtkMenuBarObj* = object 
    menu_shell*: GtkMenuShellObj
    priv84: ptr GtkMenuBarPrivateObj
'
j='type 
  GtkMenuBar* =  ptr GtkMenuBarObj
  GtkMenuBarPtr* = ptr GtkMenuBarObj
  GtkMenuBarObj*{.final.} = object of GtkMenuShellObj
    priv84: ptr GtkMenuBarPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkNotebook* =  ptr GtkNotebookObj
  GtkNotebookPtr* = ptr GtkNotebookObj
  GtkNotebookObj* = object 
    container*: GtkContainerObj
    priv93: ptr GtkNotebookPrivateObj
'
j='type 
  GtkNotebook* =  ptr GtkNotebookObj
  GtkNotebookPtr* = ptr GtkNotebookObj
  GtkNotebookObj*{.final.} = object of GtkContainerObj
    priv93: ptr GtkNotebookPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkOrientableIface* =  ptr GtkOrientableIfaceObj
  GtkOrientableIfacePtr* = ptr GtkOrientableIfaceObj
  GtkOrientableIfaceObj* = object 
    base_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkOrientableIface* =  ptr GtkOrientableIfaceObj
  GtkOrientableIfacePtr* = ptr GtkOrientableIfaceObj
  GtkOrientableIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkPaned* =  ptr GtkPanedObj
  GtkPanedPtr* = ptr GtkPanedObj
  GtkPanedObj* = object 
    container*: GtkContainerObj
    priv95: ptr GtkPanedPrivateObj
'
j='type 
  GtkPaned* =  ptr GtkPanedObj
  GtkPanedPtr* = ptr GtkPanedObj
  GtkPanedObj* = object of GtkContainerObj
    priv95: ptr GtkPanedPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkPrintOperationPreviewIface* =  ptr GtkPrintOperationPreviewIfaceObj
  GtkPrintOperationPreviewIfacePtr* = ptr GtkPrintOperationPreviewIfaceObj
  GtkPrintOperationPreviewIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkPrintOperationPreviewIface* =  ptr GtkPrintOperationPreviewIfaceObj
  GtkPrintOperationPreviewIfacePtr* = ptr GtkPrintOperationPreviewIfaceObj
  GtkPrintOperationPreviewIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkRadioButton* =  ptr GtkRadioButtonObj
  GtkRadioButtonPtr* = ptr GtkRadioButtonObj
  GtkRadioButtonObj* = object 
    check_button*: GtkCheckButtonObj
    priv98: ptr GtkRadioButtonPrivateObj
'
j='type 
  GtkRadioButton* =  ptr GtkRadioButtonObj
  GtkRadioButtonPtr* = ptr GtkRadioButtonObj
  GtkRadioButtonObj*{.final.} = object of GtkCheckButtonObj
    priv98: ptr GtkRadioButtonPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkRadioMenuItem* =  ptr GtkRadioMenuItemObj
  GtkRadioMenuItemPtr* = ptr GtkRadioMenuItemObj
  GtkRadioMenuItemObj* = object 
    check_menu_item*: GtkCheckMenuItemObj
    priv99: ptr GtkRadioMenuItemPrivateObj
'
j='type 
  GtkRadioMenuItem* =  ptr GtkRadioMenuItemObj
  GtkRadioMenuItemPtr* = ptr GtkRadioMenuItemObj
  GtkRadioMenuItemObj*{.final.} = object of GtkCheckMenuItemObj
    priv99: ptr GtkRadioMenuItemPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkRecentChooserIface* =  ptr GtkRecentChooserIfaceObj
  GtkRecentChooserIfacePtr* = ptr GtkRecentChooserIfaceObj
  GtkRecentChooserIfaceObj* = object 
    base_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkRecentChooserIface* =  ptr GtkRecentChooserIfaceObj
  GtkRecentChooserIfacePtr* = ptr GtkRecentChooserIfaceObj
  GtkRecentChooserIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkScale* =  ptr GtkScaleObj
  GtkScalePtr* = ptr GtkScaleObj
  GtkScaleObj* = object 
    range*: GtkRangeObj
    priv106: ptr GtkScalePrivateObj
'
j='type 
  GtkScale* =  ptr GtkScaleObj
  GtkScalePtr* = ptr GtkScaleObj
  GtkScaleObj* = object of GtkRangeObj
    priv106: ptr GtkScalePrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkScrollableInterface* =  ptr GtkScrollableInterfaceObj
  GtkScrollableInterfacePtr* = ptr GtkScrollableInterfaceObj
  GtkScrollableInterfaceObj* = object 
    base_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkScrollableInterface* =  ptr GtkScrollableInterfaceObj
  GtkScrollableInterfacePtr* = ptr GtkScrollableInterfaceObj
  GtkScrollableInterfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkScrollbar* =  ptr GtkScrollbarObj
  GtkScrollbarPtr* = ptr GtkScrollbarObj
  GtkScrollbarObj* = object 
    range*: GtkRangeObj
'
j='type 
  GtkScrollbar* =  ptr GtkScrollbarObj
  GtkScrollbarPtr* = ptr GtkScrollbarObj
  GtkScrollbarObj* = object of GtkRangeObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkScrolledWindow* =  ptr GtkScrolledWindowObj
  GtkScrolledWindowPtr* = ptr GtkScrolledWindowObj
  GtkScrolledWindowObj* = object 
    container*: GtkBinObj
    priv108: ptr GtkScrolledWindowPrivateObj
'
j='type 
  GtkScrolledWindow* =  ptr GtkScrolledWindowObj
  GtkScrolledWindowPtr* = ptr GtkScrolledWindowObj
  GtkScrolledWindowObj*{.final.} = object of GtkBinObj
    priv108: ptr GtkScrolledWindowPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkSeparatorMenuItem* =  ptr GtkSeparatorMenuItemObj
  GtkSeparatorMenuItemPtr* = ptr GtkSeparatorMenuItemObj
  GtkSeparatorMenuItemObj* = object 
    menu_item*: GtkMenuItemObj
'
j='type 
  GtkSeparatorMenuItem* =  ptr GtkSeparatorMenuItemObj
  GtkSeparatorMenuItemPtr* = ptr GtkSeparatorMenuItemObj
  GtkSeparatorMenuItemObj*{.final.} = object of GtkMenuItemObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkSpinButton* =  ptr GtkSpinButtonObj
  GtkSpinButtonPtr* = ptr GtkSpinButtonObj
  GtkSpinButtonObj* = object 
    entry*: GtkEntryObj
    priv112: ptr GtkSpinButtonPrivateObj
'
j='type 
  GtkSpinButton* =  ptr GtkSpinButtonObj
  GtkSpinButtonPtr* = ptr GtkSpinButtonObj
  GtkSpinButtonObj*{.final.} = object of GtkEntryObj
    priv112: ptr GtkSpinButtonPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkToolbar* =  ptr GtkToolbarObj
  GtkToolbarPtr* = ptr GtkToolbarObj
  GtkToolbarObj* = object 
    container*: GtkContainerObj
    priv119: ptr GtkToolbarPrivateObj
'
j='type 
  GtkToolbar* =  ptr GtkToolbarObj
  GtkToolbarPtr* = ptr GtkToolbarObj
  GtkToolbarObj*{.final.} = object of GtkContainerObj
    priv119: ptr GtkToolbarPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkToolShellIface* =  ptr GtkToolShellIfaceObj
  GtkToolShellIfacePtr* = ptr GtkToolShellIfaceObj
  GtkToolShellIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkToolShellIface* =  ptr GtkToolShellIfaceObj
  GtkToolShellIfacePtr* = ptr GtkToolShellIfaceObj
  GtkToolShellIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkTreeDragSourceIface* =  ptr GtkTreeDragSourceIfaceObj
  GtkTreeDragSourceIfacePtr* = ptr GtkTreeDragSourceIfaceObj
  GtkTreeDragSourceIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkTreeDragSourceIface* =  ptr GtkTreeDragSourceIfaceObj
  GtkTreeDragSourceIfacePtr* = ptr GtkTreeDragSourceIfaceObj
  GtkTreeDragSourceIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkTreeDragDestIface* =  ptr GtkTreeDragDestIfaceObj
  GtkTreeDragDestIfacePtr* = ptr GtkTreeDragDestIfaceObj
  GtkTreeDragDestIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkTreeDragDestIface* =  ptr GtkTreeDragDestIfaceObj
  GtkTreeDragDestIfacePtr* = ptr GtkTreeDragDestIfaceObj
  GtkTreeDragDestIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkViewport* =  ptr GtkViewportObj
  GtkViewportPtr* = ptr GtkViewportObj
  GtkViewportObj* = object 
    bin*: GtkBinObj
    priv125: ptr GtkViewportPrivateObj
'
j='type 
  GtkViewport* =  ptr GtkViewportObj
  GtkViewportPtr* = ptr GtkViewportObj
  GtkViewportObj*{.final.} = object of GtkBinObj
    priv125: ptr GtkViewportPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkArrow* =  ptr GtkArrowObj
  GtkArrowPtr* = ptr GtkArrowObj
  GtkArrowObj* = object 
    misc*: GtkMiscObj
    priv127: ptr GtkArrowPrivateObj
'
j='type 
  GtkArrow* =  ptr GtkArrowObj
  GtkArrowPtr* = ptr GtkArrowObj
  GtkArrowObj*{.final.} = object of GtkMiscObj
    priv127: ptr GtkArrowPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkActivatableIface* =  ptr GtkActivatableIfaceObj
  GtkActivatableIfacePtr* = ptr GtkActivatableIfaceObj
  GtkActivatableIfaceObj* = object 
    g_iface*: gobject.GTypeInterfaceObj
'
j='type 
  GtkActivatableIface* =  ptr GtkActivatableIfaceObj
  GtkActivatableIfacePtr* = ptr GtkActivatableIfaceObj
  GtkActivatableIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkAlignment* =  ptr GtkAlignmentObj
  GtkAlignmentPtr* = ptr GtkAlignmentObj
  GtkAlignmentObj* = object 
    bin*: GtkBinObj
    priv129: ptr GtkAlignmentPrivateObj
'
j='type 
  GtkAlignment* =  ptr GtkAlignmentObj
  GtkAlignmentPtr* = ptr GtkAlignmentObj
  GtkAlignmentObj*{.final.} = object of GtkBinObj
    priv129: ptr GtkAlignmentPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkHandleBox* =  ptr GtkHandleBoxObj
  GtkHandleBoxPtr* = ptr GtkHandleBoxObj
  GtkHandleBoxObj* = object 
    bin*: GtkBinObj
    priv133: ptr GtkHandleBoxPrivateObj
'
j='type 
  GtkHandleBox* =  ptr GtkHandleBoxObj
  GtkHandleBoxPtr* = ptr GtkHandleBoxObj
  GtkHandleBoxObj*{.final.} = object of GtkBinObj
    priv133: ptr GtkHandleBoxPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkHButtonBox* =  ptr GtkHButtonBoxObj
  GtkHButtonBoxPtr* = ptr GtkHButtonBoxObj
  GtkHButtonBoxObj* = object 
    button_box*: GtkButtonBoxObj
'
j='type 
  GtkHButtonBox* =  ptr GtkHButtonBoxObj
  GtkHButtonBoxPtr* = ptr GtkHButtonBoxObj
  GtkHButtonBoxObj*{.final.} = object of GtkButtonBoxObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkHPaned* =  ptr GtkHPanedObj
  GtkHPanedPtr* = ptr GtkHPanedObj
  GtkHPanedObj* = object 
    paned*: GtkPanedObj
'
j='type 
  GtkHPaned* =  ptr GtkHPanedObj
  GtkHPanedPtr* = ptr GtkHPanedObj
  GtkHPanedObj*{.final.} = object of GtkPanedObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkHScale* =  ptr GtkHScaleObj
  GtkHScalePtr* = ptr GtkHScaleObj
  GtkHScaleObj* = object 
    scale*: GtkScaleObj
'
j='type 
  GtkHScale* =  ptr GtkHScaleObj
  GtkHScalePtr* = ptr GtkHScaleObj
  GtkHScaleObj*{.final.} = object of GtkScaleObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkHScrollbar* =  ptr GtkHScrollbarObj
  GtkHScrollbarPtr* = ptr GtkHScrollbarObj
  GtkHScrollbarObj* = object 
    scrollbar*: GtkScrollbarObj
'
j='type 
  GtkHScrollbar* =  ptr GtkHScrollbarObj
  GtkHScrollbarPtr* = ptr GtkHScrollbarObj
  GtkHScrollbarObj*{.final.} = object of GtkScrollbarObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkHSeparator* =  ptr GtkHSeparatorObj
  GtkHSeparatorPtr* = ptr GtkHSeparatorObj
  GtkHSeparatorObj* = object 
    separator*: GtkSeparatorObj
'
j='type 
  GtkHSeparator* =  ptr GtkHSeparatorObj
  GtkHSeparatorPtr* = ptr GtkHSeparatorObj
  GtkHSeparatorObj*{.final.} = object of GtkSeparatorObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkImageMenuItem* =  ptr GtkImageMenuItemObj
  GtkImageMenuItemPtr* = ptr GtkImageMenuItemObj
  GtkImageMenuItemObj* = object 
    menu_item*: GtkMenuItemObj
    priv135: ptr GtkImageMenuItemPrivateObj
'
j='type 
  GtkImageMenuItem* =  ptr GtkImageMenuItemObj
  GtkImageMenuItemPtr* = ptr GtkImageMenuItemObj
  GtkImageMenuItemObj*{.final.} = object of GtkMenuItemObj
    priv135: ptr GtkImageMenuItemPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkTable* =  ptr GtkTableObj
  GtkTablePtr* = ptr GtkTableObj
  GtkTableObj* = object 
    container*: GtkContainerObj
    priv139: ptr GtkTablePrivateObj
'
j='type 
  GtkTable* =  ptr GtkTableObj
  GtkTablePtr* = ptr GtkTableObj
  GtkTableObj*{.final.} = object of GtkContainerObj
    priv139: ptr GtkTablePrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkTableChild* =  ptr GtkTableChildObj
  GtkTableChildPtr* = ptr GtkTableChildObj
  GtkTableChildObj* = object 
    widget*: GtkWidget
    left_attach*: guint16
    right_attach*: guint16
    top_attach*: guint16
    bottom_attach*: guint16
    xpadding*: guint16
    ypadding*: guint16
    bitfield6*: guint
'
j='type 
  GtkTableChild* =  ptr GtkTableChildObj
  GtkTableChildPtr* = ptr GtkTableChildObj
  GtkTableChildObj*{.final.} = object of GtkWidget
    left_attach*: guint16
    right_attach*: guint16
    top_attach*: guint16
    bottom_attach*: guint16
    xpadding*: guint16
    ypadding*: guint16
    bitfield6*: guint
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkTearoffMenuItem* =  ptr GtkTearoffMenuItemObj
  GtkTearoffMenuItemPtr* = ptr GtkTearoffMenuItemObj
  GtkTearoffMenuItemObj* = object 
    menu_item*: GtkMenuItemObj
    priv140: ptr GtkTearoffMenuItemPrivateObj
'
j='type 
  GtkTearoffMenuItem* =  ptr GtkTearoffMenuItemObj
  GtkTearoffMenuItemPtr* = ptr GtkTearoffMenuItemObj
  GtkTearoffMenuItemObj*{.final.} = object of GtkMenuItemObj
    priv140: ptr GtkTearoffMenuItemPrivateObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkVButtonBox* =  ptr GtkVButtonBoxObj
  GtkVButtonBoxPtr* = ptr GtkVButtonBoxObj
  GtkVButtonBoxObj* = object 
    button_box*: GtkButtonBoxObj
'
j='type 
  GtkVButtonBox* =  ptr GtkVButtonBoxObj
  GtkVButtonBoxPtr* = ptr GtkVButtonBoxObj
  GtkVButtonBoxObj*{.final.} = object of GtkButtonBoxObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkVPaned* =  ptr GtkVPanedObj
  GtkVPanedPtr* = ptr GtkVPanedObj
  GtkVPanedObj* = object 
    paned*: GtkPanedObj
'
j='type 
  GtkVPaned* =  ptr GtkVPanedObj
  GtkVPanedPtr* = ptr GtkVPanedObj
  GtkVPanedObj*{.final.} = object of GtkPanedObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkVScale* =  ptr GtkVScaleObj
  GtkVScalePtr* = ptr GtkVScaleObj
  GtkVScaleObj* = object 
    scale*: GtkScaleObj
'
j='type 
  GtkVScale* =  ptr GtkVScaleObj
  GtkVScalePtr* = ptr GtkVScaleObj
  GtkVScaleObj*{.final.} = object of GtkScaleObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkVScrollbar* =  ptr GtkVScrollbarObj
  GtkVScrollbarPtr* = ptr GtkVScrollbarObj
  GtkVScrollbarObj* = object 
    scrollbar*: GtkScrollbarObj
'
j='type 
  GtkVScrollbar* =  ptr GtkVScrollbarObj
  GtkVScrollbarPtr* = ptr GtkVScrollbarObj
  GtkVScrollbarObj*{.final.} = object of GtkScrollbarObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GtkVSeparator* =  ptr GtkVSeparatorObj
  GtkVSeparatorPtr* = ptr GtkVSeparatorObj
  GtkVSeparatorObj* = object 
    separator*: GtkSeparatorObj
'
j='type 
  GtkVSeparator* =  ptr GtkVSeparatorObj
  GtkVSeparatorPtr* = ptr GtkVSeparatorObj
  GtkVSeparatorObj*{.final.} = object of GtkSeparatorObj
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

perl -p -i -e '$/ = "proc "; s/^\w+\*.*va_list.*}/discard """"$&"""\n/s' final.nim
sed -i 's/^proc discard """/\ndiscard """ proc /g' final.nim

# remove the list with deprecated entries from main file -- we add it later again.
i='{\.deprecated: \['
csplit final.nim "/$i/"
mv xx00 final.nim
mv xx01 dep.txt

# fix same return values
i='proc gtk_dialog_new_with_buttons*(title: ptr gchar; parent: GtkWindow; 
                                  flags: GtkDialogFlags; 
                                  first_button_text: ptr gchar): GtkWidget {.
    varargs, importc: "gtk_dialog_new_with_buttons", libgtk.}
'
j='proc gtk_dialog_new_with_buttons*(title: ptr gchar; parent: GtkWindow; 
                                  flags: GtkDialogFlags; 
                                  first_button_text: ptr gchar): GtkDialog {.
    varargs, importc: "gtk_dialog_new_with_buttons", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc add_button*(dialog: GtkDialog; button_text: ptr gchar; 
                            response_id: gint): GtkWidget {.
    importc: "gtk_dialog_add_button", libgtk.}
'
j='proc add_button*(dialog: GtkDialog; button_text: ptr gchar; 
                            response_id: gint): GtkButton {.
    importc: "gtk_dialog_add_button", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_widget_for_response*(dialog: GtkDialog; 
    response_id: gint): GtkWidget {.
    importc: "gtk_dialog_get_widget_for_response", libgtk.}
'
j='proc get_widget_for_response*(dialog: GtkDialog; 
    response_id: gint): GtkButton {.
    importc: "gtk_dialog_get_widget_for_response", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_header_bar*(dialog: GtkDialog): GtkWidget {.
    importc: "gtk_dialog_get_header_bar", libgtk.}
'
j='proc get_header_bar*(dialog: GtkDialog): GtkHeaderBar {.
    importc: "gtk_dialog_get_header_bar", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_selected_item*(menu_shell: GtkMenuShell): GtkWidget {.
    importc: "gtk_menu_shell_get_selected_item", libgtk.}
'
j='proc get_selected_item*(menu_shell: GtkMenuShell): GtkMenuItem {.
    importc: "gtk_menu_shell_get_selected_item", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_parent_shell*(menu_shell: GtkMenuShell): GtkWidget {.
    importc: "gtk_menu_shell_get_parent_shell", libgtk.}
'
j='proc get_parent_shell*(menu_shell: GtkMenuShell): GtkMenuShell {.
    importc: "gtk_menu_shell_get_parent_shell", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_active*(menu: GtkMenu): GtkWidget {.
    importc: "gtk_menu_get_active", libgtk.}
'
j='proc get_active*(menu: GtkMenu): GtkMenuItem {.
    importc: "gtk_menu_get_active", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_widget*(self: GtkAppChooserDialog): GtkWidget {.
    importc: "gtk_app_chooser_dialog_get_widget", libgtk.}
'
j='proc get_widget*(self: GtkAppChooserDialog): GtkButton {.
    importc: "gtk_app_chooser_dialog_get_widget", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_tree_view*(tree_column: GtkTreeViewColumn): GtkWidget {.
    importc: "gtk_tree_view_column_get_tree_view", libgtk.}
'
j='proc get_tree_view*(tree_column: GtkTreeViewColumn): GtkTreeView {.
    importc: "gtk_tree_view_column_get_tree_view", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_button*(tree_column: GtkTreeViewColumn): GtkWidget {.
    importc: "gtk_tree_view_column_get_button", libgtk.}
'
j='proc get_button*(tree_column: GtkTreeViewColumn): GtkButton {.
    importc: "gtk_tree_view_column_get_button", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_entry*(completion: GtkEntryCompletion): GtkWidget {.
    importc: "gtk_entry_completion_get_entry", libgtk.}
'
j='proc get_entry*(completion: GtkEntryCompletion): GtkEntry {.
    importc: "gtk_entry_completion_get_entry", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_label_widget*(frame: GtkFrame): GtkWidget {.
    importc: "gtk_frame_get_label_widget", libgtk.}
'
j='proc get_label_widget*(frame: GtkFrame): GtkLabel {.
    importc: "gtk_frame_get_label_widget", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_image*(button: GtkButton): GtkWidget {.
    importc: "gtk_button_get_image", libgtk.}
'
j='proc get_image*(button: GtkButton): GtkImage {.
    importc: "gtk_button_get_image", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_submenu*(menu_item: GtkMenuItem): GtkWidget {.
    importc: "gtk_menu_item_get_submenu", libgtk.}
'
j='proc get_submenu*(menu_item: GtkMenuItem): GtkMenuItem {.
    importc: "gtk_menu_item_get_submenu", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_label_widget*(expander: GtkExpander): GtkWidget {.
    importc: "gtk_expander_get_label_widget", libgtk.}
'
j='proc get_label_widget*(expander: GtkExpander): GtkLabel {.
    importc: "gtk_expander_get_label_widget", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc gtk_file_chooser_dialog_new*(title: ptr gchar; parent: GtkWindow; 
                                  action: GtkFileChooserAction; 
                                  first_button_text: ptr gchar): GtkWidget {.
    varargs, importc: "gtk_file_chooser_dialog_new", libgtk.}
'
j='proc gtk_file_chooser_dialog_new*(title: ptr gchar; parent: GtkWindow; 
                                  action: GtkFileChooserAction; 
                                  first_button_text: ptr gchar): GtkFileChooserDialog {.
    varargs, importc: "gtk_file_chooser_dialog_new", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc add_button*(info_bar: GtkInfoBar; 
                              button_text: ptr gchar; response_id: gint): GtkWidget {.
    importc: "gtk_info_bar_add_button", libgtk.}
'
j='proc add_button*(info_bar: GtkInfoBar; 
                              button_text: ptr gchar; response_id: gint): GtkButton {.
    importc: "gtk_info_bar_add_button", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc retrieve_proxy_menu_item*(tool_item: GtkToolItem): GtkWidget {.
    importc: "gtk_tool_item_retrieve_proxy_menu_item", libgtk.}
'
j='proc retrieve_proxy_menu_item*(tool_item: GtkToolItem): GtkMenuItem {.
    importc: "gtk_tool_item_retrieve_proxy_menu_item", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_proxy_menu_item*(tool_item: GtkToolItem; 
    menu_item_id: ptr gchar): GtkWidget {.
    importc: "gtk_tool_item_get_proxy_menu_item", libgtk.}
'
j='proc get_proxy_menu_item*(tool_item: GtkToolItem; 
    menu_item_id: ptr gchar): GtkMenuItem {.
    importc: "gtk_tool_item_get_proxy_menu_item", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_icon_widget*(button: GtkToolButton): GtkWidget {.
    importc: "gtk_tool_button_get_icon_widget", libgtk.}
'
j='proc get_icon_widget*(button: GtkToolButton): GtkImage {.
    importc: "gtk_tool_button_get_icon_widget", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_label_widget*(button: GtkToolButton): GtkWidget {.
    importc: "gtk_tool_button_get_label_widget", libgtk.}
'
j='proc get_label_widget*(button: GtkToolButton): GtkLabel {.
    importc: "gtk_tool_button_get_label_widget", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_menu*(button: GtkMenuToolButton): GtkWidget {.
    importc: "gtk_menu_tool_button_get_menu", libgtk.}
'
j='proc get_menu*(button: GtkMenuToolButton): GtkMenu {.
    importc: "gtk_menu_tool_button_get_menu", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc gtk_message_dialog_new*(parent: GtkWindow; flags: GtkDialogFlags; 
                             `type`: GtkMessageType; buttons: GtkButtonsType; 
                             message_format: ptr gchar): GtkWidget {.
    varargs, importc: "gtk_message_dialog_new", libgtk.}
'
j='proc gtk_message_dialog_new*(parent: GtkWindow; flags: GtkDialogFlags; 
                             `type`: GtkMessageType; buttons: GtkButtonsType; 
                             message_format: ptr gchar): GtkMessageDialog {.
    varargs, importc: "gtk_message_dialog_new", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc gtk_message_dialog_new_with_markup*(parent: GtkWindow; 
    flags: GtkDialogFlags; `type`: GtkMessageType; buttons: GtkButtonsType; 
    message_format: ptr gchar): GtkWidget {.varargs, 
    importc: "gtk_message_dialog_new_with_markup", libgtk.}
'
j='proc gtk_message_dialog_new_with_markup*(parent: GtkWindow; 
    flags: GtkDialogFlags; `type`: GtkMessageType; buttons: GtkButtonsType; 
    message_format: ptr gchar): GtkMessageDialog {.varargs, 
    importc: "gtk_message_dialog_new_with_markup", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_image*(dialog: GtkMessageDialog): GtkWidget {.
    importc: "gtk_message_dialog_get_image", libgtk.}
'
j='proc get_image*(dialog: GtkMessageDialog): GtkImage {.
    importc: "gtk_message_dialog_get_image", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_tab_label*(notebook: GtkNotebook; 
                                 child: GtkWidget): GtkWidget {.
    importc: "gtk_notebook_get_tab_label", libgtk.}
'
j='proc get_tab_label*(notebook: GtkNotebook; 
                                 child: GtkWidget): GtkLabel {.
    importc: "gtk_notebook_get_tab_label", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_tab_label*(notebook: GtkNotebook; 
                                 child: GtkWidget): GtkWidget {.
    importc: "gtk_notebook_get_tab_label", libgtk.}
'
j='proc get_tab_label*(notebook: GtkNotebook; 
                                 child: GtkWidget): GtkLabel {.
    importc: "gtk_notebook_get_tab_label", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_menu_label*(notebook: GtkNotebook; 
                                  child: GtkWidget): GtkWidget {.
    importc: "gtk_notebook_get_menu_label", libgtk.}
'
j='proc get_menu_label*(notebook: GtkNotebook; 
                                  child: GtkWidget): GtkLabel {.
    importc: "gtk_notebook_get_menu_label", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc gtk_recent_chooser_dialog_new_for_manager*(title: ptr gchar; 
    parent: GtkWindow; manager: GtkRecentManager; 
    first_button_text: ptr gchar): GtkWidget {.varargs, 
    importc: "gtk_recent_chooser_dialog_new_for_manager", libgtk.}
'
j='proc gtk_recent_chooser_dialog_new_for_manager*(title: ptr gchar; 
    parent: GtkWindow; manager: GtkRecentManager; 
    first_button_text: ptr gchar): GtkRecentChooserDialog {.varargs, 
    importc: "gtk_recent_chooser_dialog_new_for_manager", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_plus_button*(button: GtkScaleButton): GtkWidget {.
    importc: "gtk_scale_button_get_plus_button", libgtk.}
'
j='proc get_plus_button*(button: GtkScaleButton): GtkButton {.
    importc: "gtk_scale_button_get_plus_button", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_minus_button*(button: GtkScaleButton): GtkWidget {.
    importc: "gtk_scale_button_get_minus_button", libgtk.}
'
j='proc get_minus_button*(button: GtkScaleButton): GtkButton {.
    importc: "gtk_scale_button_get_minus_button", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_hscrollbar*(
    scrolled_window: GtkScrolledWindow): GtkWidget {.
    importc: "gtk_scrolled_window_get_hscrollbar", libgtk.}
'
j='proc get_hscrollbar*(
    scrolled_window: GtkScrolledWindow): GtkHScrollbar {.
    importc: "gtk_scrolled_window_get_hscrollbar", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_vscrollbar*(
    scrolled_window: GtkScrolledWindow): GtkWidget {.
    importc: "gtk_scrolled_window_get_vscrollbar", libgtk.}
'
j='proc get_vscrollbar*(
    scrolled_window: GtkScrolledWindow): GtkVScrollbar {.
    importc: "gtk_scrolled_window_get_vscrollbar", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_label_widget*(group: GtkToolItemGroup): GtkWidget {.
    importc: "gtk_tool_item_group_get_label_widget", libgtk.}
'
j='proc get_label_widget*(group: GtkToolItemGroup): GtkLabel {.
    importc: "gtk_tool_item_group_get_label_widget", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc create_menu_item*(action: GtkAction): GtkWidget {.
    importc: "gtk_action_create_menu_item", libgtk.}
'
j='proc create_menu_item*(action: GtkAction): GtkMenuItem {.
    importc: "gtk_action_create_menu_item", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc create_tool_item*(action: GtkAction): GtkWidget {.
    importc: "gtk_action_create_tool_item", libgtk.}

'
j='proc create_tool_item*(action: GtkAction): GtkToolItem {.
    importc: "gtk_action_create_tool_item", libgtk.}

'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc create_menu*(action: GtkAction): GtkWidget {.
    importc: "gtk_action_create_menu", libgtk.}
'
j='proc create_menu*(action: GtkAction): GtkMenu {.
    importc: "gtk_action_create_menu", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_color_selection*(
    colorsel: GtkColorSelectionDialog): GtkWidget {.
    importc: "gtk_color_selection_dialog_get_color_selection", libgtk.}
'
j='proc get_color_selection*(
    colorsel: GtkColorSelectionDialog): GtkColorSelection {.
    importc: "gtk_color_selection_dialog_get_color_selection", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_size_entry*(fontsel: GtkFontSelection): GtkWidget {.
    importc: "gtk_font_selection_get_size_entry", libgtk.}
'
j='proc get_size_entry*(fontsel: GtkFontSelection): GtkEntry {.
    importc: "gtk_font_selection_get_size_entry", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_preview_entry*(fontsel: GtkFontSelection): GtkWidget {.
    importc: "gtk_font_selection_get_preview_entry", libgtk.}
'
j='proc get_preview_entry*(fontsel: GtkFontSelection): GtkEntry {.
    importc: "gtk_font_selection_get_preview_entry", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_ok_button*(fsd: GtkFontSelectionDialog): GtkWidget {.
    importc: "gtk_font_selection_dialog_get_ok_button", libgtk.}
'
j='proc get_ok_button*(fsd: GtkFontSelectionDialog): GtkButton {.
    importc: "gtk_font_selection_dialog_get_ok_button", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_cancel_button*(
    fsd: GtkFontSelectionDialog): GtkWidget {.
    importc: "gtk_font_selection_dialog_get_cancel_button", libgtk.}
'
j='proc get_cancel_button*(
    fsd: GtkFontSelectionDialog): GtkButton {.
    importc: "gtk_font_selection_dialog_get_cancel_button", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_font_selection*(
    fsd: GtkFontSelectionDialog): GtkWidget {.
    importc: "gtk_font_selection_dialog_get_font_selection", libgtk.}
'
j='proc get_font_selection*(
    fsd: GtkFontSelectionDialog): GtkFontSelection {.
    importc: "gtk_font_selection_dialog_get_font_selection", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_image*(image_menu_item: GtkImageMenuItem): GtkWidget {.
    importc: "gtk_image_menu_item_get_image", libgtk.}
'
j='proc get_image*(image_menu_item: GtkImageMenuItem): GtkImage {.
    importc: "gtk_image_menu_item_get_image", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

# generate procs without get_ and set_ prefix
perl -0777 -p -i -e "s/(\n\s*)(proc set_)(\w+)(\*\([^}]*\) {[^}]*})/\$&\1proc \`\3=\`\4/sg" final.nim
perl -0777 -p -i -e "s/(\n\s*)(proc get_)(\w+)(\*\([^}]*\): \w[^}]*})/\$&\1proc \3\4/sg" final.nim

sed -i 's/proc object\b/proc `object`/g'  final.nim

sed -i 's/when not(defined(GTK_DISABLE_DEPRECATED)):/when not GTK_DISABLE_DEPRECATED:/g'  final.nim
sed -i 's/when not(defined(GDK_MULTIHEAD_SAFE)):/when not GDK_MULTIHEAD_SAFE:/g'  final.nim
sed -i 's/when defined(G_OS_WIN32):/when defined(Windows):/g'  final.nim

i='when defined(ENABLE_NLS): 
  template p(String: expr): expr = 
    g_dgettext(GETTEXT_PACKAGE, "-properties", String)

else: 
  template p(String: expr): expr = 
    (String)

template i(string: expr): expr = 
  g_intern_static_string(string)
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim

i='type 
  GtkStock* = cstring
'
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim

sed -i 's/(cast\[GtkStock\](\(".*"\)))/\1/g'  final.nim

sed -i 's/\(dummy[0-9]\{0,2\}\)\*/\1/g' final.nim
sed -i 's/\(reserved[0-9]\{0,2\}\)\*/\1/g' final.nim

sed -i 's/[(][(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/(\1/g' final.nim
sed -i 's/, [(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/, \1/g' final.nim

sed -i 's/\([,=(<>] \{0,1\}\)[(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/\1\2/g' final.nim
sed -i '/^ \? \?#type $/d' final.nim
sed -i 's/\bgobject\.GObjectObj\b/GObjectObj/g' final.nim
sed -i 's/\bgobject\.GObject\b/GObject/g' final.nim
sed -i 's/\bgobject\.GObjectClassObj\b/GObjectClassObj/g' final.nim

sed -i 's/ ptr gchar\b/ cstring/g' final.nim

# the gobject lower case templates
sed -i 's/\bG_TYPE_CHECK_CLASS_TYPE\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_CHECK_CLASS_CAST\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_INSTANCE_GET_CLASS\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_CHECK_INSTANCE_CAST\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_CHECK_INSTANCE_TYPE\b/\L&/g' final.nim
sed -i 's/\bG_TYPE_INSTANCE_GET_INTERFACE\b/\L&/g' final.nim

# yes, apply multiple times!
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gu?int\d?\d?)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cint)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gfloat)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gfloat)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gdk3\.ModifierType)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gboolean)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cstring)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( guchar)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( gpointer)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( GtkSortType)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( GtkIconSize)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( GtkTreeViewDropPosition)/\1\2\3\4var\6/sg' final.nim

sed -i 's/: ptr var /: var ptr /g' final.nim
sed -i 's/\(0x\)0*\([0123456789ABCDEF]\)/\1\2/g' final.nim

sed -i "s/\(^\s*proc \)gtk_/\1/g" final.nim

sed -i 's/gdk3\.Window/gdk3Window/g' final.nim
ruby ../mangler.rb final.nim Gtk
sed -i 's/gdk3Window/gdk3.Window/g' final.nim

ruby ../mangler.rb final.nim GTK_

i='  const 
    STOCK_DIALOG_AUTHENTICATION* = (
      cast[Stock]("gtk-dialog-authentication"))
'
j='  const STOCK_DIALOG_AUTHENTICATION* = "gtk-dialog-authentication"
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='  const 
    STOCK_ORIENTATION_PORTRAIT* = (
      cast[Stock]("gtk-orientation-portrait"))
  const 
    STOCK_ORIENTATION_LANDSCAPE* = (
      cast[Stock]("gtk-orientation-landscape"))
  const 
    STOCK_ORIENTATION_REVERSE_LANDSCAPE* = (
      cast[Stock]("gtk-orientation-reverse-landscape"))
  const 
    STOCK_ORIENTATION_REVERSE_PORTRAIT* = (
      cast[Stock]("gtk-orientation-reverse-portrait"))
'
j='  const
    STOCK_ORIENTATION_PORTRAIT* = "gtk-orientation-portrait"
  const 
    STOCK_ORIENTATION_LANDSCAPE* = "gtk-orientation-landscape"
  const 
    STOCK_ORIENTATION_REVERSE_LANDSCAPE* = "gtk-orientation-reverse-landscape"
  const 
    STOCK_ORIENTATION_REVERSE_PORTRAIT* = "gtk-orientation-reverse-portrait"
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='from gdk3 import Window

from glib import gint, guint, gboolean, gpointer, GQuark, guint16, guint32, gint16, GDestroyNotify, gdouble, gfloat, gsize, gssize, gunichar,
  guchar, glong, gulong, GTokenType, guint8, G_PRIORITY_HIGH_IDLE, G_MAXUSHORT, time_t
  
from gobject import GClosure, GObjectClassObj, GObjectObj, GObject, GType, GConnectFlags, GCallback
  
from gdk_pixbuf import GdkPixbuf

from cairo import Pattern, Context, Region

from pango import FontDescription, Layout, AttrList, Context, EllipsizeMode, WrapMode, Direction

from gio import GFile, GMenu, GMenuModel, GActionGroup, GAppInfo, GApplication, GApplicationClass, GMountOperation, GMountOperationClass,
  GEmblemedIcon, GEmblemedIconClass, GIcon, GPermission, GAsyncResult, GCancellable

#from atk import AtkObject, AtkObjectClass, AtkRelationSet, AtkRole, AtkCoordType
from atk import Object, ObjectClass, RelationSet, Role, CoordType

'
perl -0777 -p -i -e "s%IMPORTLIST%$i%s" final.nim

# fix a few enums manually
i='type 
  DirectionType* {.size: sizeof(cint), pure.} = enum 
    DIR_TAB_FORWARD, DIR_TAB_BACKWARD, DIR_UP, DIR_DOWN, 
    DIR_LEFT, DIR_RIGHT
'
j='type 
  DirectionType* {.size: sizeof(cint), pure.} = enum 
    TAB_FORWARD, TAB_BACKWARD, UP, DOWN, 
    LEFT, RIGHT
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  TextDirection* {.size: sizeof(cint), pure.} = enum 
    DIR_NONE, DIR_LTR, DIR_RTL
'
j='type 
  TextDirection* {.size: sizeof(cint), pure.} = enum 
    NONE, LTR, RTL
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  Justification* {.size: sizeof(cint), pure.} = enum 
    JUSTIFY_LEFT, JUSTIFY_RIGHT, JUSTIFY_CENTER, JUSTIFY_FILL
'
j='type 
  Justification* {.size: sizeof(cint), pure.} = enum 
    LEFT, RIGHT, CENTER, FILL
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  MenuDirectionType* {.size: sizeof(cint), pure.} = enum 
    DIR_PARENT, DIR_CHILD, DIR_NEXT, 
    DIR_PREV
'
j='type 
  MenuDirectionType* {.size: sizeof(cint), pure.} = enum 
    PARENT, CHILD, NEXT, 
    PREV
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  PositionType* {.size: sizeof(cint), pure.} = enum 
    POS_LEFT, POS_RIGHT, POS_TOP, POS_BOTTOM
'
j='type 
  PositionType* {.size: sizeof(cint), pure.} = enum 
    LEFT, RIGHT, TOP, BOTTOM
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  TreeViewGridLines* {.size: sizeof(cint), pure.} = enum 
    LINES_NONE, LINES_HORIZONTAL, 
    LINES_VERTICAL, LINES_BOTH
'
j='type 
  TreeViewGridLines* {.size: sizeof(cint), pure.} = enum 
    NONE, HORIZONTAL, 
    VERTICAL, BOTH
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  StateFlags* {.size: sizeof(cint), pure.} = enum 
    FLAG_NORMAL = 0, FLAG_ACTIVE = 1 shl 0, 
    FLAG_PRELIGHT = 1 shl 1, FLAG_SELECTED = 1 shl 2, 
    FLAG_INSENSITIVE = 1 shl 3, 
    FLAG_INCONSISTENT = 1 shl 4, FLAG_FOCUSED = 1 shl 5, 
    FLAG_BACKDROP = 1 shl 6, FLAG_DIR_LTR = 1 shl 7, 
    FLAG_DIR_RTL = 1 shl 8, FLAG_LINK = 1 shl 9, 
    FLAG_VISITED = 1 shl 10, FLAG_CHECKED = 1 shl 11
'
j='type 
  StateFlags* {.size: sizeof(cint), pure.} = enum 
    NORMAL = 0, ACTIVE = 1 shl 0, 
    PRELIGHT = 1 shl 1, SELECTED = 1 shl 2, 
    INSENSITIVE = 1 shl 3, 
    INCONSISTENT = 1 shl 4, FOCUSED = 1 shl 5, 
    BACKDROP = 1 shl 6, DIR_LTR = 1 shl 7, 
    DIR_RTL = 1 shl 8, LINK = 1 shl 9, 
    VISITED = 1 shl 10, CHECKED = 1 shl 11
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  PropagationPhase* {.size: sizeof(cint), pure.} = enum 
    PHASE_NONE, PHASE_CAPTURE, PHASE_BUBBLE, PHASE_TARGET
'
j='type 
  PropagationPhase* {.size: sizeof(cint), pure.} = enum 
    NONE, CAPTURE, BUBBLE, TARGET
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  WindowPosition* {.size: sizeof(cint), pure.} = enum 
    WIN_POS_NONE, WIN_POS_CENTER, WIN_POS_MOUSE, 
    WIN_POS_CENTER_ALWAYS, WIN_POS_CENTER_ON_PARENT
'
j='type 
  WindowPosition* {.size: sizeof(cint), pure.} = enum 
    NONE, CENTER, MOUSE, 
    CENTER_ALWAYS, CENTER_ON_PARENT
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  ArrowPlacement* {.size: sizeof(cint), pure.} = enum 
    ARROWS_BOTH, ARROWS_START, ARROWS_END
'
j='type 
  ArrowPlacement* {.size: sizeof(cint), pure.} = enum 
    BOTH, START, END
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  CellRendererState* {.size: sizeof(cint), pure.} = enum 
    SELECTED = 1 shl 0, PRELIT = 1 shl
        1, CELL_RENDERER_INSENSITIVE = 1 shl 2, 
    CELL_RENDERER_SORTED = 1 shl 3, CELL_RENDERER_FOCUSED = 1 shl 4, 
    CELL_RENDERER_EXPANDABLE = 1 shl 5, 
    CELL_RENDERER_EXPANDED = 1 shl 6
'
j='type 
  CellRendererState* {.size: sizeof(cint), pure.} = enum 
    SELECTED = 1 shl 0, PRELIT = 1 shl
        1, INSENSITIVE = 1 shl 2, 
    SORTED = 1 shl 3, FOCUSED = 1 shl 4, 
    EXPANDABLE = 1 shl 5, 
    EXPANDED = 1 shl 6
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  DestDefaults* {.size: sizeof(cint), pure.} = enum 
    DEFAULT_MOTION = 1 shl 0, DEFAULT_HIGHLIGHT = 1 shl 1, 
    DEFAULT_DROP = 1 shl 2, DEFAULT_ALL = 0x7
'
j='type 
  DestDefaults* {.size: sizeof(cint), pure.} = enum 
    MOTION = 1 shl 0, HIGHLIGHT = 1 shl 1, 
    DROP = 1 shl 2, ALL = 0x7
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  ButtonBoxStyle* {.size: sizeof(cint), pure.} = enum 
    BUTTONBOX_SPREAD = 1, BUTTONBOX_EDGE, BUTTONBOX_START, 
    BUTTONBOX_END, BUTTONBOX_CENTER, BUTTONBOX_EXPAND
'
j='type 
  ButtonBoxStyle* {.size: sizeof(cint), pure.} = enum 
    SPREAD = 1, EDGE, START, 
    END, CENTER, EXPAND
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='  IconViewDropPosition* {.size: sizeof(cint), pure.} = enum 
    NO_DROP, DROP_INTO, DROP_LEFT, 
    DROP_RIGHT, DROP_ABOVE, 
    DROP_BELOW
'
j='  IconViewDropPosition* {.size: sizeof(cint), pure.} = enum 
    NO_DROP, INTO, LEFT, 
    RIGHT, ABOVE, 
    BELOW
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  SpinButtonUpdatePolicy* {.size: sizeof(cint), pure.} = enum 
    UPDATE_ALWAYS, UPDATE_IF_VALID
'
j='type 
  SpinButtonUpdatePolicy* {.size: sizeof(cint), pure.} = enum 
    ALWAYS, IF_VALID
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  TextBufferTargetInfo* {.size: sizeof(cint), pure.} = enum 
    INFO_TEXT = - 3, 
    INFO_RICH_TEXT = - 2, 
    INFO_BUFFER_CONTENTS = - 1
'
j='type 
  TextBufferTargetInfo* {.size: sizeof(cint), pure.} = enum 
    TEXT = - 3, 
    RICH_TEXT = - 2, 
    BUFFER_CONTENTS = - 1
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='type 
  GApplicationFlags* {.size: sizeof(cint), pure.} = enum 
    NONE, G_APPLICATION_IS_SERVICE = (1 shl 0), 
    G_APPLICATION_IS_LAUNCHER = (1 shl 1), 
    G_APPLICATION_HANDLES_OPEN = (1 shl 2), 
    G_APPLICATION_HANDLES_COMMAND_LINE = (1 shl 3), 
    G_APPLICATION_SEND_ENVIRONMENT = (1 shl 4), 
    G_APPLICATION_NON_UNIQUE = (1 shl 5)
'
j='type 
  GApplicationFlags* {.size: sizeof(cint), pure.} = enum 
    NONE, IS_SERVICE = (1 shl 0), 
    IS_LAUNCHER = (1 shl 1), 
    HANDLES_OPEN = (1 shl 2), 
    HANDLES_COMMAND_LINE = (1 shl 3), 
    SEND_ENVIRONMENT = (1 shl 4), 
    NON_UNIQUE = (1 shl 5)
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

sed -i '/### "gtk/d' final.nim

sed -i 's/proc true\*/proc gtk_true*/g' final.nim
sed -i 's/proc false\*/proc gtk_false*/g' final.nim

ruby ../gen_proc_dep.rb final.nim

cp dep.txt dep1.txt
sed -i 's/Gtk//g' dep1.txt
cat dep1.txt >> final.nim

cp dep.txt dep1.txt
sed -i 's/ Gtk//g' dep1.txt
sed -i 's/PGtk/Gtk/g' dep1.txt
sed -i 's/TGtk\(\w\+\)/Gtk\1Obj/g' dep1.txt
cat dep1.txt >> final.nim

sed -i 's/ Gtk//g' dep.txt
cat dep.txt >> final.nim

# these procs may be missing  due to when clause
sed -i '/{\.deprecated: \[gtk_init_abi_check: init_abi_check\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gtk_init_check_abi_check: init_check_abi_check\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gtk_icon_size_lookup: lookup\]\.}/d' proc_dep_list

# there is some work left for tuning init stuff...
sed -i '/{\.deprecated: \[gtk_init: init\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gtk_init_check: init_check\]\.}/d' proc_dep_list
sed -i '/{\.deprecated: \[gtk_init_with_args: init_with_args\]\.}/d' proc_dep_list

# some procs with get_ prefix do not return something but need var objects instead of pointers:
# vim search term for candidates: proc get_.*\n\?.*\n\?.*) {
#
i='proc get_preferred_size*(widget: Widget; 
                                    minimum_size: Requisition; 
                                    natural_size: Requisition) {.
    importc: "gtk_widget_get_preferred_size", libgtk.}'
j='proc get_preferred_size*(widget: Widget; 
                                    minimum_size: var RequisitionObj; 
                                    natural_size: var RequisitionObj) {.
    importc: "gtk_widget_get_preferred_size", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_child_requisition*(widget: Widget; 
    requisition: Requisition) {.
    importc: "gtk_widget_get_child_requisition", libgtk.}'
j='proc get_child_requisition*(widget: Widget; 
    requisition: var RequisitionObj) {.
    importc: "gtk_widget_get_child_requisition", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_allocation*(widget: Widget; 
                                allocation: Allocation) {.
    importc: "gtk_widget_get_allocation", libgtk.}'
j='proc get_allocation*(widget: Widget; 
                                allocation: var AllocationObj) {.
    importc: "gtk_widget_get_allocation", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_clip*(widget: Widget; clip: Allocation) {.
    importc: "gtk_widget_get_clip", libgtk.}'
j='proc get_clip*(widget: Widget; clip: var AllocationObj) {.
    importc: "gtk_widget_get_clip", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_requisition*(widget: Widget; 
                                 requisition: Requisition) {.
    importc: "gtk_widget_get_requisition", libgtk.}'
j='proc get_requisition*(widget: Widget; 
                                 requisition: var RequisitionObj) {.
    importc: "gtk_widget_get_requisition", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_value*(tree_model: TreeModel; 
                               iter: TreeIter; column: gint; 
                               value: gobject.GValue) {.
    importc: "gtk_tree_model_get_value", libgtk.}'
j='proc get_value*(tree_model: TreeModel; 
                               iter: TreeIter; column: gint; 
                               value: var gobject.GValueObj) {.
    importc: "gtk_tree_model_get_value", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_preferred_size*(cell: CellRenderer; 
    widget: Widget; minimum_size: Requisition; 
    natural_size: Requisition) {.
    importc: "gtk_cell_renderer_get_preferred_size", libgtk.}'
j='proc get_preferred_size*(cell: CellRenderer; 
    widget: Widget; minimum_size: var RequisitionObj; 
    natural_size: var RequisitionObj) {.
    importc: "gtk_cell_renderer_get_preferred_size", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_aligned_area*(cell: CellRenderer; 
    widget: Widget; flags: CellRendererState; 
    cell_area: gdk3.Rectangle; aligned_area: gdk3.Rectangle) {.
    importc: "gtk_cell_renderer_get_aligned_area", libgtk.}'
j='proc get_aligned_area*(cell: CellRenderer; 
    widget: Widget; flags: CellRendererState; 
    cell_area: gdk3.Rectangle; aligned_area: var gdk3.RectangleObj) {.
    importc: "gtk_cell_renderer_get_aligned_area", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_cell_allocation*(area: CellArea; 
    context: CellAreaContext; widget: Widget; 
    renderer: CellRenderer; cell_area: gdk3.Rectangle; 
    allocation: gdk3.Rectangle) {.importc: "gtk_cell_area_get_cell_allocation", 
                                    libgtk.}'
j='proc get_cell_allocation*(area: CellArea; 
    context: CellAreaContext; widget: Widget; 
    renderer: CellRenderer; cell_area: gdk3.Rectangle; 
    allocation: var gdk3.RectangleObj) {.importc: "gtk_cell_area_get_cell_allocation", 
                                    libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_text_area*(entry: Entry; text_area: gdk3.Rectangle) {.
    importc: "gtk_entry_get_text_area", libgtk.}'
j='proc get_text_area*(entry: Entry; text_area: var gdk3.RectangleObj) {.
    importc: "gtk_entry_get_text_area", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_icon_area*(entry: Entry; 
                              icon_pos: EntryIconPosition; 
                              icon_area: gdk3.Rectangle) {.
    importc: "gtk_entry_get_icon_area", libgtk.}'
j='proc get_icon_area*(entry: Entry; 
                              icon_pos: EntryIconPosition; 
                              icon_area: var gdk3.RectangleObj) {.
    importc: "gtk_entry_get_icon_area", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_cell_area*(tree_view: TreeView; 
                                  path: TreePath; 
                                  column: TreeViewColumn; 
                                  rect: gdk3.Rectangle) {.
    importc: "gtk_tree_view_get_cell_area", libgtk.}'
j='proc get_cell_area*(tree_view: TreeView; 
                                  path: TreePath; 
                                  column: TreeViewColumn; 
                                  rect: var gdk3.RectangleObj) {.
    importc: "gtk_tree_view_get_cell_area", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_background_area*(tree_view: TreeView; 
    path: TreePath; column: TreeViewColumn; 
    rect: gdk3.Rectangle) {.importc: "gtk_tree_view_get_background_area", 
                              libgtk.}'
j='proc get_background_area*(tree_view: TreeView; 
    path: TreePath; column: TreeViewColumn; 
    rect: var gdk3.RectangleObj) {.importc: "gtk_tree_view_get_background_area", 
                              libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_visible_rect*(tree_view: TreeView; 
                                     visible_rect: gdk3.Rectangle) {.
    importc: "gtk_tree_view_get_visible_rect", libgtk.}'
j='proc get_visible_rect*(tree_view: TreeView; 
                                     visible_rect: var gdk3.RectangleObj) {.
    importc: "gtk_tree_view_get_visible_rect", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_color*(button: ColorButton; 
                                 color: gdk3.Color) {.
    importc: "gtk_color_button_get_color", libgtk.}'
j='proc get_color*(button: ColorButton; 
                                 color: var gdk3.ColorObj) {.
    importc: "gtk_color_button_get_color", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_rgba*(button: ColorButton; rgba: gdk3.RGBA) {.
    importc: "gtk_color_button_get_rgba", libgtk.}'
j='proc get_rgba*(button: ColorButton; rgba: var gdk3.RGBAObj) {.
    importc: "gtk_color_button_get_rgba", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_rgba*(chooser: ColorChooser; 
                                 color: gdk3.RGBA) {.
    importc: "gtk_color_chooser_get_rgba", libgtk.}'
j='proc get_rgba*(chooser: ColorChooser; 
                                 color: var gdk3.RGBAObj) {.
    importc: "gtk_color_chooser_get_rgba", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_property*(context: StyleContext; 
                                     property: cstring; 
                                     state: StateFlags; value: gobject.GValue) {.
    importc: "gtk_style_context_get_property", libgtk.}'
j='proc get_property*(context: StyleContext; 
                                     property: cstring; 
                                     state: StateFlags; value: var gobject.GValueObj) {.
    importc: "gtk_style_context_get_property", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_style_property*(context: StyleContext; 
    property_name: cstring; value: gobject.GValue) {.
    importc: "gtk_style_context_get_style_property", libgtk.}'
j='proc get_style_property*(context: StyleContext; 
    property_name: cstring; value: var gobject.GValueObj) {.
    importc: "gtk_style_context_get_style_property", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_color*(context: StyleContext; 
                                  state: StateFlags; color: gdk3.RGBA) {.
    importc: "gtk_style_context_get_color", libgtk.}'
j='proc get_color*(context: StyleContext; 
                                  state: StateFlags; color: var gdk3.RGBAObj) {.
    importc: "gtk_style_context_get_color", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_background_color*(context: StyleContext; 
    state: StateFlags; color: gdk3.RGBA) {.
    importc: "gtk_style_context_get_background_color", libgtk.}'
j='proc get_background_color*(context: StyleContext; 
    state: StateFlags; color: var gdk3.RGBAObj) {.
    importc: "gtk_style_context_get_background_color", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_border_color*(context: StyleContext; 
    state: StateFlags; color: gdk3.RGBA) {.
    importc: "gtk_style_context_get_border_color", libgtk.}'
j='proc get_border_color*(context: StyleContext; 
    state: StateFlags; color: var gdk3.RGBAObj) {.
    importc: "gtk_style_context_get_border_color", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_border*(context: StyleContext; 
                                   state: StateFlags; border: Border) {.
    importc: "gtk_style_context_get_border", libgtk.}'
j='proc get_border*(context: StyleContext; 
                                   state: StateFlags; border: var BorderObj) {.
    importc: "gtk_style_context_get_border", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_padding*(context: StyleContext; 
                                    state: StateFlags; 
                                    padding: Border) {.
    importc: "gtk_style_context_get_padding", libgtk.}'
j='proc get_padding*(context: StyleContext; 
                                    state: StateFlags; 
                                    padding: var BorderObj) {.
    importc: "gtk_style_context_get_padding", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_margin*(context: StyleContext; 
                                   state: StateFlags; margin: Border) {.
    importc: "gtk_style_context_get_margin", libgtk.}'
j='proc get_margin*(context: StyleContext; 
                                   state: StateFlags; margin: var BorderObj) {.
    importc: "gtk_style_context_get_margin", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_range_rect*(range: Range; 
                               range_rect: gdk3.Rectangle) {.
    importc: "gtk_range_get_range_rect", libgtk.}'
j='proc get_range_rect*(range: Range; 
                               range_rect: var gdk3.RectangleObj) {.
    importc: "gtk_range_get_range_rect", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_policy*(scrolled_window: ScrolledWindow; 
                                     hscrollbar_policy: ptr PolicyType; 
                                     vscrollbar_policy: ptr PolicyType) {.
    importc: "gtk_scrolled_window_get_policy", libgtk.}'
j='proc get_policy*(scrolled_window: ScrolledWindow; 
                                     hscrollbar_policy: var PolicyType; 
                                     vscrollbar_policy: var PolicyType) {.
    importc: "gtk_scrolled_window_get_policy", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_iter_at_line_offset*(buffer: TextBuffer; 
    iter: TextIter; line_number: gint; char_offset: gint) {.
    importc: "gtk_text_buffer_get_iter_at_line_offset", libgtk.}'
j='proc get_iter_at_line_offset*(buffer: TextBuffer; 
    iter: var TextIterObj; line_number: gint; char_offset: gint) {.
    importc: "gtk_text_buffer_get_iter_at_line_offset", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_iter_at_line_index*(buffer: TextBuffer; 
    iter: TextIter; line_number: gint; byte_index: gint) {.
    importc: "gtk_text_buffer_get_iter_at_line_index", libgtk.}'
j='proc get_iter_at_line_index*(buffer: TextBuffer; 
    iter: var TextIterObj; line_number: gint; byte_index: gint) {.
    importc: "gtk_text_buffer_get_iter_at_line_index", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_iter_at_offset*(buffer: TextBuffer; 
    iter: TextIter; char_offset: gint) {.
    importc: "gtk_text_buffer_get_iter_at_offset", libgtk.}'
j='proc get_iter_at_offset*(buffer: TextBuffer; 
    iter: var TextIterObj; char_offset: gint) {.
    importc: "gtk_text_buffer_get_iter_at_offset", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_iter_at_line*(buffer: TextBuffer; 
    iter: TextIter; line_number: gint) {.
    importc: "gtk_text_buffer_get_iter_at_line", libgtk.}'
j='proc get_iter_at_line*(buffer: TextBuffer; 
    iter: var TextIterObj; line_number: gint) {.
    importc: "gtk_text_buffer_get_iter_at_line", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_start_iter*(buffer: TextBuffer; 
                                     iter: TextIter) {.
    importc: "gtk_text_buffer_get_start_iter", libgtk.}'
j='proc get_start_iter*(buffer: TextBuffer; 
                                     iter: var TextIterObj) {.
    importc: "gtk_text_buffer_get_start_iter", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_end_iter*(buffer: TextBuffer; 
                                   iter: TextIter) {.
    importc: "gtk_text_buffer_get_end_iter", libgtk.}'
j='proc get_end_iter*(buffer: TextBuffer; 
                                   iter: var TextIterObj) {.
    importc: "gtk_text_buffer_get_end_iter", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_bounds*(buffer: TextBuffer; 
                                 start: TextIter; `end`: TextIter) {.
    importc: "gtk_text_buffer_get_bounds", libgtk.}'
j='proc get_bounds*(buffer: TextBuffer; 
                                 start: var TextIterObj; `end`: var TextIterObj) {.
    importc: "gtk_text_buffer_get_bounds", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_iter_at_mark*(buffer: TextBuffer; 
    iter: TextIter; mark: TextMark) {.
    importc: "gtk_text_buffer_get_iter_at_mark", libgtk.}'
j='proc get_iter_at_mark*(buffer: TextBuffer; 
    iter: var TextIterObj; mark: TextMark) {.
    importc: "gtk_text_buffer_get_iter_at_mark", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_iter_at_child_anchor*(buffer: TextBuffer; 
    iter: TextIter; anchor: TextChildAnchor) {.
    importc: "gtk_text_buffer_get_iter_at_child_anchor", libgtk.}'
j='proc get_iter_at_child_anchor*(buffer: TextBuffer; 
    iter: var TextIterObj; anchor: TextChildAnchor) {.
    importc: "gtk_text_buffer_get_iter_at_child_anchor", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_visible_rect*(text_view: TextView; 
                                     visible_rect: gdk3.Rectangle) {.
    importc: "gtk_text_view_get_visible_rect", libgtk.}'
j='proc get_visible_rect*(text_view: TextView; 
                                     visible_rect: var gdk3.RectangleObj) {.
    importc: "gtk_text_view_get_visible_rect", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_cursor_locations*(text_view: TextView; 
    iter: TextIter; strong: gdk3.Rectangle; weak: gdk3.Rectangle) {.
    importc: "gtk_text_view_get_cursor_locations", libgtk.}'
j='proc get_cursor_locations*(text_view: TextView; 
    iter: TextIter; strong: var gdk3.RectangleObj; weak: var gdk3.RectangleObj) {.
    importc: "gtk_text_view_get_cursor_locations", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_iter_location*(text_view: TextView; 
                                      iter: TextIter; 
                                      location: gdk3.Rectangle) {.
    importc: "gtk_text_view_get_iter_location", libgtk.}'
j='proc get_iter_location*(text_view: TextView; 
                                      iter: TextIter; 
                                      location: var gdk3.RectangleObj) {.
    importc: "gtk_text_view_get_iter_location", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_iter_at_location*(text_view: TextView; 
    iter: TextIter; x: gint; y: gint) {.
    importc: "gtk_text_view_get_iter_at_location", libgtk.}'
j='proc get_iter_at_location*(text_view: TextView; 
    iter: var TextIterObj; x: gint; y: gint) {.
    importc: "gtk_text_view_get_iter_at_location", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_iter_at_position*(text_view: TextView; 
    iter: TextIter; trailing: var gint; x: gint; y: gint) {.
    importc: "gtk_text_view_get_iter_at_position", libgtk.}'
j='proc get_iter_at_position*(text_view: TextView; 
    iter: var TextIterObj; trailing: var gint; x: gint; y: gint) {.
    importc: "gtk_text_view_get_iter_at_position", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_current_rgba*(colorsel: ColorSelection; 
    rgba: gdk3.RGBA) {.importc: "gtk_color_selection_get_current_rgba", 
                         libgtk.}'
j='proc get_current_rgba*(colorsel: ColorSelection; 
    rgba: var gdk3.RGBAObj) {.importc: "gtk_color_selection_get_current_rgba", 
                         libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_previous_rgba*(colorsel: ColorSelection; 
    rgba: gdk3.RGBA) {.importc: "gtk_color_selection_get_previous_rgba", 
                         libgtk.}'
j='proc get_previous_rgba*(colorsel: ColorSelection; 
    rgba: var gdk3.RGBAObj) {.importc: "gtk_color_selection_get_previous_rgba", 
                         libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_current_color*(colorsel: ColorSelection; 
    color: gdk3.Color) {.importc: "gtk_color_selection_get_current_color", 
                           libgtk.}'
j='proc get_current_color*(colorsel: ColorSelection; 
    color: var gdk3.ColorObj) {.importc: "gtk_color_selection_get_current_color", 
                           libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_previous_color*(colorsel: ColorSelection; 
    color: gdk3.Color) {.importc: "gtk_color_selection_get_previous_color", 
                           libgtk.}'
j='proc get_previous_color*(colorsel: ColorSelection; 
    color: var gdk3.ColorObj) {.importc: "gtk_color_selection_get_previous_color", 
                           libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_style_property*(style: Style; widget_type: GType; 
                                   property_name: cstring; value: gobject.GValue) {.
    importc: "gtk_style_get_style_property", libgtk.}'
j='proc get_style_property*(style: Style; widget_type: GType; 
                                   property_name: cstring; value: var gobject.GValueObj) {.
    importc: "gtk_style_get_style_property", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_property*(engine: ThemingEngine; 
                                      property: cstring; 
                                      state: StateFlags; value: gobject.GValue) {.
    importc: "gtk_theming_engine_get_property", libgtk.}'
j='proc get_property*(engine: ThemingEngine; 
                                      property: cstring; 
                                      state: StateFlags; value: var gobject.GValueObj) {.
    importc: "gtk_theming_engine_get_property", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_style_property*(engine: ThemingEngine; 
    property_name: cstring; value: gobject.GValue) {.
    importc: "gtk_theming_engine_get_style_property", libgtk.}'
j='proc get_style_property*(engine: ThemingEngine; 
    property_name: cstring; value: var gobject.GValueObj) {.
    importc: "gtk_theming_engine_get_style_property", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_color*(engine: ThemingEngine; 
                                   state: StateFlags; color: gdk3.RGBA) {.
    importc: "gtk_theming_engine_get_color", libgtk.}'
j='proc get_color*(engine: ThemingEngine; 
                                   state: StateFlags; color: var gdk3.RGBAObj) {.
    importc: "gtk_theming_engine_get_color", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_background_color*(engine: ThemingEngine; 
    state: StateFlags; color: gdk3.RGBA) {.
    importc: "gtk_theming_engine_get_background_color", libgtk.}'
j='proc get_background_color*(engine: ThemingEngine; 
    state: StateFlags; color: var gdk3.RGBAObj) {.
    importc: "gtk_theming_engine_get_background_color", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_border_color*(engine: ThemingEngine; 
    state: StateFlags; color: gdk3.RGBA) {.
    importc: "gtk_theming_engine_get_border_color", libgtk.}'
j='proc get_border_color*(engine: ThemingEngine; 
    state: StateFlags; color: var gdk3.RGBAObj) {.
    importc: "gtk_theming_engine_get_border_color", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_border*(engine: ThemingEngine; 
                                    state: StateFlags; 
                                    border: Border) {.
    importc: "gtk_theming_engine_get_border", libgtk.}'
j='proc get_border*(engine: ThemingEngine; 
                                    state: StateFlags; 
                                    border: var BorderObj) {.
    importc: "gtk_theming_engine_get_border", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_padding*(engine: ThemingEngine; 
                                     state: StateFlags; 
                                     padding: Border) {.
    importc: "gtk_theming_engine_get_padding", libgtk.}'
j='proc get_padding*(engine: ThemingEngine; 
                                     state: StateFlags; 
                                     padding: var BorderObj) {.
    importc: "gtk_theming_engine_get_padding", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_margin*(engine: ThemingEngine; 
                                    state: StateFlags; 
                                    margin: Border) {.
    importc: "gtk_theming_engine_get_margin", libgtk.}'
j='proc get_margin*(engine: ThemingEngine; 
                                    state: StateFlags; 
                                    margin: var BorderObj) {.
    importc: "gtk_theming_engine_get_margin", libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='proc get_cell_area*(
    parent: CellAccessibleParent; cell: CellAccessible; 
    cell_rect: gdk3.Rectangle) {.importc: "gtk_cell_accessible_parent_get_cell_area", 
                                   libgtk.}'
j='proc get_cell_area*(
    parent: CellAccessibleParent; cell: CellAccessible; 
    cell_rect: var gdk3.RectangleObj) {.importc: "gtk_cell_accessible_parent_get_cell_area", 
                                   libgtk.}'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim
# ---

l='type 
  MenuItemPrivateObj = object 
  
type 
  MenuItem* =  ptr MenuItemObj
  MenuItemPtr* = ptr MenuItemObj
  MenuItemObj* = object of BinObj
    priv54: ptr MenuItemPrivateObj
'
k='type 
  HeaderBar* =  ptr HeaderBarObj
  HeaderBarPtr* = ptr HeaderBarObj
  HeaderBarObj*{.final.} = object of ContainerObj
'
i='type 
  ButtonPrivateObj = object 
  
type 
  Button* =  ptr ButtonObj
  ButtonPtr* = ptr ButtonObj
  ButtonObj* = object of BinObj
    priv40: ptr ButtonPrivateObj
'
j='type 
  DialogPrivateObj = object 
  '
perl -0777 -p -i -e "s%\Q$l\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$k\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$j\E%$i$l$k$j%s" final.nim

i='type 
  TreeViewPrivateObj = object 
  
type 
  TreeView* =  ptr TreeViewObj
  TreeViewPtr* = ptr TreeViewObj
  TreeViewObj*{.final.} = object of ContainerObj
    priv31: ptr TreeViewPrivateObj
'
j='type 
  TreeViewColumnPrivateObj = object 
  '
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$j\E%$i$j%s" final.nim

i='type 
  EntryIconPosition* {.size: sizeof(cint), pure.} = enum 
    PRIMARY, SECONDARY
  EntryPrivateObj = object 
  
type 
  Entry* =  ptr EntryObj
  EntryPtr* = ptr EntryObj
  EntryObj = object of WidgetObj
    priv30: ptr EntryPrivateObj
'
j='type 
  EntryCompletionPrivateObj = object 
  '
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$j\E%$i$j%s" final.nim

i='type 
  HScrollbar* =  ptr HScrollbarObj
  HScrollbarPtr* = ptr HScrollbarObj
  HScrollbarObj*{.final.} = object of ScrollbarObj
'
j='type 
  VScrollbar* =  ptr VScrollbarObj
  VScrollbarPtr* = ptr VScrollbarObj
  VScrollbarObj*{.final.} = object of ScrollbarObj
'
k='type 
  ScrolledWindowPrivateObj = object 
  '
perl -0777 -p -i -e "s%\Q$i\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$j\E%%s" final.nim
perl -0777 -p -i -e "s%\Q$k\E%$i$j$k%s" final.nim

# use polymorphism instead of "new_with_label" suffix. Maybe better use for "with_mnemonic"?
perl -0777 -p -i -e "s/(\n\s*proc \w+_new)_with_label(\*\([^}]*})/\$&\1\2/sg" final.nim

# ---------------------
# finally we have to add some higher level stuff, maybe in a separate file?
# for example for radio buttons, or something like

i='proc window_new*(`type`: WindowType): Window {.
    importc: "gtk_window_new", libgtk.}
'
j='proc window_new*(`type`: WindowType = WindowType.TOPLEVEL): Window {.
    importc: "gtk_window_new", libgtk.}
'
perl -0777 -p -i -e "s%\Q$i\E%$j%s" final.nim

i='template gtk_radio_menu_item*(obj: expr): expr = 
  (g_type_check_instance_cast(obj, radio_menu_item_get_type(), 
                              RadioMenuItemObj))
'
j='
template radio_button_new*(): expr =
  new_from_widget(cast[RadioButton](0))

template radio_button_new*(label: cstring): expr =
  new_with_label_from_widget(cast[RadioButton](0), label)

template radio_button_new*(w: RadioButton, label: cstring): expr =
  new_with_label_from_widget(w, label)

template radio_button_new_with_mnemonic*(label: cstring): expr =
  new_with_mnemonic_from_widget(cast[PRadioButton](0), label)

template radio_button_new*(w: RadioButton): expr =
  new_from_widget(w)
'
perl -0777 -p -i -e "s%\Q$i\E%$j$i%s" final.nim

# allow use of TextIterObj as proc parameter without addr operator
i='proc text_tag_get_type*(): GType {.importc: "gtk_text_tag_get_type", 
    libgtk.}
'
j='converter TIO2TI(i: var TextIterObj): TextIter =
  addr(i)
'
perl -0777 -p -i -e "s%\Q$i\E%$j$i%s" final.nim

# ---------------------

sed -i 's/ptr cstring/cstringArray/g' final.nim

cat proc_dep_list >> final.nim

cat -s final.nim > gtk3.nim

#cleanup
rm final.h final.nim proc_dep_list dep.txt dep1.txt list.txt
rm -r gtk

exit

